# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't load extension files in the root file registering the extension.
      # Extensions should not load additional files when it's disabled.
      class MinimalRegistration < Cop

        include SketchUp::NoCommentDisable
        include SketchUp::ExtensionProject

        MSG = "Don't load extension files in the root file registering the extension.".freeze

        # Reference: http://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :require_filename, <<-PATTERN
          (:send
            {(const nil? :Sketchup) nil?} :require
            (str $_))
        PATTERN

        def investigate(processed_source)
          if root_file?(processed_source)
            filename = processed_source.buffer.name
            @extension_basename = File.basename(filename, '.*')
          end
        end

        def extension_file?(filename)
          return false unless filename.include?('/')
          first_directory = filename.split('/').first
          @extension_basename.casecmp(first_directory) == 0
        end

        def on_send(node)
          return unless @extension_basename
          filename = require_filename(node)
          return if filename.nil?
          return unless extension_file?(filename)
          add_offense(node, severity: :error)
        end

      end
    end
  end
end
