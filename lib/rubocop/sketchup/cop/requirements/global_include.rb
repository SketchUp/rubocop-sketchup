# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
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
          ['Kernel', 'Object'].include?(node.parent_module_name)
        end

      end
    end
  end
end
