# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class ApiNamespace < Cop

        include NoCommentDisable
        include Sketchup::NamespaceChecker

        MSG = 'Do not modify the SketchUp API.'.freeze

        NAMESPACES = %w(
          Geom Layout Sketchup SketchupExtension UI
        ).freeze

        def namespaces
          NAMESPACES
        end

      end
    end
  end
end
