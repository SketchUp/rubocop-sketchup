# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # If set to true, then whatever operation comes after this one will be
      # appended into one combined operation, allowing the user the undo both
      # actions with a single undo command.
      #
      # This flag is a highly difficult one, since there are so many ways that a
      # SketchUp user can interrupt a given operation with one of their own.
      #
      # Only use this flag if you have no other option, for instance to work
      # around bug in how `Sketchup::Model#place_component` starts operations.
      class OperationNextTransparent < SketchUp::Base
        MSG = 'Third argument is deprecated.'

        def on_send(node)
          return unless node.method?(:start_operation)

          args = node.arguments
          return if args.size < 3

          argument = args[2]
          next_transparent = argument.true_type?
          add_offense(argument) if next_transparent
        end
      end
    end
  end
end
