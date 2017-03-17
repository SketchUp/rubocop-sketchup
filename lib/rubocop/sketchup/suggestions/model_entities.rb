# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class ModelEntities < Cop
        MSG = 'Typically one should use model.active_entities instead of model.entities.'.freeze

        def on_send(node)
          receiver, method_name = *node
          return unless method_name == :entities
          if receiver.type == :send
            # TODO(thomthom): See if better syntax matching can be used.
            #   Rubocop appear to have some facility for this.
            # Check if this is an Sketchup.active_model.entities call.
            entities_receiver, receiver_name = *receiver
            _, active_model_receiver = *entities_receiver
            return unless active_model_receiver == :Sketchup
            return unless receiver_name == :active_model
          else
            # Assume common variable names for `model`.
            receiver_name = receiver.children.first
            return unless [:mod, :model].include?(receiver_name)
          end
          add_offense(node, :expression)
        end
      end
    end
  end
end
