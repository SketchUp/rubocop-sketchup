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
      class OperationDisableUI < SketchUp::Cop
        MSG = 'Operations should disable the UI for performance gain.'.freeze

        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          if args.size < 2
            add_offense(node, location: :expression)
            return
          end
          argument = args[1]
          disable_ui = argument.truthy_literal?
          return if disable_ui
          add_offense(argument, location: :expression)
        end
      end
    end
  end
end
