# frozen_string_literal: true

module RuboCop
  module SketchUp
    # Mix-in module for Cops that are valid only for a given SketchUp version
    # range. This mix-in uses the configured target SketchUp version to
    # determine if it's relevant.
    module SketchUpTargetRange

      module ClassMethods

        # @param [String] version
        def define_sketchup_target_min_version(version)
          @sketchup_target_min_version = SketchUpVersion.new(version)
          nil
        end

        # @param [String] version
        def define_sketchup_target_max_version(version)
          @sketchup_target_max_version = SketchUpVersion.new(version)
          nil
        end

        def sketchup_target_min_version
          @sketchup_target_min_version
        end

        def sketchup_target_max_version
          @sketchup_target_max_version
        end

      end # module ClassMethods

      def self.included(mod) # rubocop:disable Lint/MissingSuper
        mod.extend(ClassMethods)
      end

      def sketchup_target_min_version
        self.class.sketchup_target_min_version
      end

      def sketchup_target_max_version
        self.class.sketchup_target_max_version
      end

      def valid_for_target_sketchup_version?
        # If no target version is configured, ignore this check.
        return true unless sketchup_target_version?

        # If no version is set - then it's valid for all known versions.
        unless sketchup_target_min_version || sketchup_target_max_version
          return true
        end

        # If there is a finite version range, check if the target SketchUp
        # version is withing that.
        if sketchup_target_min_version && sketchup_target_max_version
          range = (sketchup_target_min_version..sketchup_target_max_version)
          return range.include?(sketchup_target_version)
        end

        if sketchup_target_min_version
          return sketchup_target_version >= sketchup_target_min_version
        end

        if sketchup_target_max_version
          return sketchup_target_version <= sketchup_target_max_version
        end

        raise 'bug!' # Should not end up here.
      end

    end
  end
end
