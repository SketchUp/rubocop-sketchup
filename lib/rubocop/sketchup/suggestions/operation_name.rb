# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class OperationName < Cop

        MSG = 'Operation name should be a short capitalized description.'.freeze

        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          operation_name = args.first.children.first
          return if acceptable_operation_name?(operation_name)
          add_offense(args.first, location: :expression)
        end

        def acceptable_operation_name?(name)
          # Capitalization, no programmer name, no punctuation.
          # We can only inspect string literals.
          return true unless name.is_a?(String)
          return false if name.size > max_operation_name_length
          return false if name.end_with?('.')
          return false if titleize(name) != name
          true
        end

        def max_operation_name_length
          length = cop_config['Max'] || 25
          return length if length.is_a?(Integer) && length > 0

          raise 'Max needs to be a positive integer!'
        end

        TITLEIZE_EXCLUDE = %w[
          by for from in of to
          and or if
        ]

        # TODO(thomthom): Might need to ignore words like 'and/or'
        def titleize(string)
          # string.split.map(&:capitalize).join(' ')
          words = string.split.map { |word|
            if TITLEIZE_EXCLUDE.include?(word)
              word
            else
              word.capitalize
            end
          }
          words.join(' ')
        end

      end
    end
  end
end
