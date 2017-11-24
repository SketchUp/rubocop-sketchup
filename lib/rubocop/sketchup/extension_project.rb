# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Cop
    module Sketchup
      module ExtensionProject

        # @return [Pathname]
        def config_path
          path = config.path_relative_to_config('.')
          Pathname.new(path)
        end

        # @return [Pathname]
        def relative_source_path
          Pathname.new(cop_config['SourcePath'] || 'src')
        end

        # @return [Pathname]
        def source_path
          config_path.join(relative_source_path)
        end

        # @param [RuboCop::ProcessedSource] processed_source
        def path_relative_to_source(processed_source)
          source_filename = processed_source.buffer.name
          path = config.path_relative_to_config(source_filename)
          Pathname.new(path).relative_path_from(source_path)
        end

        # @param [RuboCop::ProcessedSource] processed_source
        def root_file?(processed_source)
          filename = path_relative_to_source(processed_source)
          filename.extname.downcase == '.rb' &&
            filename.parent.to_s == '.'
        end

      end
    end
  end
end
