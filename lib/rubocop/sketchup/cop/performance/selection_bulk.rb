# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # Prefer changing selection in bulk instead of modifying selection within
      # loops. It's much faster to change the selection in bulk. UI updates are
      # triggered when you update the selection, so reduce the amount of calls.
      #
      # @example Poor performance
      #   model = Sketchup.active_model
      #   model.active_entities.each { |entity|
      #     model.selection.add(entity) if entity.is_a?(Sketchup::Face)
      #   }
      #
      # @example Better performance
      #   model = Sketchup.active_model
      #   faces = model.active_entities.map { |entity|
      #     entity.is_a?(Sketchup::Face)
      #   }
      #   model.selection.add(faces)
      #
      # @example Better performance and simpler
      #   model = Sketchup.active_model
      #   faces = model.active_entities.grep(Sketchup::Face)
      #   model.selection.add(faces)
      class SelectionBulkChanges < SketchUp::Base

        include RangeHelp

        MSG = 'Prefer changing selection in bulk instead of modifying ' \
              'selection within loops.'

        # http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        # https://rubocop.readthedocs.io/en/latest/node_pattern/
        # @!method selection?(node)
        def_node_matcher :selection?, <<-PATTERN
          (send
            (send _ {:selection :sel}) {:add :remove :toggle}
            ...)
        PATTERN

        # @!method block_loop?(node)
        def_node_matcher :block_loop?, <<-PATTERN
          (block
            (send
              (send _ _) {
                :each :each_with_index :each_with_object
                :each_entry :each_index :each_slice
                :each_key :each_pair :each_value
                :grep
              } ...)
              ...)
        PATTERN

        # @!method numeric_loop?(node)
        def_node_matcher :numeric_loop?, <<-PATTERN
          (block
            (send
              ({int float} _) {:times :upto :downto} ...)
              ...)
        PATTERN

        def iterator?(node)
          node.is_a?(RuboCop::AST::ForNode) ||
            node.is_a?(RuboCop::AST::UntilNode) ||
            node.is_a?(RuboCop::AST::WhileNode) ||
            block_loop?(node) ||
            numeric_loop?(node)
        end

        def on_send(node)
          return unless selection?(node)
          return unless node.ancestors.any?(&method(:iterator?))

          add_offense(range_with_receiver(node))
        end

      end
    end
  end
end
