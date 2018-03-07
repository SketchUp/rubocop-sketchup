# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Tapping into the internals of Dynamic Components is risky. It could
      # change at any time.
      class DynamicComponentInternals < Cop

        include SketchUp::DynamicComponentGlobals
        include SketchUp::DynamicComponentMethods

        MSG_GLOBAL = "Avoid relying on internal logic of Dynamic Components.".freeze


        def on_send(node)
          # Only check instance methods.
          return if node.receiver && node.receiver.const_type?

          name = node.method_name

          dc_method = DC_METHODS.find { |m| m[:name] == name }
          return unless dc_method

          if dc_method.key?(:variables) && node.receiver.variable?
            receiver_name = node.receiver.children.first
            # Account for instance and class variables.
            receiver_name = receiver_name.to_s.tr('@', '').to_sym
            return unless dc_method[:variables].include?(receiver_name)
          end

          path = dc_method[:path]
          message = "#{path}##{name} is not part of the official API. "\
                    "It's a monkey-patched addition by Dynamic Components."
          add_offense(node, severity: :error, message: message)
        end


        def on_gvar(node)
          check_global(node)
        end

        def on_gvasgn(node)
          check_global(node)
        end

        def check_global(node)
          global_var, = *node
          return unless dc_global_var?(global_var)
          add_offense(node, location: :name, severity: :error, message: MSG_GLOBAL)
        end

      end
    end
  end
end
