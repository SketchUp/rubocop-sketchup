# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Don't modify SketchUp's shipped extensions.
      class ShippedExtensionsNamespace < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::NamespaceChecker

        MSG = 'Do not modify shipped extensions.'.freeze

        # We check only against the top level namespaces. The core define more
        # objects, but they are under one of the top level namespaces listed.

        NAMESPACES_ADVANCED_CAMERA_TOOLS = %w(
          ACTUtil
          CameraAppObserver
          CameraEntityObserver
          CameraFrameChangeObserver
          CameraRep
          CameraToolModelObserver
          CameraToolPagesObserver
          CameraToolViewObserver
          FilmCameraTool
          FSCameraData
          FSGeomUtils
          FSValidate
          PageNameChangeObserver
        ).freeze

        NAMESPACES_DYNAMIC_COMPONENTS = %w(
          DCConverter
          DCDownloader
          DCFunctionsV1
          DCInteractTool
          DCObservers
          DCProgressBar
          DynamicComponents
          DynamicComponentsV1
        ).freeze

        NAMESPACES_TRIMBLE_CONNECT = %w(
          Trimble
        ).freeze

        NAMESPACES = (
          NAMESPACES_ADVANCED_CAMERA_TOOLS |
          NAMESPACES_DYNAMIC_COMPONENTS |
          NAMESPACES_TRIMBLE_CONNECT
        ).freeze

        def namespaces
          NAMESPACES
        end

      end
    end
  end
end
