# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Changing the global SketchUp debug mode can cause warnings from other
      # extensions to be silenced.
      # Don't let your extension change the debug mode in a production setting.
      class DebugMode < SketchUp::Cop

        def_node_matcher :sketchup_set_debug?, <<-PATTERN
          (send (const nil? :Sketchup) :debug_mode= _)
        PATTERN

        MSG_SET_NAME = 'Changing `Sketchup.debug_mode=` may hide warnings ' \
                       'other extension developers rely on.'

        def on_send(node)
          return unless sketchup_set_debug?(node)

          add_offense(node, message: MSG_SET_NAME)
        end

      end
    end
  end
end
