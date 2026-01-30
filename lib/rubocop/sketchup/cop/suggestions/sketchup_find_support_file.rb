# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Avoid `Sketchup.find_support_file` to find your extension's files.
      #
      # Users might install your extension to locations other than the default
      # Plugins directory. If you use `Sketchup.find_support_file` to build
      # a path for files in your extension it will fail in these scenarios.
      #
      # Instead prefer to use `__FILE__` or `__dir__` to build paths relative
      # to your source files. This have the added benefit of allowing you to
      # load your extensions directly from external directories under version
      # control.
      class SketchupFindSupportFile < SketchUp::Cop

        MSG = 'Avoid `Sketchup.find_support_file` to find your ' \
              "extension's files."

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

          add_offense(node.loc.expression)
        end

      end
    end
  end
end
