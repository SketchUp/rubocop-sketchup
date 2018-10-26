# frozen_string_literal: true

module RuboCop
  module SketchUp
    module Config

      DEFAULT_CONFIGURATION =
          SketchUp::CONFIG.fetch('AllCops').fetch('SketchUp')

      private

      def all_cops_config
        config.for_all_cops
      end

      def sketchup_cops_config
        config.for_all_cops.fetch('SketchUp', DEFAULT_CONFIGURATION)
      end


      def sketchup_config_key?(key)
        return unless all_cops_config.key?('SketchUp')

        all_cops_config.fetch('SketchUp').key?(key)
      end


      def sketchup_target_version?
        sketchup_config_key?('TargetSketchUpVersion')
      end

      def sketchup_target_version
        version = sketchup_cops_config.fetch('TargetSketchUpVersion')
        version ? SketchUpVersion.new(version) : nil
      end


      def extension_source_path_config?
        sketchup_config_key?('SourcePath')
      end

      def extension_source_path_config
        sketchup_cops_config.fetch('SourcePath')
      end


      def encrypted_extension?
        sketchup_config_key?('EncryptedExtension') &&
          sketchup_cops_config.fetch('EncryptedExtension')
      end


      def extension_binaries?
        sketchup_config_key?('ExtensionBinaries')
      end

      def extension_binaries
        sketchup_cops_config.fetch('ExtensionBinaries')
      end

    end
  end
end
