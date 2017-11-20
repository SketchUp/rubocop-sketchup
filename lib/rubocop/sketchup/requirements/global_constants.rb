# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class GlobalConstants < Cop

        include NoCommentDisable
        include SketchUp

        MSG = 'Do not introduce global constants.'.freeze

        # Constant assignment.
        def on_casgn(node)
          namespace = Namespace.new(node.parent_module_name)
          add_offense(node, location: :name, severity: :error) if namespace.top_level?
        end

      end
    end
  end
end
