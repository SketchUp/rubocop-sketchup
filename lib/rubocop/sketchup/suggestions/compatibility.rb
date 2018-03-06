# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class Compatibility < Cop

        include SketchUp::Config
        include SketchUp::Features

        MSG = "Incompatible feature with target SketchUp version".freeze

        def on_def(node)
          return unless observer_method?(node)
          feature_name = "##{node.method_name}"
          check_feature(node, :method, feature_name)
        end

        def on_send(node)
          if module_method?(node)
            feature_name = "#{node.receiver.const_name}.#{node.method_name}"
            check_feature(node, :method, feature_name)
          else
            # Instance methods are harder. It's difficult to infer the type of
            # the receiver. If we only check the method name in isolation we
            # will get too many false positives with method names matching
            # methods in Ruby itself and other older features.
            # We try to match names that are unlikely to cause much noise.
            return unless checkable_instance_method?(node)
            feature_name = "##{node.method_name}"
            check_feature(node, :method, feature_name)
          end
        end

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
            feature_version = SketchUp::SketchUpVersion.new(feature_set[:version])
            next unless feature_version > sketchup_target_version
            objects = feature_set[:types][type] || []
            if type == :method && instance_method?(feature_name)
              # Instance methods are simply matching the method name since it's
              # very difficult to determine the type of the receiver.
              next unless objects.find { |object| object.end_with?(feature_name) }
            else
              next unless objects.include?(feature_name)
            end
            report(node, feature_name, feature_version, type)
          }
        end

        def report(node, feature_name, feature_version, feature_type)
          message = "The #{feature_type} `#{feature_name}` was added in "\
                    "#{feature_version} which is incompatible with target "\
                    "#{sketchup_target_version}."
          add_offense(node, message: message)
        end

        def module_method?(node)
          node.receiver && node.receiver.const_type?
        end

        def instance_method?(feature_name)
          feature_name.start_with?('#')
        end

        def checkable_instance_method?(node)
          INSTANCE_METHODS.include?(node.method_name)
        end

        def observer_method?(node)
          OBSERVER_METHODS.include?(node.method_name)
        end

      end
    end
  end
end
