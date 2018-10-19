# frozen_string_literal: true

module RuboCop
  module SketchUp
    module DynamicComponentMethods

      DC_METHODS = [
        {
          name: :rotx,
          path: 'Geom::Transformation',
        },
        {
          name: :roty,
          path: 'Geom::Transformation',
        },
        {
          name: :rotz,
          path: 'Geom::Transformation',
        },
        {
          name: :xscale,
          path: 'Geom::Transformation',
        },
        {
          name: :yscale,
          path: 'Geom::Transformation',
        },
        {
          name: :zscale,
          path: 'Geom::Transformation',
        },

        {
          name: :copy,
          path: 'Sketchup::Camera',
          variables: [:camera, :cam],
        },
        {
          name: :update,
          path: 'Sketchup::Camera',
          variables: [:camera, :cam],
        },
        {
          name: :same_camera_params?,
          path: 'Sketchup::Camera',
        },

        {
          name: :copy,
          path: 'Sketchup::ComponentInstance',
          variables: [:instance, :inst],
        },
        {
          name: :description,
          path: 'Sketchup::ComponentInstance',
          variables: [:instance, :inst],
        },

        {
          name: :local_transformation,
          path: 'Sketchup::Drawingelement',
        },
        {
          name: :scaled_size,
          path: 'Sketchup::Drawingelement',
        },
        {
          name: :unscaled_size,
          path: 'Sketchup::Drawingelement',
        },
        {
          name: :set_last_size,
          path: 'Sketchup::Drawingelement',
        },
        {
          name: :last_scaling_factors,
          path: 'Sketchup::Drawingelement',
        },

        {
          name: :get_attributes,
          path: 'Sketchup::Entity',
        },
        {
          name: :has_attributes?,
          path: 'Sketchup::Entity',
        },

        {
          name: :typename,
          path: 'Sketchup::Model',
          variables: [:model, :mod],
        },
        {
          name: :entityID,
          path: 'Sketchup::Model',
          variables: [:model, :mod],
        },
        {
          name: :delete_attribute,
          path: 'Sketchup::Model',
          variables: [:model, :mod],
        },
        {
          name: :layer,
          path: 'Sketchup::Model',
          variables: [:model, :mod],
        },

        {
          name: :last_width=,
          path: 'UI::WebDialog',
        },
        {
          name: :last_height=,
          path: 'UI::WebDialog',
        },
        {
          name: :last_width,
          path: 'UI::WebDialog',
        },
        {
          name: :last_height,
          path: 'UI::WebDialog',
        },
      ]

    end
  end
end
