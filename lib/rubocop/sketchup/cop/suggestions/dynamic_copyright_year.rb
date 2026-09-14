# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      class DynamicCopyrightYear < SketchUp::Cop
        MSG =
            'Dynamically using the current year as copyright year is '\
            'misleading. Prefer hardcoded actual year.'

        # Receivers we can resolve back to the object `SketchupExtension.new`
        # was assigned to.
        NAMED_RECEIVERS = %i[lvar ivar cvar gvar const].freeze

        def_node_matcher :extension_new?, <<-PATTERN
          (send (const nil? :SketchupExtension) :new ...)
        PATTERN

        def_node_search :copyright_set, <<-PATTERN
          (send $_ :copyright= $dstr)
        PATTERN

        def_node_search :contains_time_now?, <<-PATTERN
          (send (const nil? :Time) :now ...)
        PATTERN

        def on_send(node)
          return unless extension_new?(node)
          return unless node.parent&.assignment?

          assignment_node = node.parent
          # Multiple assignments (`masgn`) have no single name to match on.
          return unless assignment_node.respond_to?(:name)

          # This is the variable or constant name symbol (e.g., :extension)
          extension_variable_name = assignment_node.name

          scope_node = assignment_node.parent || assignment_node

          copyright_set(scope_node) do |receiver, dstr_node|
            next unless receiver && NAMED_RECEIVERS.include?(receiver.type)
            next unless node_name(receiver) == extension_variable_name

            if contains_time_now?(dstr_node)
              add_offense(receiver.parent)
            end
          end
        end

        private

        # `const` nodes carry their namespace, so the name is read differently
        # from the variable nodes.
        def node_name(node)
          node.const_type? ? node.short_name : node.name
        end

      end
    end
  end
end
