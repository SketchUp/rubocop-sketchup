# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Due to how require and Sketchup.require checks whether a file has been
      # loaded, files from SketchUp's Tools folder should be required in using
      # `require` and with their file extension to avoid duplicate loading.
      class RequireToolsRubyFiles < Cop

        include SketchUp::NoCommentDisable

        MSG = "Require files from SketchUp's Tools directory with require.".freeze

        RUBY_FILES = %w[extensions.rb langhandler.rb sketchup.rb]


        def_node_matcher :ruby_require, <<-PATTERN
          (send nil? :require (str $_))
        PATTERN

        def_node_matcher :ruby_require?, <<-PATTERN
          (send nil? :require (str _))
        PATTERN


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


        def on_send(node)
          if ruby_require?(node)
            # The Tools folder Ruby files should be loaded using `require` and
            # include the ".rb" file extension.
            filename = ruby_require(node)
            return unless tools_file_required?(filename)
            return if expected_require_syntax?(filename)
            add_offense(node, location: :expression, severity: :error)
          elsif sketchup_require?(node)
            # The Tools folder Ruby files should not be loaded using
            # `Sketchup.require`.
            filename = sketchup_require(node)
            return unless tools_file_required?(filename)
            add_offense(node, location: :expression, severity: :error)
          end
        end

        private

        def tools_file_required?(filename)
          ext = File.extname(filename)
          full_filename = ext.empty? ? "#{filename}.rb" : filename
          RUBY_FILES.include?(full_filename.downcase)
        end

        def expected_require_syntax?(filename)
          RUBY_FILES.include?(filename)
        end

      end
    end
  end
end
