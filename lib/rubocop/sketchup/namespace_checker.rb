# frozen_string_literal: true

module RuboCop
  module SketchUp
    module NamespaceChecker

      extend NodePattern::Macros

      # Example:
      #   Array.include(Example)
      def_node_matcher :klass_include, <<-PATTERN
        (send
          (const nil? $_) { :include | :extend } _)
      PATTERN

      # Example:
      #   class Array
      #     include Example
      #   end
      def_node_matcher :klass_scope_include, <<-PATTERN
        (
          {
            class (const nil? $_) nil? |
            module (const nil? $_)
          }
          (send nil? { :include | :extend } _))
      PATTERN

      # Example:
      #   include Example
      def_node_matcher :include_call?, <<-PATTERN
        (send nil? { :include | :extend } _)
      PATTERN


      def on_class(node)
        check_namespace(node)
      end

      def on_module(node)
        check_namespace(node)
      end

      def on_def(node)
        check_namespace(node)
      end
      alias on_defs on_def

      # Constant assignment.
      def on_casgn(node)
        check_namespace(node)
      end

      def on_send(node)
        klass = klass_include(node) || klass_scope_include(node.parent)

        if klass
          namespace = SketchUp::Namespace.new(klass.to_s)
          return unless namespaces.include?(namespace.first)
        else
          # If klass is `nil` we either don't have a `include` call or we're in
          # global namespace.
          return unless top_level_include?(node)
        end

        add_offense(node.loc.selector, severity: :error)
      end

      def check_namespace(node)
        return unless in_namespace?(node)

        add_offense(node.loc.name, severity: :error)
      end

      def top_level?(node)
        # parent_module_name might return nil if for instance a method is
        # defined within a block. (Apparently that is possible...)
        return false if node.parent_module_name.nil?

        namespace = SketchUp::Namespace.new(node.parent_module_name)
        namespace.top_level?
      end

      def top_level_include?(node)
        include_call?(node) && top_level?(node)
      end

      def in_namespace?(node)
        # parent_module_name might return nil if for instance a method is
        # defined within a block. (Apparently that is possible...)
        return false if node.parent_module_name.nil?

        namespace = SketchUp::Namespace.new(node.parent_module_name)
        namespaces.include?(namespace.first)
      end

      def namespaces
        raise NotImplementedError
      end

    end
  end
end
