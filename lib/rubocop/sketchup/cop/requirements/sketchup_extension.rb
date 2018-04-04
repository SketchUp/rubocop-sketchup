# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Register a single instance of SketchupExtension per extension.
      # This should be done by the root .rb file in the extension package.
      class SketchupExtension < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::ExtensionProject
        include RangeHelp

        MSG = 'Create and register one SketchupExtension instance per extension.'.freeze
        MSG_CREATE_ONE = 'Create only SketchupExtension instance per extension.'.freeze
        MSG_CREATE_MISSING = 'SketchupExtension.new not found.'.freeze
        MSG_REGISTER_ONE = 'Only register one SketchupExtension instance per extension.'.freeze
        MSG_REGISTER_MISSING = 'Registration of SketchupExtension not found. Expected %s'.freeze

        # Reference: http://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_search :sketchup_extension_new, <<-PATTERN
          (send
            (const nil? :SketchupExtension) :new _ _)
        PATTERN

        def_node_search :sketchup_register_extension, <<-PATTERN
          (send
            (const nil? :Sketchup) :register_extension
            {({lvar ivar cvar gvar} $_)(const nil? $_)}
            _)
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
            node.parent && node.parent.assignment?
          }

          # There should not be multiple instances.
          if extension_nodes.size > 1
            add_offense(nil,
                location: range,
                message: MSG_CREATE_ONE,
                severity: :error)
            return
          end

          # There should be exactly one.
          extension_node = extension_nodes.first
          if extension_node.nil?
            add_offense(nil,
                location: range,
                message: MSG_CREATE_MISSING,
                severity: :error)
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
                message: MSG_REGISTER_ONE,
                severity: :error)
            return
          end

          registered_var = sketchup_register_extension(source_node).first
          unless registered_var == extension_var
            msg = MSG_REGISTER_MISSING % extension_var.to_s
            add_offense(nil,
                location: range,
                message: msg,
                severity: :error)
          end
        end

      end
    end
  end
end
