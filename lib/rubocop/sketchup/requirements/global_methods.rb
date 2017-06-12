# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class GlobalMethods < Cop

        include NoCommentDisable
        include OnMethodDef
        include SketchUp

        MSG = 'Do not introduce global methods.'.freeze

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
              (const nil $_)
              (const (const nil $_) ...)
            }
            ...
          )
        PATTERN

        def on_method_def(node, method_name, _args, _body)
          class_method_parent = class_method(node)
          if class_method_parent
            namespace = Namespace.new(class_method_parent.to_s)
          else
            # If a method is defined inside a block then parent_module_name
            # will return nil.
            return if node.parent_module_name.nil?
            namespace = Namespace.new(node.parent_module_name)
          end
          add_offense(node, :name, nil, :error) if namespace.top_level?
        end

      end
    end
  end
end
