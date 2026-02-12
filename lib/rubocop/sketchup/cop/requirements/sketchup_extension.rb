# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Register a single instance of SketchupExtension per extension.
      # This should be done by the root .rb file in the extension package.
      #
      # @example Good - a single SketchupExtension is registered.
      #   module Example
      #     unless file_loaded?(__FILE__)
      #       extension = SketchupExtension.new('Hello World', 'example/main')
      #       Sketchup.register_extension(extension, true)
      #       file_loaded(__FILE__)
      #     end
      #   end
      class SketchupExtension < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::ExtensionProject
        include RangeHelp

        # rubocop:disable Layout/LineLength
        MSG = 'Create and register one SketchupExtension instance per extension.'
        MSG_CREATE_ONE = 'Create only SketchupExtension instance per extension.'
        MSG_CREATE_MISSING = 'SketchupExtension.new not found.'
        MSG_REGISTER_ONE = 'Only register one SketchupExtension instance per extension.'
        MSG_REGISTER_MISSING = 'Registration of SketchupExtension not found. Expected %s'
        # rubocop:enable Layout/LineLength

        # Reference: http://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :sketchup_extension_assignment, <<-PATTERN
          {
            ({lvasgn ivasgn cvasgn gvasgn} $_
              $(send (const {nil? cbase} :SketchupExtension) :new ...))

            (casgn _ $_
              $(send (const {nil? cbase} :SketchupExtension) :new ...))

            (or_asgn
              {
                ({lvasgn ivasgn cvasgn gvasgn} $_)
                (casgn _ $_)
              }
              $(send (const {nil? cbase} :SketchupExtension) :new ...))
          }
        PATTERN

        def_node_search :sketchup_register_extension, <<-PATTERN
          (send
            (const {nil? cbase} :Sketchup) :register_extension
            {({lvar ivar cvar gvar} $_)(const nil? $_)}
            _ ?)
        PATTERN

        def on_new_investigation
          return unless root_file?(processed_source)

          source_node = processed_source.ast

          # Look for assigned SketchupExtension.new instances.
          assignment_nodes = source_node.each_descendant(
              :or_asgn,
              :lvasgn,
              :ivasgn,
              :cvasgn,
              :gvasgn,
              :casgn
            )
          assignments = assignment_nodes.filter_map do |node|
            sketchup_extension_assignment(node)
          end

          # There should not be multiple instances.
          if assignments.size > 1
            add_global_offense(MSG_CREATE_ONE)
            return
          end

          # There should be exactly one.
          assignment = assignments.first
          if assignment.nil?
            add_global_offense(MSG_CREATE_MISSING)
            return
          end

          extension_var, extension_node = assignment

          # Ensure it have two arguments.
          if extension_node.arguments.size < 2
            message = if extension_node.arguments.size == 1
                        'Missing second argument for the path'
                      else
                        'Missing required name arguments'
                      end
            add_offense(extension_node,
                        message: message)
            return
          end

          # Look for Sketchup.register and make sure it register the extension
          # object detected earlier.
          registered_vars = sketchup_register_extension(source_node).to_a

          # Make sure there is only one call to `register_extension`.
          if registered_vars.size > 1
            add_offense(registered_vars[1],
                        message: MSG_REGISTER_ONE)
            return
          end

          registered_var = sketchup_register_extension(source_node).first
          unless registered_var == extension_var
            msg = MSG_REGISTER_MISSING % extension_var.to_s
            add_global_offense(msg)
          end
        end

      end
    end
  end
end
