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
        def_node_search :sketchup_extension_new, <<-PATTERN
          (send
            (const {nil? cbase} :SketchupExtension) :new ...)
        PATTERN

        def_node_search :sketchup_register_extension, <<-PATTERN
          (send
            (const {nil? cbase} :Sketchup) :register_extension
            {({lvar ivar cvar gvar} $_)(const nil? $_)}
            _ ?)
        PATTERN

        def investigate(processed_source)
          return unless root_file?(processed_source)

          source_node = processed_source.ast
          # Using range similar to RuboCop::Cop::Naming::Filename (file_name.rb)
          range = source_range(processed_source.buffer, 1, 0)

          # Look for SketchupExtension.new.
          extension_nodes = sketchup_extension_new(source_node).to_a

          # Threat instances not assigned to anything as non-existing.
          extension_nodes.select! { |node|
            node.parent&.assignment?
          }

          # There should not be multiple instances.
          if extension_nodes.size > 1
            add_offense(nil,
                        location: range,
                        message: MSG_CREATE_ONE)
            return
          end

          # There should be exactly one.
          extension_node = extension_nodes.first
          if extension_node.nil?
            add_offense(nil,
                        location: range,
                        message: MSG_CREATE_MISSING)
            return
          end

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

          # Find the name of the value SketchupExtension.new was assigned to.
          assignment_node = extension_node.parent
          if assignment_node.casgn_type?
            extension_var = assignment_node.to_a[1]
          else
            extension_var = assignment_node.to_a[0]
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
            add_offense(nil,
                        location: range,
                        message: msg)
          end
        end

      end
    end
  end
end
