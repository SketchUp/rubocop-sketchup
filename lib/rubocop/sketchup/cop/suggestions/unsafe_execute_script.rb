# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Avoid interpolating values straight into JavaScript. Values containing
      # quotes, backslashes or newlines produce invalid JavaScript, and values
      # from the model or the user can be crafted to execute arbitrary
      # JavaScript.
      #
      # Instead use `to_json` to convert the Ruby value to its JavaScript
      # representation. It escapes the value for you, and works for arrays and
      # hashes as well.
      #
      # Also avoid any custom escaping, for instance `gsub`, as it's easy to
      # miss edge cases.
      #
      # @example Bad - Risk of syntax error or code injection
      #   dialog.execute_script("showMessage('#{message}')")
      #
      # @example Bad - Doesn't cover backslashes or newlines
      #   dialog.execute_script("showMessage('#{message.gsub("'", "\\'"}')")
      #
      # @example Good - Safe
      #   require 'json'
      #   dialog.execute_script("showMessage(#{message.to_json})")
      #
      # @example False positive - Already escaped
      #   require 'json'
      #   message = message.to_json # Escaping elsewhere in the code
      #   # ...
      #   dialog.execute_script("showMessage(#{message})")
      class UnsafeExecuteScript < SketchUp::Cop

        MSG = 'Convert the value with `to_json` where it is interpolated.'

        def_node_matcher :execute_script?, <<-PATTERN
          (send _ :execute_script ...)
        PATTERN

        # Example:
        #   message.to_json
        #   JSON.generate(message)
        def_node_matcher :json_conversion?, <<-PATTERN
          {
            (send _ :to_json ...)
            (send (const {nil? cbase} :JSON) {:generate :dump} ...)
          }
        PATTERN

        def on_send(node)
          return unless execute_script?(node)

          node.arguments.each { |argument|
            next unless argument.dstr_type?

            check_interpolations(argument)
          }
        end

        private

        def check_interpolations(dstr_node)
          dstr_node.each_child_node(:begin) { |interpolation|
            # Only the last expression of the interpolation ends up in the
            # resulting string.
            value_node = interpolation.children.last
            next if value_node.nil?
            next if json_conversion?(value_node)

            add_offense(value_node)
          }
        end

      end
    end
  end
end
