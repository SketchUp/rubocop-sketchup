# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class ExtensionNamespace < Cop
        include OnMethodDef
        include SketchupExtensionNamespace
        include NoCommentDisable

        def on_class(node)
          check_class_or_module(node)
        end

        def on_module(node)
          check_class_or_module(node)
        end

        def on_method_def(node, method_name, _args, _body)
          parent_name = node.parent_module_name
          check_namespace(node, method_name, parent_name)
        end

        # TODO(thomthom): Consider adding other sets of cops that checks
        # specifically for overrides of the Ruby core API and the SketchUp API.
        # This would allow us to add exceptions on a more granular level.
        def check_class_or_module(node)
          name = node.defined_module_name
          parent_name = node.parent_module_name
          check_namespace(node, name, "#{parent_name}::#{name}")
        end

        def check_namespace(node, name, parent_name)
          # puts
          # puts "  Type: #{node.type}"
          # puts "  Name: #{name}"
          # puts "Parent: #{parent_name}"
          check_top_level_namespace(node, parent_name)
        end

        def message(node)
          namespace = namespace_from_root(node.parent_module_name)
          format('Use a single root namespace. (Expected %s; found %s)', @@namespace, namespace)
        end
      end
    end
  end
end
