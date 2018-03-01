# frozen_string_literal: true

require 'rubocop/sketchup/requirements/api_namespace'
require 'rubocop/sketchup/requirements/ruby_core_namespace'
require 'rubocop/sketchup/requirements/ruby_stdlib_namespace'

module RuboCop
  module Cop
    module SketchupRequirements
      class ExtensionNamespace < Cop

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
          parent = Namespace.new(node.parent_module_name)
          # Don't want to process anything that aren't top level namespaces.
          return unless parent.top_level?
          check_namespace(node, parent.join(name))
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
          add_offense(node, location: :name, severity: :error)
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
          format('Use a single root namespace. (Found `%s`; Previously found `%s`)', namespace, @@namespace)
        end

      end
    end
  end
end
