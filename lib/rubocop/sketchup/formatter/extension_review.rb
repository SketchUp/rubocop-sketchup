# frozen_string_literal: true

require 'cgi'
require 'erb'
require 'ostruct'
require 'base64'
require 'rubocop/formatter/text_util'

module RuboCop
  module Formatter
    # This formatter saves the output as an html file.
    class ExtensionReviewFormatter < BaseFormatter
      ELLIPSES = '<span class="extra-code">...</span>'
      # Code that can't be parsed can't be checked by the SketchUp cops, so
      # these must be reported even though they aren't SketchUp cops.
      SYNTAX_COP_NAME = 'Lint/Syntax'
      TEMPLATE_PATH =
          File.expand_path('../../../../assets/output.html.erb', __dir__)

      attr_reader :categories, :files, :summary

      def initialize(output, options = {})
        super
        @categories = {}
        @files = []
        @summary = OpenStruct.new(offense_count: 0)
      end

      def started(target_files)
        summary.target_files = target_files
      end

      def file_finished(file, offenses)
        files << file
        offenses.each { |offense|
          # Report only SketchUp related cops, and syntax errors.
          next unless report_offense?(offense)

          report = OpenStruct.new(path: file, offense: offense)
          categories[offense.cop_name] ||= []
          categories[offense.cop_name] << report
          summary.offense_count += 1
        }
      end

      def report_offense?(offense)
        offense.cop_name.start_with?('Sketchup') ||
          offense.cop_name == SYNTAX_COP_NAME
      end
      private :report_offense?

      def finished(inspected_files)
        summary.inspected_files = inspected_files

        render_html
      end

      def render_html
        context = ERBContext.new(categories, files, summary)

        template = File.read(TEMPLATE_PATH, encoding: Encoding::UTF_8)
        erb = ERB.new(template, trim_mode: '-')
        html = erb.result(context.binding)

        output.write html
      end

      # This class provides helper methods used in the ERB template.
      class ERBContext
        include PathUtil
        include TextUtil

        LOGO_IMAGE_PATH =
            File.expand_path('../../../../assets/logo.png', __dir__)

        SORT_ORDER = %w[
          Lint
          SketchupRequirements
          SketchupDeprecations
          SketchupPerformance
          SketchupSuggestions
          SketchupBugs
        ].freeze

        SEVERITY_ORDER = %i[fatal error warning convention refactor info].freeze

        # Findings at these severities cause an extension to be rejected.
        BLOCKING_SEVERITIES = %i[fatal error].freeze

        DEPARTMENT_DESCRIPTIONS = {
          'Lint' => <<-DESCRIPTION,
            These files could not be parsed because of syntax errors. The
            other checks can't be run on them, so fix these first.
          DESCRIPTION
          'SketchupRequirements' => <<-DESCRIPTION,
            This is the most important set of checks. They represent a large
            part of the technical requirements an extension must pass in order
            to be hosted on Extension Warehouse.

            They have been designed to prevent extensions from conflicting with
            each other as well as avoiding bad side-effects for the end user.

            Please address these as soon as possible.
          DESCRIPTION
          'SketchupDeprecations' => <<-DESCRIPTION,
            This department checks for usage of deprecated features. It's
            recommended that you migrate your code away from deprecated features
            of the SketchUp API.

            This department is not a requirement for submission to
            Extension Warehouse.
          DESCRIPTION
          'SketchupPerformance' => <<-DESCRIPTION,
            This department looks for known patterns that have noticeable
            performance impact on SketchUp and/or your extension. It's worth
            looking into these warnings and investigate whether performance
            can be improved.

            This department is not a requirement for submission to
            Extension Warehouse.
          DESCRIPTION
          'SketchupSuggestions' => <<-DESCRIPTION,
            This department is a collection of suggestions for best practices
            that aim to improve the general quality of your extension.

            This department is not a requirement for submission to
            Extension Warehouse.
          DESCRIPTION
          'SketchupBugs' => <<-DESCRIPTION,
            This department warns about known bugs in the SketchUp API. It uses
            the TargetSketchUpVersion configuration to determine if the bug is
            relevant for your project. This department isn't a collection of all
            known bugs. But only a subset which can be reasonable detected..

            This department is not a requirement for submission to
            Extension Warehouse.
          DESCRIPTION
        }.freeze

        attr_reader :categories, :files, :summary

        def initialize(categories, files, summary)
          @raw_categories = categories
          @categories = sort_categories(group_categories(categories))
          @files = files.sort
          @summary = summary
        end

        def department(cop_name)
          cop_name.split('/').first
        end

        def department_description(cop_name)
          dep = department(cop_name)
          text = DEPARTMENT_DESCRIPTIONS[dep] || 'MISSING DESCRIPTION'
          format_plain_text(text)
        end

        def department_severity_counts(cop_name)
          dep = department(cop_name)
          reports = @raw_categories.select { |category, _|
            department(category) == dep
          }.values.flatten
          severity_counts(reports)
        end

        def department_location_count(cop_name)
          dep = department(cop_name)
          @raw_categories.sum { |category, reports|
            department(category) == dep ? reports.size : 0
          }
        end

        def category_severity_counts(category)
          severity_counts(@raw_categories.fetch(category))
        end

        def category_location_count(category)
          @raw_categories.fetch(category).size
        end

        def locations_for(reports)
          file_groups = reports.group_by(&:path).sort_by { |path, _| path.to_s }
          file_groups.map { |path, items|
            sorted_items = items.sort_by { |item| item.offense.location.line }
            lines = sorted_items.map { |item| item.offense.location.line }.uniq
            OpenStruct.new(
                path: path,
                reports: sorted_items,
                lines: lines
              )
          }
        end

        def blocking_count
          @raw_categories.values.flatten.count { |report|
            blocking_offense?(report.offense)
          }
        end

        def blocking?
          blocking_count.positive?
        end

        def blocking_offense?(offense)
          BLOCKING_SEVERITIES.include?(offense.severity.name)
        end

        # True once, for the first finding that doesn't block the extension, if
        # there are also blocking findings. The banner at the top of the report
        # explains this itself when there are none.
        def suggestions_note_due?(reports)
          return false if @suggestions_note_shown || !blocking?
          return false if blocking_offense?(reports.first.offense)

          @suggestions_note_shown = true
        end

        def suggestions_note
          '<div class="suggestions-note">The warnings and conventions below ' \
            'are only suggestions for improving your code. They won\'t ' \
            'cause a rejection.</div>'
        end

        def blocking_summary
          return 'No issues' unless blocking?

          "Will be rejected: #{pluralize(blocking_count, 'issue')} " \
            'to fix'
        end

        # The cops with blocking findings, in the same order as the report.
        def blocking_cop_names
          categories.select { |_cop_name, groups|
            groups.any? { |reports| blocking_offense?(reports.first.offense) }
          }.keys
        end

        def severity_summary
          labels = severity_counts(@raw_categories.values.flatten)
          labels.empty? ? 'no findings detected' : "#{labels} detected"
        end

        def severity_counts(reports)
          counts = reports.each_with_object(Hash.new(0)) do |report, totals|
            totals[report.offense.severity.name] += 1
          end
          severities = SEVERITY_ORDER + (counts.keys - SEVERITY_ORDER).sort
          labels = severities.each_with_object([]) do |severity, items|
            count = counts[severity]
            items << pluralize(count, severity.to_s) unless count.zero?
          end

          labels.join(', ')
        end

        def new_department?(cop_name)
          @processed_departments ||= Set.new
          dep = department(cop_name)
          unless @processed_departments.include?(dep)
            @processed_departments << dep
            return true
          end
          false
        end

        def format_plain_text(text)
          paragraphs = text.split(/(\n\r|\r\n|\r|\n){2,}/m)
          "<p>#{paragraphs.join('</p><p>')}</p>"
        end

        def sort_categories(categories)
          categories.sort { |a, b|
            # First sort departments by custom ordering (of importance).
            # Then sort by cop name.
            a_department, a_name = a[0].split('/')
            b_department, b_name = b[0].split('/')
            # Sort SketchUp cops at the top, then all the rest comes after.
            # First sorting by department.
            sort_order_a = SORT_ORDER.index(a_department)
            sort_order_b = SORT_ORDER.index(b_department)
            if sort_order_a.nil? && sort_order_b.nil?
              n = a_department <=> b_department
            else
              sort_order_a ||= SORT_ORDER.size
              sort_order_b ||= SORT_ORDER.size
              n = sort_order_a <=> sort_order_b
            end
            # Them sort by name if departments match.
            n == 0 ? a_name <=> b_name : n
          }.to_h
        end

        # Groups identical findings. Within a cop the most severe come first.
        def group_categories(categories)
          categories.transform_values do |reports|
            groups = reports.group_by { |report|
              [report.offense.severity.name, report.offense.message]
            }.values
            groups.sort_by.with_index { |group, index|
              [severity_rank(group.first.offense), index]
            }
          end
        end

        def severity_rank(offense)
          SEVERITY_ORDER.index(offense.severity.name) || SEVERITY_ORDER.size
        end

        # Make Kernel#binding public.
        def binding # rubocop:disable Lint/UselessMethodDefinition
          super
        end

        def decorated_message(offense)
          # Messages can contain text taken from the inspected source, so escape
          # them before adding any markup of our own.
          escape(offense.message)
            .gsub(/`(.+?)`/) do
              "<code>#{Regexp.last_match(1)}</code>"
            end
            .gsub(/\((http[^ ]+)\)/) do
              url = Regexp.last_match(1)
              "<br><a href=\"#{url}\">#{url}</a>"
            end
        end

        def highlighted_source_line(offense)
          source_before_highlight(offense) +
            hightlight_source_tag(offense) +
            source_after_highlight(offense) +
            possible_ellipses(offense.location)
        end

        def hightlight_source_tag(offense)
          "<span class=\"highlight #{offense.severity}\">" \
            "#{escape(offense.highlighted_area.source)}" \
            '</span>'
        end

        def source_before_highlight(offense)
          source_line = offense.location.source_line
          escape(source_line[0...offense.highlighted_area.begin_pos])
        end

        def source_after_highlight(offense)
          source_line = offense.location.source_line
          escape(source_line[offense.highlighted_area.end_pos..])
        end

        def possible_ellipses(location)
          location.first_line == location.last_line ? '' : " #{ELLIPSES}"
        end

        def cop_anchor(cop_name)
          title = cop_name.downcase
          title.tr!('/', '_')
          "offense_#{title}"
        end

        def escape(string)
          CGI.escapeHTML(string)
        end

        def base64_encoded_logo_image
          image = File.read(LOGO_IMAGE_PATH, binmode: true)
          Base64.encode64(image)
        end
      end
    end
  end
end
