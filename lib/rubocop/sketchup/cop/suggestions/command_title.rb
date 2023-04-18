# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # SketchUp command titles should be in title case, e.g. "Make Component"
      # and "Follow Me".
      #
      # In English, capitalize the first letter of each word. Other languages
      # may have different rules.
      class CommandTitle < SketchUp::Cop

        def_node_matcher :init_entity?, <<-PATTERN
          (send (const (const nil? :UI) :Command ) :new ... )
        PATTERN

        MESSAGE = 'Use title case in command titles. '\
                  'In English, capitalize the first letter of each word.'

        def on_send(node)
          return unless init_entity?(node)
          return if title_case?(node.arguments.first.str_content)

          add_offense(node, message: MESSAGE)
        end

        private

        # REVIEW: Extract to where they can be re-used?
        def title_case?(text)
          text == title_case(text)
        end

        def title_case(text)
          text.gsub(/^(.)/) { ::Regexp.last_match(1).upcase }
              .gsub(/\ (.)/) { " #{::Regexp.last_match(1).upcase}" }
              .gsub(/-(.)/) { "-#{::Regexp.last_match(1).upcase}" }
              .gsub(/(\.)$/, '')
        end
      end
    end
  end
end
