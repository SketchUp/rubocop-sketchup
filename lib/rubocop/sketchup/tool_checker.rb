# frozen_string_literal: true

module RuboCop
  module SketchUp
    module ToolChecker

      def on_class(node)
        name, _base_class, body = *node
        return unless name.const_name.end_with?('Tool')

        check_body(body, node)
      end

      private

      # rubocop:disable Lint/UnusedMethodArgument
      def on_tool_class(class_node, body, body_methods)
        raise NotImplementedError, 'Implement this method'
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def body_methods(body)
        return [body] if body.def_type?
        return unless body.begin_type?

        body.each_child_node(:def)
      end

      def check_body(body, class_node)
        return if body.nil? # Empty class etc.

        body_methods = body_methods(body)

        on_tool_class(class_node, body_methods)
      end

      def find_method(defs, method_name)
        defs.find { |def_node| def_node.method?(method_name) }
      end

    end
  end
end
