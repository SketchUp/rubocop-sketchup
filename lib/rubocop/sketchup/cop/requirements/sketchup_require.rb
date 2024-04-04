# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Omit file extensions when using `Sketchup.require` to allow encrypted
      # files to be loaded.
      #
      # Ruby C extensions, `.so`/`.bundle` libraries must always be loaded via
      # the normal `require`.
      #
      # @example Bad - This will fail if extension is encrypted
      #   Sketchup.require 'hello/world.rb'
      #
      # @example Good - This will work for `.rbe`, `.rbs` and `rb` files.
      #   Sketchup.require 'hello/world'
      #
      # @example Bad - This will fail if extension is encrypted
      #   extension = SketchupExtension.new("Example", "Example/main.rb")
      #
      # @example Good - This will work for `.rbe`, `.rbs` and `rb` files.
      #   extension = SketchupExtension.new("Example", "Example/main")
      class SketchupRequire < SketchUp::Cop

        include SketchUp::ExtensionProject
        include SketchUp::NoCommentDisable
        include RangeHelp

        MSG_SKETCHUP_REQUIRE_EXT_NAME = 'Do not hard code file extensions ' \
                                        'with `Sketchup.require`.'

        MSG_EXTENSION_NEW_EXT_NAME = 'Do not hard code file extensions ' \
                                     'with `SketchupExtension.new`.'

        MSG_REQUIRE_FOR_BINARY = 'Use `require` instead of ' \
                                 '`Sketchup.require` to load binary Ruby ' \
                                 'libraries.'

        MSG_REQUIRE_ENCRYPTED = 'Use `Sketchup.require` when loading Ruby ' \
                                'files for encrypted extensions.'

        def_node_matcher :ruby_require, <<-PATTERN
          (send nil? :require (str $_))
        PATTERN

        def_node_matcher :ruby_require?, <<-PATTERN
          (send nil? :require (str _))
        PATTERN


        def_node_matcher :sketchup_require, <<-PATTERN
          (send (const nil? :Sketchup) :require (str $_))
        PATTERN

        def_node_matcher :sketchup_require?, <<-PATTERN
          (send (const nil? :Sketchup) :require (str _))
        PATTERN


        def_node_matcher :sketchup_extension_new, <<-PATTERN
          (send (const nil? :SketchupExtension) :new _ (str $_))
        PATTERN

        def_node_matcher :sketchup_extension_new?, <<-PATTERN
          (send (const nil? :SketchupExtension) :new _ (str _))
        PATTERN


        TOOLS_RUBY_FILES = %w[extensions.rb langhandler.rb sketchup.rb].freeze


        def on_send(node)
          if sketchup_require?(node)
            filename = sketchup_require(node)
            return if check_binary_sketchup_require(node, filename)
            return if check_sketchup_require_filename(node, filename)

          elsif ruby_require?(node)
            filename = ruby_require(node)
            return if check_encrypted_require(node, filename)

          elsif sketchup_extension_new?(node)
            filename = sketchup_extension_new(node)
            return if check_sketchup_extension_new_filename(node, filename)

          end
        end

        private

        def binary_require?(filename)
          return false unless extension_binaries?
          return false if extension_binaries.empty?

          extension_binaries.include?(filename)
        end

        def check_binary_sketchup_require(node, filename)
          return unless binary_require?(filename)

          end_pos = node.loc.dot.end_pos
          range = node.receiver.loc.expression.with(end_pos: end_pos)
          add_offense(node, location: range, message: MSG_REQUIRE_FOR_BINARY)
          true
        end

        def check_sketchup_require_filename(node, filename)
          return if valid_filename?(filename)

          add_offense(node, location: file_ext_range(node.arguments.first),
                            message: MSG_SKETCHUP_REQUIRE_EXT_NAME)
          true
        end

        def check_sketchup_extension_new_filename(node, filename)
          return if valid_filename?(filename)

          add_offense(node, location: file_ext_range(node.arguments.last),
                            message: MSG_EXTENSION_NEW_EXT_NAME)
          true
        end

        def check_encrypted_require(node, filename)
          return unless encrypted_extension?
          return unless extension_file?(filename)

          add_offense(node, location: node.loc.selector,
                            message: MSG_REQUIRE_ENCRYPTED)
          true
        end

        def first_directory(path)
          path.to_s.split(File::SEPARATOR).first.downcase
        end

        def extension_file?(filename)
          pathname = Pathname.new(filename).cleanpath
          return false unless pathname.relative?

          first_directory(extension_directory) == first_directory(pathname)
        end

        def valid_filename?(filename)
          File.extname(filename).empty? || TOOLS_RUBY_FILES.include?(filename)
        end

      end
    end
  end
end
