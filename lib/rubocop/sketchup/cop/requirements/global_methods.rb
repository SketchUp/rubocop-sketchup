# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to not define
      # global methods.
      class GlobalMethods < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp

        MSG = 'Do not introduce global methods.'

        # Reference: http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        #
        # Matchers for methods defined with this syntax:
        #
        # def Example.foo
        # end
        #
        # def (Example::Foo).bar
        # end

        def_node_matcher :class_method?, <<-PATTERN
          (defs
            (const _ _) ...
          )
        PATTERN

        def_node_matcher :class_method, <<-PATTERN
          (defs
            {
              (const nil? $_)
              (const (const nil? $_) ...)
            }
            ...
          )
        PATTERN

        def on_def(node)
          if class_method?(node)
            class_method_parent = class_method(node)
            namespace = Namespace.new(class_method_parent.to_s)
          else
            # If a method is defined inside a block then parent_module_name
            # will return nil.
            return if node.parent_module_name.nil?

            namespace = Namespace.new(node.parent_module_name)
          end
          return unless namespace.top_level?

          add_offense(node.loc.name)
        end
        alias on_defs on_def

      end
    end
  end
end
