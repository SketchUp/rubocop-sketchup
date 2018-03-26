# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class ModelEntities < Cop

        MSG = 'Typically one should use model.active_entities instead of model.entities.'.freeze

        # Reference: http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        def_node_matcher :active_model_entities?, <<-PATTERN
          (send
            (send (const nil? :Sketchup) :active_model) :entities)
        PATTERN

        def_node_matcher :entities_receiver, <<-PATTERN
          (send
            ({lvar ivar cvar} $_) :entities)
        PATTERN

        MODEL_VARIABLE_NAMES = %w[model mod]

        def model_entities?(node)
          return true if active_model_entities?(node)
          name = entities_receiver(node)
          name && model_variable?(name)
        end

        def on_send(node)
          add_offense(node, location: :expression) if model_entities?(node)
        end

        private

        def model_variable?(name)
          basename = variable_basename(name)
          MODEL_VARIABLE_NAMES.include?(basename)
        end

        def variable_basename(name)
          # Extract the basename from variables:
          #  model => model
          #  @model => model
          #  @@model => model
          name.to_s.tr('@', '')
        end

      end
    end
  end
end
