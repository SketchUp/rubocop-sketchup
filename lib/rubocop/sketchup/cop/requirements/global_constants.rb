# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to not define
      # global constants.
      class GlobalConstants < SketchUp::Base

        include SketchUp::NoCommentDisable
        include SketchUp

        MSG = 'Do not introduce global constants.'

        # @!method namespaced_constant?(node)
        def_node_matcher :namespaced_constant?, <<-PATTERN
          (casgn
            (const _ _) ...
          )
        PATTERN

        # Constant assignment.
        def on_casgn(node)
          return if namespaced_constant?(node)

          namespace = Namespace.new(node.parent_module_name)
          return unless namespace.top_level?

          add_offense(node.loc.name)
        end

      end
    end
  end
end
