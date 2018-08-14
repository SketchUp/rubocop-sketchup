# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
      # SketchUp will trap `exit` and prevent that, with a message in the
      # console. But `exit!` is not trapped and with terminate SketchUp without
      # shutting down cleanly.
      # Use `return`, `next` or `break` instead.
      class Exit < SketchUp::Cop

        include SketchUp::NoCommentDisable

        MSG = 'Exit attempts to kill the Ruby interpreter. Use return, next or break instead.'.freeze

        # Reference: http://rubocop.readthedocs.io/en/latest/development/
        def_node_matcher :exit?, <<-PATTERN
          (send {(const nil? :Kernel) nil?} {:exit :exit!} ...)
        PATTERN

        def on_send(node)
          add_offense(node, location: :expression, severity: :error) if exit?(node)
        end
      end
    end
  end
end
