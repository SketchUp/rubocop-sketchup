# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # The idiomatic way to create groups via the Ruby API differ from the
      # way you'd do it from the UI.
      #
      # Using the API you should prefer to create the group first, then add
      # your geometry into the group. This is more performant and predictable.
      #
      # Grouping existing geometry via the API have historically been affected
      # by bugs and issues.
      #
      # If you do have to group existing geometry via the API, make sure you
      # group geometry from the active context; `model.active_entities`.
      # Otherwise you might run into unexpected issues, even crashes.
      #
      # @example Adding new geometry
      #   # bad
      #   face1 = model.active_entities.add_face(points1)
      #   face2 = model.active_entities.add_face(points2)
      #   group = model.active_entities.add_group([face1, face2])
      #
      #   # good
      #   group = model.active_entities.add_group
      #   face1 = group.entities.add_face(points1)
      #   face2 = group.entities.add_face(points2)
      class AddGroup < Cop

        include RangeHelp

        MSG = 'Avoid creating groups out of existing entities.'

        def_node_matcher :add_group?, <<-PATTERN
          (send _ :add_group ...)
        PATTERN

        def on_send(node)
          return unless add_group?(node)
          return if node.arguments.empty?

          add_offense(node, location: arguments_range(node))
        end

      end
    end
  end
end
