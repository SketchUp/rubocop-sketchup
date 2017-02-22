require "rubocop"

module RuboCop
  module Cop
    module Lint
      # Weak warning. (Question?)
      class OperationName < Cop
        MSG = 'Operation name should be a short capitalized description.'.freeze
        
        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          operation_name = args.first.children.first
          return if acceptable_operation_name?(operation_name)
          add_offense(args.first, :expression)
        end

        def acceptable_operation_name?(name)
          return false if name.size > 25 # TODO: Separate Cop?
          return false if name.end_with?('.')
          # Capitalization, no programmer name, no punctuation
          true
        end
      end
    end
  end
end
