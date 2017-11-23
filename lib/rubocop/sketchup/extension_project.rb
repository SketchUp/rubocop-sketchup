# frozen_string_literal: true

module RuboCop
  module Cop
    module Sketchup
      module ExtensionProject

        def project_path
          Pathname.new(Dir.pwd)
        end

        def relative_source_path
          Pathname.new(cop_config['SourcePath'] || 'src')
        end

        def source_path
          project_path.join(relative_source_path)
        end

        def root_file?(filename)
          filename.extname.downcase == '.rb' &&
            filename.parent.to_s == '.'
        end

        def filename_relative_to_project_source(processed_source)
          # Get filename for processed source.
          source_filename = processed_source.buffer.name
          # TODO: Get this working.
          #   Similar to RuboCop::Cop::Naming::Filename (file_name.rb)
          # return if config.file_to_include?(source_path)
          # Get absolute filename from project root.
          filename = Pathname.new(source_filename)
          filename = project_path.join(filename) if filename.relative?
          # Get filename relative to project source.
          filename.relative_path_from(source_path)
        end

      end
    end
  end
end
