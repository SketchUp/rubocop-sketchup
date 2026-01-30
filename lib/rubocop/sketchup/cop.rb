# frozen_string_literal: true

module RuboCop
  module SketchUp

    # @abstract parent class to SketchUp cops
    #
    # The criteria for whether rubocop-sketchup analyzes a certain ruby file
    # is configured via `AllCops/SketchUp`. For example, if you want to
    # customize your project to scan all files within a `test/` directory
    # then you could add this to your configuration:
    #
    # @example configuring analyzed paths
    #
    #   AllCops:
    #     SketchUp:
    #       SketchupDeprecations:
    #         Exclude:
    #         - '_test.rb$'
    #         - '(?:^|/)test/'
    class Cop < RuboCop::Cop::Base

      include SketchUp::Config

      SKETCHUP_DEPARTMENT_SEVERITY = {
        SketchupRequirements: :error,
        SketchupDeprecations: :warning,
        SketchupPerformance: :warning,
        SketchupBugs: :warning,
        SketchupSuggestions: :convention,
      }.freeze

      def relevant_file?(file)
        relevant_rubocop_sketchup_file?(file) && super
      end

      private

      def default_severity
        sketchup_severity || super
      end

      def sketchup_severity
        SKETCHUP_DEPARTMENT_SEVERITY[self.class.department]
      end

      def department_name
        self.class.department.to_s
      end

      def relevant_rubocop_sketchup_file?(file)
        !sketchup_excluded?(file)
      end

      def sketchup_excluded?(file)
        matches_file?(file, sketchup_exclude_pattern) ||
          matches_file?(file, sketchup_department_exclude_pattern)
      end

      def matches_file?(file, patterns)
        path = nil
        patterns.any? do |pattern|
          # Try to match the absolute path, as Exclude properties are absolute.
          next true if match_path?(pattern, file)

          # Try with relative path.
          path ||= config.path_relative_to_config(file)
          match_path?(pattern, path)
        end
      end

      def sketchup_department_exclude_pattern
        sketchup_cops_config
          .fetch(department_name, {})
          .fetch('Exclude', [])
      end

      def sketchup_exclude_pattern
        sketchup_cops_config
          .fetch('Exclude', [])
      end

    end
  end
end
