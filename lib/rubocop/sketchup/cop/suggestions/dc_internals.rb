# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Tapping into the internals of Dynamic Components is risky. It could
      # change at any time. If you create an extension that depend on the
      # internal logic of another extension you are at the mercy of change and
      # luck!
      class DynamicComponentInternals < SketchUp::Cop

        include SketchUp::DynamicComponentGlobals

        MSG = 'Avoid relying on internal logic of Dynamic Components.'

        def on_gvar(node)
          check_global(node)
        end

        def on_gvasgn(node)
          check_global(node)
        end

        def check_global(node)
          global_var, = *node
          return unless dc_global_var?(global_var)

          add_offense(node.loc.name, severity: :warning)
        end

      end
    end
  end
end
