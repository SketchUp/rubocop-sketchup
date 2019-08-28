# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Some of the shipped extensions in SketchUp monkey-patch the API
      # namespace. This is an unfortunate no-no that was done a long time ago
      # before the extension best-practices were established. These functions
      # might change or be removed at any time. They will also not work when
      # the extensions are disabled. Avoid using these methods.
      class MonkeyPatchedApi < SketchUp::Cop

        include SketchUp::DynamicComponentMethods

        def on_send(node)
          # Only check instance methods.
          return if node.receiver&.const_type?

          name = node.method_name

          dc_method = DC_METHODS.find { |m| m[:name] == name }
          return unless dc_method

          if dc_method.key?(:variables)
            return unless node.receiver&.variable?

            receiver_name = node.receiver.children.first
            # Account for instance and class variables.
            receiver_name = receiver_name.to_s.tr('@', '').to_sym
            return unless dc_method[:variables].include?(receiver_name)
          end

          path = dc_method[:path]
          message = "#{path}##{name} is not part of the official API. "\
                    "It's a monkey-patched addition by Dynamic Components."
          add_offense(node,
                      location: :selector,
                      severity: :warning,
                      message: message)
        end

      end
    end
  end
end
