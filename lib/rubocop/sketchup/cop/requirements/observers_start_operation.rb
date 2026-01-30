# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Observers that perform model changes must create transparent operations
      # to ensure the user can easily undo.
      #
      # An important part of SketchUp's user experience is to be able to easily
      # undo any modification to the model. This is important to prevent
      # accidental loss of work.
      #
      # If you for example have an observer that assigns a material to new faces
      # then the user would still expect to undo this in a single operation.
      #
      # To achieve this, set the fourth argument in `model.start_operation` to
      # `true` in order to chain your observer operation to the previous
      # operation.
      #
      # @example
      #   class ExampleObserver < Sketchup::EntitiesObserver
      #     def onElementAdded(entities, entity)
      #       return unless entity.valid?
      #       return unless entity.is_a?(Sketchup::Face)
      #       entity.model.start_operation('Paint Face', true, false, true)
      #       entity.material = 'red'
      #       entity.model.commit_operation
      #     end
      #   end
      class ObserversStartOperation < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include RangeHelp

        MSG = 'Observers should create transparent operations.'

        def_node_search :start_operation, <<-PATTERN
          (send
            _ :start_operation
            ...)
        PATTERN

        OBSERVER_METHODS = %i[
          onActivateModel
          onNewModel
          onOpenModel
          onQuit
          onUnloadExtension

          onComponentInstanceAdded
          onComponentInstanceRemoved

          onComponentAdded
          onComponentPropertiesChanged
          onComponentRemoved
          onComponentTypeChanged

          onTextChanged

          onActiveSectionPlaneChanged
          onElementAdded
          onElementModified
          onElementRemoved
          onEraseEntities

          onChangeEntity
          onEraseEntity

          onClose
          onOpen

          onCurrentLayerChanged
          onLayerAdded
          onLayerChanged
          onLayerRemoved
          onRemoveAllLayers

          onMaterialAdd
          onMaterialChange
          onMaterialRefChange
          onMaterialRemove
          onMaterialSetCurrent
          onMaterialUndoRedo

          onActivePathChanged
          onAfterComponentSaveAs
          onBeforeComponentSaveAs
          onDeleteModel
          onEraseAll
          onExplode
          onPidChanged
          onPlaceComponent
          onPostSaveModel
          onPreSaveModel
          onSaveModel
          onTransactionAbort
          onTransactionCommit
          onTransactionEmpty
          onTransactionRedo
          onTransactionStart
          onTransactionUndo

          onOptionsProviderChanged

          onContentsModified
          onElementAdded
          onElementRemoved

          onRenderingOptionsChanged

          onSelectionAdded
          onSelectionBulkChange
          onSelectionCleared
          onSelectionRemoved

          onShadowInfoChanged

          onActiveToolChanged
          onToolStateChanged

          onViewChanged
        ].freeze

        def on_def(node)
          return unless observer_event?(node)

          operations = start_operation(node)
          operations.each { |operation|
            _name, _disable_ui, _next_tr, transparent = operation.arguments
            next unless transparent.nil? || transparent.falsey_literal?

            location = operation_location(operation)
            add_offense(location)
          }
        end

        private

        def range(node)
          range_between(node.begin_pos, node.end_pos)
        end

        def operation_location(node)
          # Highlight the fourth argument if it's used. Fall back to the method
          # name.
          transparent_argument = node.arguments[3]
          if transparent_argument
            range(transparent_argument.loc.expression)
          else
            node.loc.selector
          end
        end

        def observer_event?(node)
          OBSERVER_METHODS.include?(node.method_name)
        end

      end
    end
  end
end
