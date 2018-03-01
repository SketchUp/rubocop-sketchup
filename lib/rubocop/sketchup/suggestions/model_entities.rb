# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class ModelEntities < Cop

        MSG = 'Typically one should use model.active_entities instead of model.entities.'.freeze

        # Reference: http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        #
        # {} will match any of the patterns inside the brackets.
        #
        # Testing for; Sketchup.active_model
        #   (send (const nil :Sketchup) :active_model)
        #
        # Testing for; model.entities or mod.entities
        #   (lvar {:model :mod})
        def_node_matcher :model_entities?, <<-PATTERN
          (send
            {
              (send (const nil? :Sketchup) :active_model)
              (lvar {:model :mod})
            }
            :entities)
        PATTERN

        def on_send(node)
          add_offense(node, location: :expression) if model_entities?(node)
        end
      end
    end
  end
end
