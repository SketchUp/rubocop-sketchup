# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Pass a valid extension GUID to `Sketchup::Licensing.get_extension_license`.
      #
      # An invalid GUID, or one with extra whitespace, will make the license
      # check fail and is reported as an error.
      #
      # It's also recommended to hardcode the extension GUID as a local string
      # literal within the method doing the license check, since constants and
      # other variables can be overwritten in Ruby. This is reported as a
      # warning.
      #
      # @example Bad - Invalid GUID
      #   Sketchup::Licensing.get_extension_license("4e215280-dd23-40c4")
      #
      # @example Not recommended - GUID can be overwritten
      #   Sketchup::Licensing.get_extension_license(EXTENSION_ID)
      #
      # @example Good
      #   ext_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
      #   Sketchup::Licensing.get_extension_license(ext_id)
      class GetExtensionLicense < SketchUp::Cop

        include RangeHelp
        include SketchUp::NoCommentDisable

        MSG_INVALID = 'Invalid extension GUID'

        MSG_WRONG_TYPE = 'Only pass in extension GUID from local string ' \
                         'literals.'

        MSG_TRAILING_SPACE = 'Extra space in extension GUID'

        def_node_matcher :get_extension_license, <<-PATTERN
          (send
            (const
              (const nil? :Sketchup) :Licensing) :get_extension_license
            $_)
        PATTERN

        # rubocop:disable Layout/LineLength
        EXTENSION_ID_PATTERN = /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/.freeze
        # rubocop:enable Layout/LineLength

        def on_send(node)
          argument = get_extension_license(node)
          return unless argument

          if argument.lvar_type?
            variable_name = argument.children.first
            assignment_node = find_assignment(node, variable_name)
            argument = assignment_node.children.last if assignment_node
          end

          if argument.str_type?
            validate_extension_id(argument)
          else
            location = argument.loc.expression
            add_offense(location, message: MSG_WRONG_TYPE, severity: :warning)
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
            add_offense(range, message: MSG_TRAILING_SPACE)
            return false
          end

          # Invalid format.
          unless EXTENSION_ID_PATTERN.match?(extension_id)
            range = string_contents_range(node)
            add_offense(range, message: MSG_INVALID)
            return false
          end

          true
        end

      end
    end
  end
end
