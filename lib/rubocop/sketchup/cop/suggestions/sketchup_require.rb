# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # Omit file extensions when using `Sketchup.require` to allow encrypted
      # files to be loaded.
      #
      # @example Bad - This will fail if extension is encrypted
      #   Sketchup.require 'hello/world.rb'
      #
      # @example Good - This will work for `.rbe`, `.rbs` and `rb` files.
      #   Sketchup.require 'hello/world'
      class SketchupRequire < SketchUp::Cop

        MSG = "Don't hard code file extensions with Sketchup.require".freeze

        # http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        # https://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :sketchup_require, <<-PATTERN
          (send
            (const nil? :Sketchup) :require
            (str $_)
          )
        PATTERN

        def_node_matcher :sketchup_require?, <<-PATTERN
          (send
            (const nil? :Sketchup) :require
            (str _)
          )
        PATTERN


        def_node_matcher :sketchup_extension_new, <<-PATTERN
          (send
            (const nil? :SketchupExtension) :new
            _
            (str $_))
        PATTERN

        def_node_matcher :sketchup_extension_new?, <<-PATTERN
          (send
            (const nil? :SketchupExtension) :new
            _
            (str _))
        PATTERN


        TOOLS_RUBY_FILES = %w[extensions.rb langhandler.rb sketchup.rb]


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
          File.extname(filename).empty? || TOOLS_RUBY_FILES.include?(filename)
        end

      end
    end
  end
end
