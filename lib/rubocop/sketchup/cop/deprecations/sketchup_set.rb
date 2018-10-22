# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupDeprecations
      # From SketchUp 6 until SketchUp 2013 the SketchUp API shipped with a
      # `Set` class. When SketchUp started shipping with the Ruby StdLib in
      # SketchUp 2014 the class was changed from `Set` to `Sketchup::Set` in
      # order to avoid conflict with the Ruby Standard Library.
      #
      # The `Sketchup::Set` class is much slower than Ruby's own `Set` class
      # and less versatile.
      class SketchupSet < SketchUp::Cop

        MSG = 'Class is deprecated.'.freeze

        def_node_matcher :sketchup_set?, <<-PATTERN
          (const (const nil? :Sketchup) :Set)
        PATTERN

        def on_const(node)
          return unless sketchup_set?(node)

          add_offense(node, location: :expression)
        end

      end
    end
  end
end
