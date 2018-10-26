# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # When drawing 3D geometry to the viewport from a tool, make sure to
      # implement `getExtents` that return a `Geom::BoundingBox` object large
      # enough to encompass what you draw.
      #
      # With out doing that the drawn content might end up being clipped.
      #
      # @example
      #   # good
      #   class ExampleTool
      #
      #     def getExtents
      #       bounds = Geom::BoundingBox.new
      #       bounds.add(@points)
      #       bounds
      #     end
      #
      #     def draw(view)
      #       view.draw(GL_LINES, @points)
      #     end
      #
      #   end
      class ToolDrawingBounds < Cop

        include SketchUp::ToolChecker

        MSG_MISSING_GET_EXTENTS = 'When drawing to the viewport implement '\
            '`getExtents` so drawn geometry is not clipped.'.freeze

        def on_tool_class(class_node, body_methods)
          return unless find_method(body_methods, :draw)
          return if find_method(body_methods, :getExtents)

          add_offense(class_node, message: MSG_MISSING_GET_EXTENTS)
        end

      end
    end
  end
end
