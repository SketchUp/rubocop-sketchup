# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Operation name should be a short capitalized description. It will be
      # visible to the user in the Edit > Undo menu. Make sure to give it a
      # short human readable name, similar to SketchUp's own operation names.
      #
      # This cop make some very naive assumptions and will have more false
      # positives than most of the other cops. It's purpose is mainly to enable
      # awareness.
      class OperationName < SketchUp::Cop

        include RangeHelp

        MSG = 'Operation name should be a short capitalized description.'.freeze
        MSG_MAX = "Operation names should not be short and concise. [%d/%d]".freeze

        def on_send(node)
          _, method_name, *args = *node
          return unless method_name == :start_operation
          return if args.empty? || !args.first.str_type?
          operation_name = args.first.str_content
          # We can only inspect string literals.
          return unless operation_name.is_a?(String)
          # Check the format of the operation name.
          unless acceptable_operation_name?(operation_name)
            msg = %[#{MSG} Expected: `"#{titleize(operation_name)}"`]
            add_offense(args.first, location: :expression, message: msg)
          end
          # Check the length of the operation name.
          unless operation_name.size <= max_operation_name_length
            message = format(MSG_MAX, operation_name.size, max_operation_name_length)
            add_offense(args.first,
              location: excess_range(args.first, operation_name),
              message: message)
          end
          # Ensure operation name is not empty.
          if operation_name.empty?
            msg = 'Operation names should not be empty.'
            add_offense(args.first, location: :expression, message: msg)
          end
        end

        private

        def excess_range(node, operation_name)
          string_start = node.source.index(operation_name)
          range = node.loc.expression
          if string_start
            excess_start = range.begin_pos + string_start + max_operation_name_length
            excess_end = range.begin_pos + string_start + operation_name.size
            range_between(excess_start, excess_end)
          else
            range_between(range.begin_pos, range.end_pos)
          end
        end

        def acceptable_operation_name?(name)
          # Capitalization, no programmer name, no punctuation.
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

        def titleize(string)
          string = string.gsub(/[_.]/, ' ')
          words = string.split.map { |word|
            if TITLEIZE_EXCLUDE.include?(word)
              word
            else
              # word.capitalize won't work here, as we want to allow words like:
              # "HTML", "SketchUp". So instead only the first character in each
              # word is modified.
              char = word[0].upcase
              word[0, 1] = char
              word
            end
          }
          words.join(' ')
        end

      end
    end
  end
end
