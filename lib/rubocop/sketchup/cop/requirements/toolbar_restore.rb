# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # To ensure the toolbar visibility state is correctly persisted between
      # sessions, always use `toolbar.restore` to display your toolbar.
      #
      # @example Creating a new toolbar
      #   # bad
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.show
      #
      #   # bad - .restore would do the same
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.show unless toolbar.get_last_state == TB_HIDDEN
      #
      #   # bad - redundant to check state when using .restore
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.restore unless toolbar.get_last_state == TB_HIDDEN
      #
      #   # good
      #   toolbar = UI::Toolbar.new('Example')
      #   # ...
      #   toolbar.restore
      class ToolbarRestore < SketchUp::Cop

        include RangeHelp
        include SketchUp::NoCommentDisable

        MSG_SHOW = 'Always use `.restore` to display your toolbar.'.freeze

        MSG_REDUNDANT = 'No need to check toolbar state with `.restore`.'.freeze

        def_node_matcher :toolbar_new?, <<-PATTERN
          (send (const (const nil? :UI) :Toolbar) :new _)
        PATTERN

        def_node_search :toolbar_show, <<-PATTERN
          (send $_ :show)
        PATTERN

        def_node_matcher :toolbar_get_last_state, <<-PATTERN
          (send ({lvar ivar cvar gvar} $_) :get_last_state)
        PATTERN

        def_node_search :find_toolbar_restore_with_state_check, <<-PATTERN
          {
            (if
              (send _statevar {:== :!=} (const nil? {:TB_VISIBLE :TB_HIDDEN :TB_NEVER_SHOWN}))
              (send _toolbarvar :restore) nil?)

            (if
              (send _statevar {:== :!=} (const nil? {:TB_VISIBLE :TB_HIDDEN :TB_NEVER_SHOWN})) nil?
              (send _ :restore))
          }
        PATTERN

        def_node_matcher :toolbar_restore_with_state_check, <<-PATTERN
          {
            (if
              (send $_statevar {:== :!=} (const nil? {:TB_VISIBLE :TB_HIDDEN :TB_NEVER_SHOWN}))
              (send $_toolbarvar :restore) nil?)

            (if
              (send $_statevar {:== :!=} (const nil? {:TB_VISIBLE :TB_HIDDEN :TB_NEVER_SHOWN})) nil?
              (send $_ :restore))
          }
        PATTERN

        def_node_search :find_state_variable, <<-PATTERN
          ({lvasgn ivasgn cvasgn gvasgn} _statevar
            (send ({lvar ivar cvar gvar} _toolbarvar) :get_last_state))
        PATTERN

        def_node_matcher :state_variable, <<-PATTERN
          ({lvasgn ivasgn cvasgn gvasgn} $_statevar
            (send ({lvar ivar cvar gvar} $_toolbarvar) :get_last_state))
        PATTERN


        def on_send(node)
          return unless toolbar_new?(node)
          return unless node.parent.assignment?

          assignment_node = node.parent
          toolbar_variable_name = assignment_node.children.first

          check_show_usage(assignment_node, toolbar_variable_name)
          check_restore_with_conditional(assignment_node, toolbar_variable_name)
        end

        private

        def toolbar_state_variable(assignment_node, toolbar_variable_name)
          states = find_state_variable(assignment_node.parent)
          return unless states

          states.each { |state_node|
            match = state_variable(state_node)
            next unless match

            statevar, toolbarvar = match
            next unless toolbarvar == toolbar_variable_name

            return statevar
          }
        end

        def check_restore_with_conditional(assignment_node, toolbar_name)
          return unless assignment_node.parent

          nodes = find_toolbar_restore_with_state_check(assignment_node.parent)
          return unless nodes

          # We assume the state check is using `toolbar.get_last_state` or via
          # an intermediate variable. If there is an intermediate variable we
          # need to obtain the name of the state variable and check against that
          # later on.
          state_var =
              toolbar_state_variable(assignment_node, toolbar_name) ||
              toolbar_name

          node = nodes.find { |n|
            redundant_state_check?(n, toolbar_name, state_var)
          }
          return unless node

          range = conditional_range(node)
          add_offense(node, location: range, message: MSG_REDUNDANT)
        end

        def redundant_state_check?(node, toolbar_var, expected_statevar)
          match = toolbar_restore_with_state_check(node)
          return false unless match

          statevar, toolbarvar = match
          statevar_name = toolbar_get_last_state(statevar) ||
                          statevar.children.first
          toolbarvar_name = toolbarvar.children.first
          statevar_name == expected_statevar && toolbarvar_name == toolbar_var
        end

        def check_show_usage(assignment_node, toolbar_variable_name)
          return unless assignment_node.parent

          receivers = toolbar_show(assignment_node.parent)
          return unless receivers

          receiver = receivers.first
          return unless receiver && receiver.variable?

          receiver_variable_name = receiver.children.first
          return unless receiver_variable_name == toolbar_variable_name

          add_offense(receiver.parent, location: :selector, message: MSG_SHOW)
        end

      end
    end
  end
end
