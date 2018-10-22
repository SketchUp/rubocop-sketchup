# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to not pollute
      # the global namespace by including mix-in modules.
      class GlobalInclude < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp

        MSG = 'Do not include into global namespace.'.freeze

        def_node_matcher :is_include?, <<-PATTERN
          (send nil? :include ...)
        PATTERN

        def on_send(node)
          return unless global_include?(node)

          add_offense(node, severity: :error)
        end

        private

        def global_include?(node)
          is_include?(node) && global_namespace?(node)
        end

        def global_namespace?(node)
          %w[Kernel Object].include?(node.parent_module_name)
        end

      end
    end
  end
end
