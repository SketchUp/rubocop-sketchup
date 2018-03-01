# frozen_string_literal: true

module RuboCop
  module Cop
    module Sketchup
      module DynamicComponentGlobals

        DC_GLOBALS = %i[
          $dc_strings
          $dc_extension
          $dc_CONFIGURATOR_NAME
          $dc_REPORTER_NAME
          $dc_MANAGER_NAME
          $dc_observers
        ]

        private

        def dc_global_var?(global_var)
          DC_GLOBALS.include?(global_var)
        end

      end
    end
  end
end
