# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupBugs
      # A regression was introduced in SketchUp 2017 that cause invalid render
      # modes to crash SketchUp. The crash might not happen exactly when the
      # new mode is set, but later when the viewport re-draws.
      #
      # Valid render modes are: (Internal enum names in parentheses)
      #
      # * `0` (`kRenderWireframe`)
      # * `1` (`kRenderHidden`)
      # * `2` (`kRenderFlat`)
      # * `3` (`kRenderSmooth`)
      # * `5` (`kRenderNoMaterials`)
      #
      # @example This obsolete render mode will crash SketchUp 2017 and newer
      #   Sketchup.active_model.rendering_options["RenderMode"] = 4
      #
      # @example This invalid render mode will crash SketchUp 2017 and newer
      #   Sketchup.active_model.rendering_options["RenderMode"] = 99
      class RenderMode < SketchUp::Cop

        include SketchUp::SketchUpTargetRange

        define_sketchup_target_min_version 'SketchUp 2017'

        RENDER_MODE_VALID = [
          0, # kRenderWireframe,
          1, # kRenderHidden,
          2, # kRenderFlat,
          3, # kRenderSmooth,
          5, # kRenderNoMaterials
        ].freeze

        RENDER_MODE_OBSOLETE = [
          4, # kRenderTextureObsolete,
        ].freeze

        def_node_matcher :set_render_mode, <<-PATTERN
          (send _ :[]= (str "RenderMode") (int $_))
        PATTERN

        MSG_OBSOLETE = 'Obsolete render mode will crash in SU2017 and '\
            'newer versions.'.freeze

        MSG_INVALID = 'Invalid render mode will crash in SU2017 and '\
            'newer versions.'.freeze

        def on_send(node)
          return unless valid_for_target_sketchup_version?

          value = set_render_mode(node)
          return if value.nil?
          return if RENDER_MODE_VALID.include?(value)

          value_node = node.arguments.last
          message = obsolete?(value) ? MSG_OBSOLETE : MSG_INVALID
          add_offense(value_node, message: message)
        end

        private

        def obsolete?(value)
          RENDER_MODE_OBSOLETE.include?(value)
        end

      end
    end
  end
end
