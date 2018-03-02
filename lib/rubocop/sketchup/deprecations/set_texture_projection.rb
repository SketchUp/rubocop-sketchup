# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      class SetTextureProjection < Cop

        MSG = 'Method is deprecated. It creates invalid UV mapping.'.freeze

        def_node_matcher :set_texture_projection?, <<-PATTERN
          (send _ :set_texture_projection ...)
        PATTERN

        def on_send(node)
          return unless set_texture_projection?(node)
          add_offense(node, location: :expression)
        end

      end
    end
  end
end
