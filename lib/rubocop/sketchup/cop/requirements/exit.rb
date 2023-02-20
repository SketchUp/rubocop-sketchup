# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
      # SketchUp will trap `exit` and prevent that, with a message in the
      # console. But `exit!` is not trapped and will terminate SketchUp without
      # shutting down cleanly.
      #
      # Use `return`, `next`, `break` or `raise` instead.
      class Exit < SketchUp::Cop

        include SketchUp::NoCommentDisable

        MSG = '`%s` attempts to kill the Ruby interpreter. Use `return`, ' \
              '`next`, `break` or `raise` instead.'

        # Reference: http://rubocop.readthedocs.io/en/latest/development/
        def_node_matcher :exit?, <<-PATTERN
          (send {(const nil? :Kernel) nil?} {:abort :exit :exit!} ...)
        PATTERN

        def on_send(node)
          return unless exit?(node)

          message = format(MSG, node.method_name)
          add_offense(node, location: :selector, message: message)
        end
      end
    end
  end
end
