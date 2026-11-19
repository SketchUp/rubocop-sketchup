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

        ENCRYPTED = 'Extension Warehouse encrypts `.rb` files to `.rbe`'

        MSG_SKETCHUP_REQUIRE_EXT_NAME = 'Do not hard code file extensions ' \
                                        'with `Sketchup.require`. ' \
                                        "#{ENCRYPTED} and this file would " \
                                        'then fail to load. Use ' \
                                        '`Sketchup.require(%<path>s)` instead.'

        MSG_EXTENSION_NEW_EXT_NAME = 'Do not hard code file extensions ' \
                                     'with `SketchupExtension.new`. ' \
                                     "#{ENCRYPTED} and the extension would " \
                                     'then fail to load. Use ' \
                                     '`SketchupExtension.new(%<name>s, ' \
                                     '%<path>s)` instead.'

        MSG_REQUIRE_FOR_BINARY = 'Use `require` instead of ' \
                                 '`Sketchup.require` to load binary Ruby ' \
                                 'libraries. Use `require(%<path>s)` instead.'

        MSG_REQUIRE_ENCRYPTED = 'Use `Sketchup.require` when loading Ruby ' \
                                'files for encrypted extensions. ' \
                                "#{ENCRYPTED}, which Ruby's `require` " \
                                'cannot load. Use ' \
                                '`Sketchup.require(%<path>s)` instead.'

        def_node_matcher :ruby_require, <<-PATTERN
          (send nil? :require (str $_))
        PATTERN

        def_node_matcher :sketchup_require, <<-PATTERN
          (send (const nil? :Sketchup) :require (str $_))
        PATTERN

        def_node_matcher :sketchup_extension_new, <<-PATTERN
          (send (const nil? :SketchupExtension) :new _ (str $_))
        PATTERN

        RUBY_FILE_EXT = /\.(?:rb|rbe|rbs)\z/.freeze

        TOOLS_RUBY_FILES = %w[extensions.rb langhandler.rb sketchup.rb].freeze


        def on_send(node)
          if (filename = sketchup_require(node))
            return if check_binary_sketchup_require(node, filename)

            check_sketchup_require_filename(node, filename)
          elsif (filename = ruby_require(node))
            check_encrypted_require(node, filename)
          elsif (filename = sketchup_extension_new(node))
            check_sketchup_extension_new_filename(node, filename)
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
          path = string_literal_like(node.first_argument, filename)
          message = format(MSG_REQUIRE_FOR_BINARY, path: path)
          add_offense(range, message: message)
          true
        end

        def check_sketchup_require_filename(node, filename)
          return if valid_filename?(filename)

          argument = node.first_argument
          path = string_literal_like(argument, without_file_ext(filename))
          message = format(MSG_SKETCHUP_REQUIRE_EXT_NAME, path: path)
          add_offense(file_ext_range(argument), message: message)
          true
        end

        def check_sketchup_extension_new_filename(node, filename)
          return if valid_filename?(filename)

          argument = node.last_argument
          path = string_literal_like(argument, without_file_ext(filename))
          message = format(MSG_EXTENSION_NEW_EXT_NAME,
                           name: node.first_argument.source, path: path)
          add_offense(file_ext_range(argument), message: message)
          true
        end

        def check_encrypted_require(node, filename)
          return unless encrypted_extension?
          return unless extension_file?(filename)

          path = without_ruby_ext(filename)
          path = string_literal_like(node.first_argument, path)
          message = format(MSG_REQUIRE_ENCRYPTED, path: path)
          add_offense(node.loc.selector, message: message)
          true
        end

        # `require` doesn't need a file extension, so only strip the ones Ruby
        # files can have. Other dots belong to the name, as in `main.v2`.
        def without_ruby_ext(filename)
          filename.sub(RUBY_FILE_EXT, '')
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
