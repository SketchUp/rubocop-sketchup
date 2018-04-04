# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class ObserverModelChanges < SketchUp::Cop

        include SketchUp::NoCommentDisable

        MSG = 'Observers should not modify model without an operation.'.freeze

        def_node_search :start_operation, <<-PATTERN
          (send
            _ :start_operation
            ...)
        PATTERN

        MUTATING_METHODS = %i[
          add_3d_text
          add_arc
          add_circle
          add_classification
          add_cline
          add_cpoint
          add_curve
          add_dimension_linear
          add_dimension_radial
          add_edges
          add_face
          add_faces_from_mesh
          add_group
          add_image
          add_instance
          add_line
          add_matchphoto_page
          add_ngon
          add_note
          add_point
          add_polygon
          add_section_plane
          add_style
          add_text
          fill_from_mesh
          delete_attribute
          set_attribute
          remove_classification
          set_classification_value
          erase!
          erase_entities
          transformation=
          transform_entities
          transform_by_vectors
          definition=
          casts_shadows=
          hidden=
          visible=
          layer=
          material=
          back_material=
          receives_shadows=
          explode
          explode_curve
          find_faces
          soft=
          smooth=
          position_material
          pushpull
          locked=
          make_unique
          to_component
          page_behavior
          purge_unused
          colorize_type=
          set_plane
          arrow_type=
          display_leader=
          leader_type=
        ]

        def on_def(node)
          return unless model_mutator?(node)
          # TODO: ...
        end

        private

        def source_range(node)
          range_between(node.begin_pos, node.end_pos)
        end

        def operation_location(node)
          # Highlight the fourth argument if it's used. Fall back to the method
          # name.
          transparent_argument = node.arguments[3]
          if transparent_argument
            source_range(transparent_argument.loc.expression)
          else
            :selector
          end
        end

        def model_mutator?(node)
          MUTATING_METHODS.include?(node.method_name)
        end

      end
    end
  end
end
