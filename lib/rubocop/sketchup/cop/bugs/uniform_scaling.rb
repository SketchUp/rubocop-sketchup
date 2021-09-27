# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupBugs
      # Until SketchUp 2018 `Geom::Transformation.scaling(scale)` modified the
      # 16th value in the transformation matrix. This way of scaling the matrix
      # isn't fully accounted in all places in SketchUp. There are also a number
      # of exporters and render engines which also doesn't fully handle this.
      #
      # @example Workaround for SketchUp versions older than SketchUp 2018
      #     tr = Geom::Transformation.scaling(scale, scale, scale)
      class UniformScaling < SketchUp::Cop

        include SketchUp::SketchUpTargetRange

        define_sketchup_target_max_version 'SketchUp 2017'

        def_node_matcher :transformation_scaling?, <<-PATTERN
          (send (const (const nil? :Geom) :Transformation) :scaling _)
        PATTERN

        MSG = 'Resulting transformation matrix might yield unexpected '\
              'results.'

        def on_send(node)
          return unless valid_for_target_sketchup_version?
          return unless transformation_scaling?(node)

          add_offense(node.arguments.first)
        end

      end
    end
  end
end
