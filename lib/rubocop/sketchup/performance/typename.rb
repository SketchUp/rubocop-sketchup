# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      class Typename < Cop
        MSG = '.typename is very slow, prefer .is_a? instead.'.freeze

        def on_send(node)
          _, method_name = *node
          return unless method_name == :typename
          # TODO(thomthom): Should we try to detect use of #typename
          # in context of comparing against a string?
          add_offense(node, location: :expression)
        end
      end
    end
  end
end
