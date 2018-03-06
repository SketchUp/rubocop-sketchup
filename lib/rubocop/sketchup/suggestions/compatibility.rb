# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class Compatibility < Cop

        include SketchUp::Config
        include SketchUp::Features

        MSG = "Incompatible feature with target SketchUp version".freeze

        def on_const(node)
          feature_name = node.const_name
          [:class, :module, :constant].each { |type|
            check_feature(node, type, feature_name)
          }
        end

        private

        def check_feature(node, type, feature_name)
          return unless sketchup_target_version?
          FEATURES.each { |feature_set|
            version = SketchUp::SketchUpVersion.new(feature_set[:version])
            next unless version > sketchup_target_version
            objects = feature_set[:types][type] || []
            next unless objects.include?(feature_name)
            report(node, version)
          }
        end

        def report(node, version)
          # TODO: Customize message?
          add_offense(node)
        end

      end
    end
  end
end
