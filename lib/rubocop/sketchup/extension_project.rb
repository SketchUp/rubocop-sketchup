# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Cop
    module Sketchup
      module ExtensionProject

        # @return [Pathname]
        def config_path
          # TODO: Restore the search for the config file.
          # path = config.path_relative_to_config('.')
          # Pathname.new(path).expand_path
          Pathname.new(Dir.pwd).expand_path
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
          rel_path = config.path_relative_to_config(source_filename)
          path = Pathname.new(rel_path).expand_path
          # puts '---'
          # puts 'path_relative_to_source'
          # puts "> source_filename: #{source_filename}"
          # puts "> path (relative to config): #{rel_path}"
          # puts "> path (absolute): #{path}"
          # puts "> config_path: #{config_path}"
          # puts "> source_path: #{source_path}"
          # puts '==='
          # Pathname.new(path).relative_path_from(source_path)
          path.relative_path_from(source_path)
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
