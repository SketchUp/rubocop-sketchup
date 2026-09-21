# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Avoid using the current year as the copyright year of your extension.
      # It gives the impression the extension is kept up to date even when it
      # is not. Use the year you last worked on the extension instead.
      #
      # The examples below assume 2026 to be the current year.
      #
      # @example Misleading
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = "#{Time.now.year} Jane Doe"
      #
      # @example Preferred
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   extension.copyright = '2026 Jane Doe'
      class DynamicCopyrightYear < SketchUp::Cop

        include SketchUp::ExtensionRegistrar

        MSG = 'Dynamically using the current year as copyright year is ' \
              'misleading. Prefer hardcoded actual year.'

        def_node_search :contains_time_now?, <<-PATTERN
          (send (const nil? :Time) :now ...)
        PATTERN

        private

        def on_extension_attribute(attribute, value_node, node)
          return unless attribute == :copyright
          return unless value_node.dstr_type?
          return unless contains_time_now?(value_node)

          add_offense(node)
        end

      end
    end
  end
end
