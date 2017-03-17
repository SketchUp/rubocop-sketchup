# frozen_string_literal: true

module RuboCop
  module Cop
    module Sketchup
      module NamespaceChecker

        include OnMethodDef

        def on_class(node)
          check_namespace(node)
        end

        def on_module(node)
          check_namespace(node)
        end

        def on_method_def(node, method_name, _args, _body)
          check_namespace(node)
        end

        # Constant assignment.
        def on_casgn(node)
          check_namespace(node)
        end

        def check_namespace(node)
          add_offense(node, :name, nil, :error) if in_namespace?(node)
        end

        def in_namespace?(node)
          namespace = SketchUp::Namespace.new(node.parent_module_name)
          namespaces.include?(namespace.first)
        end

        def namespaces
          raise NotImplementedError
        end

      end
    end
  end
end
