# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Method is deprecated. Use `SKETCHUP_CONSOLE.show` instead.
      class ShowRubyPanel < SketchUp::Cop

        MSG = 'Method is deprecated. Use `SKETCHUP_CONSOLE.show` '\
              'instead.'

        def_node_matcher :show_ruby_panel?, <<-PATTERN
          (send nil? :show_ruby_panel)
        PATTERN

        def on_send(node)
          return unless show_ruby_panel?(node)

          add_offense(node, location: :expression)
        end

      end
    end
  end
end
