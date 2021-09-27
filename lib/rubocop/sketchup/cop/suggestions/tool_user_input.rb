# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # When a tool takes user input via `onUserText`, make sure to define
      # `enableVCB?` so that the VCB is enabled.
      #
      # @example
      #   # good
      #   class ExampleTool
      #
      #     def enableVCB?
      #       true
      #     end
      #
      #     def onUserText(text, view)
      #       # ...
      #     end
      #
      #   end
      class ToolUserInput < Cop

        include SketchUp::ToolChecker

        MSG_MISSING_ENABLE_VCB = 'When accepting user input, make sure to '\
                                 'define `enableVCB?`.'

        def on_tool_class(class_node, body_methods)
          return unless find_method(body_methods, :onUserText)

          method_node = find_method(body_methods, :enableVCB?)
          return if method_node

          add_offense(class_node, message: MSG_MISSING_ENABLE_VCB)
        end

      end
    end
  end
end
