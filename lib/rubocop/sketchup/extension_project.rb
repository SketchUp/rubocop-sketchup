# frozen_string_literal: true

require 'pathname'

module RuboCop
  module SketchUp
    module ExtensionProject

      include SketchUp::Config

      # @return [Pathname]
      def config_path
        path = config.instance_variable_get(:@loaded_path)
        if path
          Pathname.new(path).expand_path.dirname
        else
          Pathname.new(Dir.pwd).expand_path
        end
      end

      # @return [Pathname]
      def relative_source_path
        Pathname.new(sketchup_source_path_config)
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
        path.relative_path_from(source_path)
      end

      # @param [RuboCop::ProcessedSource] processed_source
      def root_file?(processed_source)
        filename = path_relative_to_source(processed_source)
        filename.extname.casecmp('.rb').zero? &&
          filename.parent.to_s == '.'
      end

    end
  end
end
