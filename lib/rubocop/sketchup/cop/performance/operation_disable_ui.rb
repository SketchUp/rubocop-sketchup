# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # Operations should disable the UI for performance gain.
      #
      # @example
      #   model = Sketchup.active_model
      #   model.start_operation('Operation Name', true)
      #   # <model changes>
      #   model.commit_operation
      class OperationDisableUI < SketchUp::Base
        MSG = 'Operations should disable the UI for performance gain.'

        def on_send(node)
          return unless node.method?(:start_operation)

          args = node.arguments
          if args.size < 2
            add_offense(node.loc.selector)
            return
          end
          argument = args[1]
          disable_ui = argument.truthy_literal?
          return if disable_ui

          add_offense(argument)
        end
      end
    end
  end
end
