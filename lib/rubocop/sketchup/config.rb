# frozen_string_literal: true

module RuboCop
  module SketchUp
    module Config

      DEFAULT_CONFIGURATION =
        RuboCop::SketchUp::CONFIG.fetch('AllCops').fetch('SketchUp')

      private

      def all_cops_config
        config.for_all_cops
      end

      def sketchup_cops_config
        config.for_all_cops.fetch('SketchUp', DEFAULT_CONFIGURATION)
      end


      def sketchup_source_path_config?
        return unless all_cops_config.key?('SketchUp')
        all_cops_config.fetch('SketchUp').key?('SourcePath')
      end

      def sketchup_source_path_config
        sketchup_cops_config.fetch('SourcePath')
      end


      def sketchup_target_version?
        return unless all_cops_config.key?('SketchUp')
        all_cops_config.fetch('SketchUp').key?('TargetSketchUpVersion')
      end

      def sketchup_target_version
        version = sketchup_cops_config.fetch('TargetSketchUpVersion')
        version ? SketchUpVersion.new(version) : nil
      end

    end
  end
end
