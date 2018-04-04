# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class GlobalConstants < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp

        MSG = 'Do not introduce global constants.'.freeze

        def_node_matcher :namespaced_constant?, <<-PATTERN
          (casgn
            (const _ _) ...
          )
        PATTERN

        # Constant assignment.
        def on_casgn(node)
          return if namespaced_constant?(node)
          namespace = Namespace.new(node.parent_module_name)
          add_offense(node, location: :name, severity: :error) if namespace.top_level?
        end

      end
    end
  end
end