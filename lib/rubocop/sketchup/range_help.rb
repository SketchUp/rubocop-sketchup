# frozen_string_literal: true

module RuboCop
  module Cop
    # Methods that calculate and return Parser::Source::Ranges
    module RangeHelp

      private

      def range_with_receiver(node)
        loc_begin = node.receiver.loc.selector.begin_pos
        loc_end = node.loc.selector.end_pos
        range_between(loc_begin, loc_end)
      end

    end
  end
end
