# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # SketchUp Entity objects (`Face`, `Edge`, `Group` etc) should not be
      # initialized using the `new` constructor. These objects are managed by
      # SketchUp. Instead use the `Sketchup::Entities#add_*` methods to create
      # them.
      class InitializeEntity < SketchUp::Cop

        ENTITY_CLASSES = %i[
          ComponentDefinition
          ComponentInstance
          ConstructionLine
          ConstructionPoint
          Dimension
          DimensionLinear
          DimensionRadial
          Edge
          Face
          Group
          Image
          SectionPlane
          Text
          AttributeDictionaries
          AttributeDictionary
          Axes
          Behavior
          Curve
          DefinitionList
          Drawingelement
          EdgeUse
          Layer
          LayerFolder
          Layers
          LineStyle
          LineStyles
          Loop
          Material
          Materials
          Page
          Pages
          RenderingOptions
          ShadowInfo
          Style
          Styles
          Texture
          Vertex
        ].freeze

        def_node_matcher :init_entity?, <<-PATTERN
          (send (const (const nil? :Sketchup) #entity? ) :new ... )
        PATTERN

        MSG_INITIALIZE_ENTITY = 'Entity objects (Face, Edge, Group etc) are ' \
                                'managed SketchUp. Instead of using the ' \
                                '`new` constructor, use the ' \
                                '`Sketchup::Entities#add_*` methods.'

        def on_send(node)
          return unless init_entity?(node)

          add_offense(node, message: MSG_INITIALIZE_ENTITY)
        end

        private

        def entity?(sym)
          ENTITY_CLASSES.include?(sym)
        end

      end
    end
  end
end
