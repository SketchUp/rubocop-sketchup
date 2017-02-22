require "rubocop"

module RuboCop
  module Cop
    module Performance
      # Weak warning. (Question?)
      class OperationDisableUI < Cop
        MSG = 'Operations should disable the UI for performance gain.'.freeze
        
        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          if args.size < 2
            add_offense(node, :expression)
            return
          end
          argument = args[1]
          disable_ui = argument.children.first
          return if disable_ui
          add_offense(argument, :expression)
        end
      end
    end
  end
end
