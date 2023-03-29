# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Avoid kernel `sleep` as it freezes up SketchUp.
      # Prefer `UI.start_timer` or a callback from the resource you are waiting
      # for.
      class Sleep < SketchUp::Cop
        MSG = '`sleep` freezes up SketchUp. Prefer `UI.start_timer` or a ' \
              'callback for the resource you are waiting for.'

        def_node_matcher :sleep?, <<-PATTERN
          (send {(const nil? :Kernel) nil?} :sleep ...)
        PATTERN

        def on_send(node)
          return unless sleep?(node)

          add_offense(node, message: MSG)
        end
      end
    end
  end
end
