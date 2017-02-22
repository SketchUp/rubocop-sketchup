require "rubocop"

module RuboCop
  module Cop
    module Lint
      class ExtensionNamespace < Cop
        include OnMethodDef

        # MSG = 'Confine extension to a single module.'.freeze

        def on_class(node)
          check_class_or_module(node)
        end

        def on_module(node)
          check_class_or_module(node)
        end

        def on_method_def(node, method_name, _args, _body)
          # name, = *node
          # puts "method: #{method_name} vs #{name}"
          # check(node)
          parent_name = node.parent_module_name
          check_namespace(node, method_name, parent_name)
        end

        def on_gvar(node)
          check_global_var(node)
        end

        def on_gvasgn(node)
          check_global_var(node)
        end

        def check_global_var(node)
          global_var, = *node
          # add_offense(node, :name) unless allowed_var?(global_var)
          add_offense(node, :name)
        end

        def check_class_or_module(node)
          name = node.defined_module_name
          parent_name = node.parent_module_name
          # check_namespace(node, name, parent_name)
          check_namespace(node, name, "#{parent_name}::#{name}")
        end

        def check_namespace(node, name, parent_name)
          # puts
          # puts "  Type: #{node.type}"
          # puts "  Name: #{name}"
          # puts "Parent: #{parent_name}"
          check_top_level_namespace(node, parent_name)
        end

        def top_level_namespace(namespace)
          namespace.split('::').find { |name| name != 'Object' } || 'Object'
        end

         @@namespace = nil
        def check_top_level_namespace(node, namespace)
          top = top_level_namespace(namespace)
          # puts "Setting TLN to: #{top} (#{namespace})" if @@namespace.nil?
          @@namespace ||= top
          # puts "Namespace: #{@@namespace} vs #{top} (#{namespace})"
          return if @@namespace == top
          add_offense(node, :name)
        end

        def namespace_from_root(namespace)
          parts = namespace.split('::')
          parts.shift if parts.first == 'Object' and parts.size > 1
          parts.join('::')
        end

        # def message(style)
        #   format('Use %s for method names.', style)
        #   # format('Use xx for method names.', style)
        # end
        def message(node)
          namespace = namespace_from_root(node.parent_module_name)
          format('Use a single root namespace. (Expected %s; found %s)', @@namespace, namespace)
          # format('Use xx for method names.', style)
        end
      end
    end
  end
end
