# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # Method is deprecated because it creates invalid UV mapping. Saving the
      # model will display a dialog indicating that the model needs to be
      # repaired. Once repaired the UV mapping will visually change.
      class SetTextureProjection < SketchUp::Cop

        MSG = 'Method is deprecated. It can create invalid UV mapping.'.freeze

        def_node_matcher :set_texture_projection?, <<-PATTERN
          (send _ :set_texture_projection ...)
        PATTERN

        def on_send(node)
          return unless set_texture_projection?(node)

          add_offense(node, location: :selector)
        end

      end
    end
  end
end
