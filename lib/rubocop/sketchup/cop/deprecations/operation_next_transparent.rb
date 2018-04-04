# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Weak warning. (Question?)
      class OperationNextTransparent < SketchUp::Cop
        MSG = 'Third argument is deprecated.'.freeze

        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          return if args.size < 3
          argument = args[2]
          next_transparent = argument.type == :true
          add_offense(argument, location: :expression) if next_transparent
        end
      end
    end
  end
end
