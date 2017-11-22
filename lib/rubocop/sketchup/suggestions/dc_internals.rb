# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Tapping into the internals of Dynamic Components is risky. It could
      # change at any time.
      class DynamicComponentInternals < Cop

        MSG = "Avoid relying on internal logic of Dynamic Components.".freeze

        DC_GLOBALS = %i[
          $dc_strings
          $dc_extension
          $dc_CONFIGURATOR_NAME
          $dc_REPORTER_NAME
          $dc_MANAGER_NAME
          $dc_observers
        ]

        def dc_global_var?(global_var)
          DC_GLOBALS.include?(global_var)
        end

        def on_gvar(node)
          check(node)
        end

        def on_gvasgn(node)
          check(node)
        end

        def check(node)
          global_var, = *node
          return unless dc_global_var?(global_var)
          add_offense(node, location: :name, severity: :error)
        end

      end
    end
  end
end
