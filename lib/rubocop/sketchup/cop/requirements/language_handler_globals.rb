# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Avoid using globals in general, but especially these which are known to
      # be in use by other extensions made by SketchUp.
      # They are still in use due to compatibility reasons.
      class LanguageHandlerGlobals < SketchUp::Cop

        include SketchUp::NoCommentDisable

        MSG = 'Avoid globals in general, but especially these which are known '\
              'to be in use.'.freeze

        LH_GLOBALS = %i[
          $dc_strings
          $devl_strings
          $exStrings
          $fs_strings
          $make_pano_string
          $oceanStrings
          $sn_strings
          $ssf_strings
          $suStrings
          $tStrings
          $unitsStrings
          $uStrings
          $wt_strings
        ].freeze

        def hl_global_var?(global_var)
          LH_GLOBALS.include?(global_var)
        end

        def on_gvasgn(node)
          global_var, = *node
          return unless hl_global_var?(global_var)

          add_offense(node, location: :name)
        end

      end
    end
  end
end
