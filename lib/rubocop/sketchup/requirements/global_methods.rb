# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class GlobalMethods < Cop

        include NoCommentDisable
        include OnMethodDef
        include SketchUp

        MSG = 'Do not introduce global methods.'.freeze

        def on_method_def(node, method_name, _args, _body)
          namespace = Namespace.new(node.parent_module_name)
          add_offense(node, :name, nil, :error) if namespace.top_level?
        end

      end
    end
  end
end
