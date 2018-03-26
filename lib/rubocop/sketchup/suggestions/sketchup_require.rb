# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Omit file extensions when using Sketchup.require to allow encrypted
      # files to be loaded.
      class SketchupRequire < Cop

        MSG = "Don't hard code file extensions with Sketchup.require".freeze

        # http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        # https://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :sketchup_require, <<-PATTERN
          (send
            (const nil? :Sketchup) :require
            (str $_)
          )
        PATTERN

        # Temporarily disabled due to RuboCop bug:
        # https://github.com/bbatsov/rubocop/issues/5656
        # def_node_matcher :sketchup_require?, <<-PATTERN
        #   (send
        #     (const nil? :Sketchup) :require
        #     (str _)
        #   )
        # PATTERN


        def_node_matcher :sketchup_extension_new, <<-PATTERN
          (send
            (const nil? :SketchupExtension) :new
            _
            (str $_))
        PATTERN

        # Temporarily disabled due to RuboCop bug:
        # https://github.com/bbatsov/rubocop/issues/5656
        # def_node_matcher :sketchup_extension_new?, <<-PATTERN
        #   (:send
        #     (:const nil? :SketchupExtension) :new
        #     _
        #     (str _))
        # PATTERN


        def on_send(node)
          if sketchup_require?(node)
            filename = sketchup_require(node)
          elsif sketchup_extension_new?(node)
            filename = sketchup_extension_new(node)
          else
            return
          end
          add_offense(node, location: :expression) unless valid_filename?(filename)
        end

        private

        def valid_filename?(filename)
          File.extname(filename).empty?
        end

        # Workaround for RuboCop bug:
        # https://github.com/bbatsov/rubocop/issues/5656
        def sketchup_require?(node)
          node.method_name == :require && sketchup_require(node)
        end

        # Workaround for RuboCop bug:
        # https://github.com/bbatsov/rubocop/issues/5656
        def sketchup_extension_new?(node)
          node.method_name == :new && sketchup_extension_new(node)
        end

      end
    end
  end
end
