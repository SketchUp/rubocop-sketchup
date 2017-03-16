# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class ModelEntities < Cop
        MSG = 'Typically one should use model.active_entities instead of model.entities.'.freeze

        def on_send(node)
          receiver, method_name = *node
          return unless method_name == :entities
          # Assume common variable names for `model`.
          receiver_name = receiver.children.first
          return unless [:mod, :model].include?(receiver_name)
          add_offense(node, :expression)
        end
      end
    end
  end
end
