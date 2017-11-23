# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Cop
    module SketchupRequirements
      # Register a single instance of SketchupExtension per extension.
      # This should be done by the root .rb file in the extension package.
      class SketchupExtension < Cop

        include Sketchup::ExtensionProject
        include NoCommentDisable

        MSG = 'Create and register one SketchupExtension instance per extension.'.freeze
        MSG_CREATE_ONE = 'Create only SketchupExtension instance per extension.'.freeze
        MSG_CREATE_MISSING = 'SketchupExtension.new not found.'.freeze
        MSG_REGISTER_ONE = 'Only register one SketchupExtension instance per extension.'.freeze
        MSG_REGISTER_MISSING = 'Registration of SketchupExtension not found. Expected %s'.freeze

        # Reference: http://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_search :sketchup_extension_new, <<-PATTERN
          ({:lvasgn :ivasgn :cvasgn :gvasgn :casgn} ...
            (:send
              (:const nil? :SketchupExtension) :new
              _
              _))
        PATTERN

        def_node_search :sketchup_register_extension, <<-PATTERN
          (:send
            (const nil? :Sketchup) :register_extension
            {({:lvar :ivar :cvar :gvar} $_)(const nil? $_)}
            _)
        PATTERN

        def investigate(processed_source)
          filename = filename_relative_to_project_source(processed_source)
          return unless root_file?(filename)

          source_node = processed_source.ast
          # Using range similar to RuboCop::Cop::Naming::Filename (file_name.rb)
          range = source_range(processed_source.buffer, 1, 0)

          # Look for SketchupExtension.new.
          extension_nodes = sketchup_extension_new(source_node).to_a
          if extension_nodes.size > 1
            add_offense(nil, location: range, message: MSG_CREATE_ONE)
            return
          end
          extension_node = extension_nodes.first
          if extension_node.nil?
            add_offense(nil, location: range, message: MSG_CREATE_MISSING)
            return
          end

          # Find the name of the value SketchupExtension.new was assigned to.
          if extension_node.casgn_type?
            extension_var = extension_node.to_a[1]
          else
            extension_var = extension_node.to_a[0]
          end

          # Look for Sketchup.register and make sure it register the extension
          # object detected earlier.
          registered_vars = sketchup_register_extension(source_node).to_a
          # TODO: The offences here should probably highlight the line where
          #       Sketchup.register_extension is.
          if registered_vars.size > 1
            add_offense(nil, location: range, message: MSG_REGISTER_ONE)
            return
          end
          registered_var = sketchup_register_extension(source_node).first
          unless registered_var == extension_var
            msg = MSG_REGISTER_MISSING % extension_var.to_s
            add_offense(nil, location: range, message: msg)
          end
        end

      end
    end
  end
end
