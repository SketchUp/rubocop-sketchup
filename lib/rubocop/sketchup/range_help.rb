# frozen_string_literal: true

module RuboCop
  module Cop
    # Methods that calculate and return Parser::Source::Ranges
    module RangeHelp

      private

      def range_with_receiver(node)
        receiver = node.receiver
        loc_begin = if receiver.send_type?
                      receiver.loc.selector.begin_pos
                    else
                      receiver.loc.expression.begin_pos
                    end
        loc_end = node.loc.selector.end_pos
        range_between(loc_begin, loc_end)
      end

    end
  end
end