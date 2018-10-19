# frozen_string_literal: true

module Helpers
  module Config
    def sketchup_version_config(version)
      rubocop_config = {
        'AllCops' => {
          'SketchUp' => {
            'TargetSketchUpVersion' => version,
          },
        },
      }
      RuboCop::Config.new(rubocop_config, 'fake_cop_config.yml')
    end
  end
end
