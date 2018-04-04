# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      class SketchupSet < SketchUp::Cop

        MSG = 'Class is deprecated.'.freeze

        def_node_matcher :sketchup_set?, <<-PATTERN
          (const (const nil? :Sketchup) :Set)
        PATTERN

        def on_const(node)
          return unless sketchup_set?(node)
          add_offense(node, location: :expression)
        end

      end
    end
  end
end
