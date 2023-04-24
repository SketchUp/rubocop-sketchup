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
          return if node.arguments.first.str_content.nil?
          return if title_case?(node.arguments.first.str_content)

          add_offense(node, message: MESSAGE)
        end

        private

        # REVIEW: Extract to where they can be re-used?

        # Test if string is in title case
        # (first letter of each word capitalized and no trailing period.)
        def title_case?(text)
          text == title_case(text) && text[-1] != '.'
        end

        # Capitalize the worst letter of each word (including after a hyphen).
        def title_case(text)
          # Capitalize the first letter of the string, the first letter after
          # each space and first letter after each hyphen.
          text.gsub(/^(.)/) { ::Regexp.last_match(1).upcase }
              .gsub(/\ (.)/) { " #{::Regexp.last_match(1).upcase}" }
              .gsub(/-(.)/) { "-#{::Regexp.last_match(1).upcase}" }
        end
      end
    end
  end
end
