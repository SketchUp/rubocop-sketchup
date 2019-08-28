# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # After having drawn to the viewport from a tool, make sure to invalidate
      # the view on `deactivate` and `suspend`.
      #
      # If you don't do that the things you drew might stick around for longer
      # than the life-span of the tool and cause confusion for the user.
      #
      # @example
      #   # good
      #   class ExampleTool
      #
      #     def deactivate(view)
      #       view_invalidate
      #     end
      #
      #     def suspend(view)
      #       view_invalidate
      #     end
      #
      #     def draw(view)
      #       view.draw(GL_LINES, @points)
      #     end
      #
      #   end
      class ToolInvalidate < Cop

        include SketchUp::ToolChecker

        MSG_MISSING_INVALIDATE_METHOD = 'When drawing to the viewport, make '\
            'sure to `suspend` and `deactivate` calls `view.invalidate`.'

        MSG_MISSING_INVALIDATE = 'When drawing to the viewport, make sure to '\
            'call `view.invalidate` when the tool becomes inactive.'

        def_node_search :view_invalidate?, <<-PATTERN
          (send (lvar :view) :invalidate ...)
        PATTERN

        def on_tool_class(class_node, body_methods)
          return unless find_method(body_methods, :draw)

          check_method_invalidate(:deactivate, body_methods, class_node)
          check_method_invalidate(:suspend, body_methods, class_node)
        end

        private

        def check_method_invalidate(method_name, body_methods, class_node)
          method_node = find_method(body_methods, method_name)
          if method_node
            return if view_invalidate?(method_node)

            add_offense(method_node, message: MSG_MISSING_INVALIDATE)
          else
            add_offense(class_node, message: MSG_MISSING_INVALIDATE_METHOD)
          end
        end

      end
    end
  end
end
