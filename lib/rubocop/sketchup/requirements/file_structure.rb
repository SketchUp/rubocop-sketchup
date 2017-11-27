# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Check that the extension conform to expected file structure with a
      # single root .rb file and a support folder with matching name.
      class FileStructure < Cop

        include Sketchup::ExtensionProject
        include NoCommentDisable

        IGNORED_DIRECTORIES = %w[
          __MACOSX
        ].freeze

        def investigate(processed_source)
          # TODO: Only process root files? Then this will fail if there are
          # only Ruby files in sub-directories.
          # return unless root_file?(processed_source)
          return if already_run?

          # Using range similar to RuboCop::Cop::Naming::Filename (file_name.rb)
          range = source_range(processed_source.buffer, 1, 0)

          # Find all root Ruby files in the source directory.
          pattern = "#{source_path}/*.rb"
          root_ruby_files = Dir.glob(pattern)

          # Ensure there is only one root Ruby file.
          if root_ruby_files.size != 1
            msg = "Extensions must have exactly one root Ruby (.rb) file. Found: %d"
            add_offense(nil, location: range, message: format(msg, root_ruby_files))
            return
          end

          # Find the root file and collect the sub-directories.
          root_file = root_ruby_files.first
          extension_basename = File.basename(root_file, '.*')
          sub_folders = source_path.children.select { |c| c.directory? }
          sub_folders.reject! { |folder|
            IGNORED_DIRECTORIES.include?(folder.basename.to_s)
          }

          # Ensure there is only one sub-directory.
          if sub_folders.size != 1
            msg = "Extensions must have exactly one support directory. Found %d"
            add_offense(nil, location: range, message: format(msg, sub_folders))
            return
          end

          # Ensure support directory's name match the root Ruby file.
          support_directory = sub_folders.first
          unless support_directory.basename.to_s == extension_basename
            msg = 'Extensions must have a support directory matching the name of the root Ruby file. Expected %s, found %s'
            msg = format(msg, extension_basename, support_directory.basename)
            add_offense(nil, location: range, message: msg)
          end
        end

        private

        @@already_run = false

        def already_run?
          return true if @@already_run
          @@already_run = true
          false
        end

        def self.reset
          @@already_run = false
        end

      end
    end
  end
end
