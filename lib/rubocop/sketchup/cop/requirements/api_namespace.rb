# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Do not modify the Sketch API. This will affect other extensions and
      # very likely cause them to fail.
      #
      # This requirement also include adding things into the SketchUp API
      # namespace. The API namespace is reserved for future additions to the
      # API.
      class ApiNamespace < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::NamespaceChecker

        MSG = 'Do not modify the SketchUp API.'

        NAMESPACES = %w[
          Geom Layout Sketchup SketchupExtension UI
        ].freeze

        def namespaces
          NAMESPACES
        end

      end
    end
  end
end
