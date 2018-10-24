# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Wrapping `toolbar.restore` in `UI.start_timer` is redundant. It was a
      # workaround for an issue in a very old version of SketchUp. There is no
      # need to still be using this workaround.
      #
      # @example Creating a new toolbar
      #   # bad
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.restore
      #   UI.start_timer(0.1, false) {
      #     toolbar.restore
      #   }
      #
      #   # good
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.restore
      class ToolbarTimer < Cop

        include RangeHelp

        MSG = 'Wrapping `toolbar.restore` in `UI.start_timer` is '\
              'redundant.'.freeze

        def_node_matcher :toolbar_new?, <<-PATTERN
          (send (const (const nil? :UI) :Toolbar) :new _)
        PATTERN

        def_node_search :ui_start_timer_restore, <<-PATTERN
          (block
            (send
              (const nil? :UI) :start_timer
              (float _)
              (false))
            (args)
            (send
              $_ :restore))
        PATTERN

        def on_send(node)
          return unless toolbar_new?(node)
          return unless node.parent.assignment?

          assignment_node = node.parent
          toolbar_variable_name = assignment_node.children.first

          receiver = ui_start_timer_restore(assignment_node.parent).first
          return unless receiver && receiver.variable?

          receiver_variable_name = receiver.children.first

          return unless receiver_variable_name == toolbar_variable_name

          add_offense(receiver.parent)
        end

      end
    end
  end
end
