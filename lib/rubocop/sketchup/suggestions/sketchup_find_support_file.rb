# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Avoid Sketchup.find_support_file to find your extension's files.
      class SketchupFindSupportFile < Cop

        MSG = "Avoid Sketchup.find_support_file to find your extension's files.".freeze

        # http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        # https://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :sketchup_find_support_file?, <<-PATTERN
          (send
            (const nil? :Sketchup) :find_support_file
            ...
          )
        PATTERN

        def on_send(node)
          return unless sketchup_find_support_file?(node)
          add_offense(node, location: :expression)
        end

      end
    end
  end
end
