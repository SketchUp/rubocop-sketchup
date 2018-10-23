# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # String comparisons for type checks are very slow.
      #
      # `entity.class.name == 'Sketchup::Face'` is slow because it performs a
      # string comparison. `is_a?` is much faster because it's a simple type
      # check.
      #
      # If you know you need a strict type check, compare the classes directly:
      # `entity.class == Sketchup::Face`.
      #
      # @example Poor performance
      #   entity.class.name == 'Sketchup::Face'
      #
      # @example Good performance
      #   entity.class == Sketchup::Face
      #
      # @example Good performance and idiomatic Ruby convention
      #   entity.is_a?(Sketchup::Face)
      class TypeCheck < SketchUp::Cop

        # TODO(thomthom): It probably makes sense to eventually merge the
        #   Typename cop into this cop. But until this cop have been
        #   battle tested they remain separate. .typename is no prevalent in
        #   use (wrongly) that it's better to err in the name of caution, making
        #   sure we don't miss any scenarios.

        include RangeHelp

        MSG = 'String comparisons are very slow, prefer `.is_a?` '\
              'instead.'.freeze

        def on_send(node)
          return unless node.comparison_method?

          lhs = node.receiver
          return unless lhs.method_name == :name
          return unless lhs.receiver.send_type?
          return unless lhs.receiver.method_name == :class

          rhs = node.arguments.first
          return unless rhs.str_type?

          loc_begin = lhs.receiver.loc.selector.begin_pos
          loc_end = rhs.loc.expression.end_pos
          range = range_between(loc_begin, loc_end)
          add_offense(node, location: range)
        end
      end
    end
  end
end
