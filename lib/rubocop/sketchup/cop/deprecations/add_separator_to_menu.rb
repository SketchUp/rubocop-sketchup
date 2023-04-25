# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Avoid adding separators to top level menus. If you require grouping use
      # a sub-menu instead.
      class AddSeparatorToMenu < SketchUp::Base

        MSG = 'Method is deprecated.'

        # @!method add_separator_to_menu?(node)
        def_node_matcher :add_separator_to_menu?, <<-PATTERN
          (send nil? :add_separator_to_menu _)
        PATTERN

        def on_send(node)
          return unless add_separator_to_menu?(node)

          add_offense(node.loc.selector)
        end

      end
    end
  end
end
