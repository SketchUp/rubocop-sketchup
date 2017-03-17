# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class ApiNamespace < Cop

        include NoCommentDisable
        include OnMethodDef
        include SketchUp
        include SketchupExtensionNamespace

        MSG = 'Do not modify the SketchUp API.'.freeze

        API_NAMESPACES = %w(
          Geom Layout Sketchup SketchupExtension UI
        ).freeze

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

        # TODO(thomthom): Move this to Namespace class? Or to namespace helper?
        def in_api_namespace?(node)
          namespace = Namespace.new(node.parent_module_name)
          API_NAMESPACES.include?(namespace.first)
        end

        def check_namespace(node)
          add_offense(node, :name, nil, :error) if in_api_namespace?(node)
        end

      end
    end
  end
end
