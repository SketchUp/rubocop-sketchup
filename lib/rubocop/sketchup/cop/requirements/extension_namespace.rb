# frozen_string_literal: true

require 'rubocop/sketchup/cop/requirements/api_namespace'
require 'rubocop/sketchup/cop/requirements/ruby_core_namespace'
require 'rubocop/sketchup/cop/requirements/ruby_stdlib_namespace'

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to use only one
      # root module.
      #
      # @example Good - this contains everything in the extension.
      #   module MyExtension
      #     class Foo
      #     end
      #     class Bar
      #     end
      #   end
      #
      # @example Better - this further reduce chance of clashing.
      #   module MyCompany
      #     module MyExtension
      #       class Foo
      #       end
      #       class Bar
      #       end
      #     end
      #   end
      class ExtensionNamespace < SketchUp::Base

        include SketchUp::NoCommentDisable
        include SketchUp

        def on_class(node)
          check_class_or_module(node)
        end

        def on_module(node)
          check_class_or_module(node)
        end

        def check_class_or_module(node)
          name = node.defined_module_name

          if node.parent_module_name
            parent = Namespace.new(node.parent_module_name)
          else
            # This is somewhat of an educated guess. We might end up here with
            # code like this:
            #
            #   Example.generate do
            #     module HelloWorld
            #     end
            #   end
            #
            # It might be that the module is evaluated in a different context.
            # But we'll accept the possible false positive and let the user
            # config exceptions if needed.
            parent = Namespace.new('Object')
          end
          namespace = parent.join(name)

          # Don't want to process anything that aren't top level namespaces.
          return unless parent.top_level?
          # Don't check excluded namespaces.
          return if exempted?(namespace)

          check_namespace(node, namespace)
        end

        # Class variables are normally frowned upon since they leak through all
        # instances. However, in this case this is exactly what we want.
        # The Cop picks up the first top level namespace it encounters and then
        # keep track of whether it detects more top level namespaces.
        @@namespace = nil
        def check_namespace(node, namespace)
          # Make sure the namespace isn't part of reserved namespaces that other
          # cops are checking.
          return if reserved?(namespace)

          # Remember the first namespace encountered and log an offence if
          # more top level namespaces are registered.
          top = namespace.first
          @@namespace ||= top
          return if @@namespace == top

          add_offense(node.loc.name, message: message(node))
        end

        def reserved?(namespace)
          top = namespace.first
          return true if RubyCoreNamespace::NAMESPACES.include?(top)
          return true if RubyStdLibNamespace::NAMESPACES.include?(top)
          return true if ApiNamespace::NAMESPACES.include?(top)

          false
        end

        def message(node)
          namespace = Namespace.new(node.defined_module_name).from_root
          format('Use a single root namespace. ' \
                 '(Found `%<found>s`; Previously found `%<expected>s`)',
                 found: namespace, expected: @@namespace)
        end

        def exempted?(namespace)
          namespace_exceptions.include?(namespace.first)
        end

        def namespace_exceptions
          exceptions = cop_config['Exceptions'] || []
          return exceptions if exceptions.is_a?(Array)

          raise 'exceptions needs to be an array of strings!'
        end

      end
    end
  end
end
