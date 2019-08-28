# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Prefer `model.active_entities` over `model.entities`.
      #
      # Most tools/actions act upon the active entities context. This could be
      # an opened group or component instance. Because of this, prefer
      # `model.active_entities` by default over `model.entities` unless you
      # have an explicit reason to work in the root model context.
      class ModelEntities < SketchUp::Cop

        MSG = 'Prefer `model.active_entities` over `model.entities`.'

        # Reference: http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        def_node_matcher :active_model_entities?, <<-PATTERN
          (send
            (send (const nil? :Sketchup) :active_model) :entities)
        PATTERN

        def_node_matcher :entities_receiver, <<-PATTERN
          (send
            ({lvar ivar cvar} $_) :entities)
        PATTERN

        MODEL_VARIABLE_NAMES = %w[model mod].freeze

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
