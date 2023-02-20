# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # It's easy to lose track of what API feature was added in what version or
      # SketchUp. You can configure your target SketchUp version and be notified
      # if you use features introduced in newer versions.
      #
      # @example Add this to your .rubocop.yml
      #   AllCops:
      #     SketchUp:
      #       TargetSketchUpVersion: 2016 M1
      class Compatibility < SketchUp::Cop

        include SketchUp::Features
        include SketchUp

        MSG = 'Incompatible feature with target SketchUp version'

        def_node_matcher :module_definition?, <<~PATTERN
          {class module (casgn _ _ class_constructor?)}
        PATTERN

        def on_def(node)
          return unless observer_method?(node)

          feature_name = "##{node.method_name}"
          check_feature(node, :method, feature_name)
        end

        def on_send(node)
          feature_name = ''
          if module_method?(node)
            feature_name = "#{node.receiver.const_name}.#{node.method_name}"
          else
            # Instance methods are harder. It's difficult to infer the type of
            # the receiver. If we only check the method name in isolation we
            # will get too many false positives with method names matching
            # methods in Ruby itself and other older features.
            # We try to match names that are unlikely to cause much noise.
            return unless checkable_instance_method?(node)

            feature_name = "##{node.method_name}"
          end
          check_feature(node, :method, feature_name)
        end

        def on_const(node)
          if node.parent && module_definition?(node.parent)
            # This catches definition of classes and modules.
            namespace = Namespace.new(node.parent_module_name)
            return unless namespace.top_level?
          end

          feature_name = node.const_name
          [:class, :module, :constant].each { |type|
            check_feature(node, type, feature_name)
          }
        end

        private

        def check_feature(node, type, feature_name)
          return unless sketchup_target_version?

          full_feature_name = feature_name
          FEATURES.each { |feature_set|
            version = feature_set[:version]
            feature_version = SketchUp::SketchUpVersion.new(version)
            next unless feature_version > sketchup_target_version

            objects = feature_set[:types][type] || []
            if type == :method && instance_method?(feature_name)
              # Instance methods are simply matching the method name since it's
              # very difficult to determine the type of the receiver.
              full_feature_name = objects.find { |object|
                object.end_with?(feature_name)
              }
              next unless full_feature_name
            else
              next unless objects.include?(feature_name)
            end
            report(node, full_feature_name, feature_version, type)
          }
        end

        def report(node, feature_name, feature_version, feature_type)
          message = "The #{feature_type} `#{feature_name}` was added in " \
                    "#{feature_version} which is incompatible with target " \
                    "#{sketchup_target_version}."
          location = find_node_location(node)
          add_offense(node, location: location, message: message)
        end

        def find_node_location(node)
          # Highlight the most pertinent piece of the expression.
          if node.const_type?
            :expression
          elsif node.send_type?
            :selector
          elsif node.def_type?
            :name
          else # rubocop:disable Lint/DuplicateBranch
            :expression
          end
        end

        def module_method?(node)
          node.receiver&.const_type?
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
