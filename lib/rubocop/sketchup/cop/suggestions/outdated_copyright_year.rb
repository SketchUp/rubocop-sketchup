# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Keep the copyright year of your extension up to date with the year you
      # last worked on it. For a year span, only the last year needs to be up
      # to date.
      #
      # The examples below assume 2026 to be the current year.
      #
      # @example Outdated
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = '1993 Jane Doe'
      #
      # @example Outdated year span
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = '1993-2016 Jane Doe'
      #
      # @example Up to date
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = '2026 Jane Doe'
      #
      # @example Up to date year span
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = '1993-2026 Jane Doe'
      class OutdatedCopyrightYear < SketchUp::Cop

        include SketchUp::ExtensionRegistrar

        MSG = 'The copyright year is outdated.'

        private

        def on_extension_attribute(attribute, value_node, node)
          return unless attribute == :copyright
          return unless value_node.str_type?

          # For year spans, such as "1993-2016", the last year is the one that
          # should be up to date.
          last_year = value_node.value.scan(/\d{4}/).last
          return if last_year.nil?
          return unless last_year.to_i < Time.now.year

          add_offense(node)
        end

      end
    end
  end
end
