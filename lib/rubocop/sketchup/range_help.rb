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
                      receiver.source_range.begin_pos
                    end
        loc_end = node.loc.selector.end_pos
        range_between(loc_begin, loc_end)
      end

      def string_contents_range(node)
        begin_pos = node.loc.begin.end_pos
        end_pos = node.loc.end.begin_pos
        range_between(begin_pos, end_pos)
      end

      def arguments_range(node)
        begin_pos = node.arguments.first.source_range.begin_pos
        end_pos = node.arguments.last.source_range.end_pos
        range_between(begin_pos, end_pos)
      end

      def conditional_range(node)
        if node.modifier_form?
          range_between(node.loc.keyword.begin_pos,
                        node.source_range.end_pos)
        else
          :expression
        end
      end

      def file_ext_range(argument_node)
        filename = argument_node.str_content
        ext_size = File.extname(filename).size
        end_pos = argument_node.loc.end.begin_pos
        begin_pos = end_pos - ext_size
        range_between(begin_pos, end_pos)
      end

    end
  end
end
