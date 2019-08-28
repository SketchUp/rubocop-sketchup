# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
      # SketchUp will trap `exit` and prevent that, with a message in the
      # console. But `exit!` is not trapped and with terminate SketchUp without
      # shutting down cleanly.
      #
      # Use `return`, `next`, `break` or `raise` instead.
      class GetExtensionLicense < SketchUp::Cop

        include RangeHelp
        include SketchUp::NoCommentDisable

        MSG_INVALID = 'Invalid extension GUID'

        MSG_WRONG_TYPE = 'Only pass in extension GUID from local string '\
                         'literals.'

        MSG_TRAILING_SPACE = 'Extra space in extension GUID'

        def_node_matcher :get_extension_license, <<-PATTERN
          (send
            (const
              (const nil? :Sketchup) :Licensing) :get_extension_license
            $_)
        PATTERN

        # rubocop:disable Metrics/LineLength
        EXTENSION_ID_PATTERN = /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/.freeze
        # rubocop:enable Metrics/LineLength

        def on_send(node)
          argument = get_extension_license(node)
          return unless argument

          if argument.lvar_type?
            variable_name = argument.children.first
            assignment_node = find_assignment(node, variable_name)
            argument = assignment_node.children.last
          end

          if argument.str_type?
            validate_extension_id(argument)
          else
            location = argument.loc.expression
            add_offense(node, location: location, message: MSG_WRONG_TYPE)
          end
        end

        private

        def find_assignment(node, variable_name)
          scope = node
          until scope.parent.nil?
            scope = scope.parent
            scope.each_child_node { |child|
              # next unless child.is_a?(RuboCop::AST::Node)
              next unless child.lvasgn_type?
              next unless child.children.first == variable_name

              return child
            }
          end
          nil
        end

        def validate_extension_id(node)
          extension_id = node.str_content

          # Trailing spaces
          if extension_id.rstrip.size < extension_id.size
            end_pos = node.loc.end.begin_pos
            begin_pos = node.loc.begin.end_pos + extension_id.rstrip.size
            range = range_between(begin_pos, end_pos)
            add_offense(node, location: range, message: MSG_TRAILING_SPACE)
            return false
          end

          # Invalid format.
          if extension_id !~ EXTENSION_ID_PATTERN
            range = string_contents_range(node)
            add_offense(node, location: range, message: MSG_INVALID)
            return false
          end

          true
        end

      end
    end
  end
end
