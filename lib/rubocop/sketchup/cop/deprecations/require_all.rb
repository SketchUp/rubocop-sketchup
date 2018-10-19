# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Method is deprecated because it adds the given path to `$LOAD_PATH`.
      # Modifying `$LOAD_PATH` is bad practice because it can cause extensions
      # to inadvertently load the wrong file.
      class RequireAll < SketchUp::Cop

        MSG = 'Method is deprecated because it adds the given path '\
              'to $LOAD_PATH.'.freeze

        def_node_matcher :require_all?, <<-PATTERN
          (send nil? :require_all _)
        PATTERN

        def on_send(node)
          return unless require_all?(node)
          add_offense(node, location: :expression)
        end

      end
    end
  end
end
