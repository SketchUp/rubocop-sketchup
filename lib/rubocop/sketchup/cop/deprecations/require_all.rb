# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Method is deprecated because it adds the given path to `$LOAD_PATH`.
      # Modifying `$LOAD_PATH` is bad practice because it can cause extensions
      # to inadvertently load the wrong file.
      class RequireAll < SketchUp::Base

        MSG = 'Method is deprecated because it adds the given path ' \
              'to $LOAD_PATH.'

        # @!method require_all?(node)
        def_node_matcher :require_all?, <<-PATTERN
          (send nil? :require_all _)
        PATTERN

        def on_send(node)
          return unless require_all?(node)

          add_offense(node.loc.selector)
        end

      end
    end
  end
end
