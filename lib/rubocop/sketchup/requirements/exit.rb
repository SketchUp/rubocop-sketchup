# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't attempt to kill the Ruby interpreter by calling exit or exit!.
      class Exit < Cop

        include NoCommentDisable

        MSG = 'Exit attempts to kill the Ruby interpreter.'.freeze

        # Reference: http://rubocop.readthedocs.io/en/latest/development/
        def_node_matcher :exit?, <<-PATTERN
          (send nil? {:exit :exit!})
        PATTERN

        def on_send(node)
          add_offense(node, location: :expression) if exit?(node)
        end
      end
    end
  end
end
