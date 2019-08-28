# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # `.typename` is very slow, prefer `.is_a?` instead.
      #
      # `entity.typename == 'Face'` is slow because it performs a string
      # comparison. `is_a?` is much faster because it's a simple type check.
      class Typename < SketchUp::Cop
        MSG = '`.typename` is very slow, prefer `.is_a?` instead.'

        def on_send(node)
          _, method_name = *node
          return unless method_name == :typename

          # TODO(thomthom): Should we try to detect use of #typename
          # in context of comparing against a string?
          add_offense(node, location: :selector)
        end
      end
    end
  end
end
