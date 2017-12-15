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
      ELLIPSES = '<span class="extra-code">...</span>'.freeze
      TEMPLATE_PATH =
        File.expand_path('../../../../../assets/output.html.erb', __FILE__)

      Color = Struct.new(:red, :green, :blue, :alpha) do
        def to_s
          "rgba(#{values.join(', ')})"
        end

        def fade_out(amount)
          dup.tap do |color|
            color.alpha -= amount
          end
        end
      end

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
          report = OpenStruct.new(path: file, offense: offense)
          categories[offense.cop_name] ||= []
          categories[offense.cop_name] << report
        }
        summary.offense_count += offenses.count
      end

      def finished(inspected_files)
        summary.inspected_files = inspected_files

        render_html
      end

      def render_html
        context = ERBContext.new(categories, files, summary)

        template = File.read(TEMPLATE_PATH, encoding: Encoding::UTF_8)
        erb = ERB.new(template, nil, '-')
        html = erb.result(context.binding)

        output.write html
      end

      # This class provides helper methods used in the ERB template.
      class ERBContext
        include PathUtil
        include TextUtil

        SEVERITY_COLORS = {
          refactor:   Color.new(0xED, 0x9C, 0x28, 1.0),
          convention: Color.new(0xED, 0x9C, 0x28, 1.0),
          warning:    Color.new(0x96, 0x28, 0xEF, 1.0),
          error:      Color.new(0xD2, 0x32, 0x2D, 1.0),
          fatal:      Color.new(0xD2, 0x32, 0x2D, 1.0)
        }.freeze

        LOGO_IMAGE_PATH =
          File.expand_path('../../../../../assets/logo.png', __FILE__)

        SORT_ORDER = %w[
          SketchupRequirements
          SketchupDeprecations
          SketchupPerformance
          SketchupSuggestions
        ]

        attr_reader :categories, :files, :summary

        def initialize(categories, files, summary)
          @categories = sort_categories(categories)
          @files = files.sort
          @summary = summary
        end

        def sort_categories(categories)
          categories.sort { |a, b|
            # First sort departments by custom ordering (of importance).
            # Then sort by cop name.
            a_department, a_name = a[0].split('/')
            b_department, b_name = b[0].split('/')
            n = SORT_ORDER.index(a_department) <=> SORT_ORDER.index(b_department)
            n == 0 ? a_name <=> b_name : n
          }.to_h
        end

        # Make Kernel#binding public.
        def binding
          super
        end

        def decorated_message(offense)
          offense.message.gsub(/`(.+?)`/) do
            "<code>#{Regexp.last_match(1)}</code>"
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
          escape(source_line[offense.highlighted_area.end_pos..-1])
        end

        def possible_ellipses(location)
          location.first_line == location.last_line ? '' : " #{ELLIPSES}"
        end

        def cop_anchor(cop_name)
          title = cop_name.downcase
          title.tr!('/', '_')
          "offense_#{title}"
        end

        def escape(s)
          CGI.escapeHTML(s)
        end

        def base64_encoded_logo_image
          image = File.read(LOGO_IMAGE_PATH, binmode: true)
          Base64.encode64(image)
        end
      end
    end
  end
end
