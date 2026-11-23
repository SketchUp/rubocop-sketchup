# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::SketchupRequire do

  subject(:cop) do
    cop = described_class.new(config)

    def cop.extension_directory
      'Example'
    end

    cop
  end

  let(:config) do
    rubocop_config = {
      'AllCops' => {
        'SketchUp' => {
          'ExtensionBinaries' => ['Example/cext'],
        },
      },
    }
    RuboCop::Config.new(rubocop_config, 'fake_cop_config.yml')
  end

  context 'Sketchup.require filename' do

    it 'registers an offense when using `Sketchup.require` with file extension' do
      expect_offense(<<~RUBY)
        Sketchup.require("filename.rb")
                                  ^^^ Do not hard code file extensions with `Sketchup.require`. Extension Warehouse encrypts `.rb` files to `.rbe` and this file would then fail to load. Remove the file extension.
      RUBY
    end

    it 'registers an offense when using `Sketchup::require` with file extension' do
      expect_offense(<<~RUBY)
        Sketchup::require("filename.rb")
                                   ^^^ Do not hard code file extensions with `Sketchup.require`. Extension Warehouse encrypts `.rb` files to `.rbe` and this file would then fail to load. Remove the file extension.
      RUBY
    end

    it 'registers an offense when using `Sketchup::require` to load binary Ruby lib' do
      expect_offense(<<~RUBY)
        Sketchup.require("Example/cext")
        ^^^^^^^^^ Use `require` instead of `Sketchup.require` to load binary Ruby libraries.
      RUBY
    end

    it 'does not register an offense when the dot is part of the file name' do
      expect_no_offenses(<<~RUBY)
        Sketchup.require("Example/main.v2")
      RUBY
    end

    it 'does not register an offense when using `Sketchup.require` without file extension' do
      expect_no_offenses(<<~RUBY)
        Sketchup.require("filename")
      RUBY
    end

    it 'does not register an offense when using `Sketchup::require` without file extension' do
      expect_no_offenses(<<~RUBY)
        Sketchup::require("filename")
      RUBY
    end

    it 'does not register an offense when using `Sketchup.require` with a variable' do
      # Do not flag path params which aren't string variables as it's much harder
      # to resolve the content of the variable.
      expect_no_offenses(<<~RUBY)
        filename = "filename.rb"
        Sketchup.require(filename)
      RUBY
    end

  end

  context 'require filename' do

    it 'does not register an offense when using `require` without file extension' do
      expect_no_offenses(<<~RUBY)
        require("filename")
      RUBY
    end

    it 'does not register an offense when using `require` with a .rb file extension' do
      expect_no_offenses(<<~RUBY)
        require("filename.rb")
      RUBY
    end

    it 'does not register an offense when using `require` with .so file extension' do
      expect_no_offenses(<<~RUBY)
        require("example/cext.so")
      RUBY
    end

    it 'does not register an offense when using `require` with .bundle file extension' do
      expect_no_offenses(<<~RUBY)
        require("example/cext.bundle")
      RUBY
    end

  end

  context 'encrypted extension' do

    let(:config) do
      rubocop_config = {
        'AllCops' => {
          'SketchUp' => {
            'EncryptedExtension' => true,
            'ExtensionBinaries' => ['Example/cext'],
          },
        },
      }
      RuboCop::Config.new(rubocop_config, 'fake_cop_config.yml')
    end

    it 'uses the same message for every file so the report groups them' do
      expect_offense(<<~RUBY)
        require "Example/main"
        ^^^^^^^ Use `Sketchup.require` when loading Ruby files for encrypted extensions. Extension Warehouse encrypts `.rb` files to `.rbe`, which Ruby's `require` cannot load. Pass the path without a file extension.
        require "Example/other"
        ^^^^^^^ Use `Sketchup.require` when loading Ruby files for encrypted extensions. Extension Warehouse encrypts `.rb` files to `.rbe`, which Ruby's `require` cannot load. Pass the path without a file extension.
        require 'Example/third.rb'
        ^^^^^^^ Use `Sketchup.require` when loading Ruby files for encrypted extensions. Extension Warehouse encrypts `.rb` files to `.rbe`, which Ruby's `require` cannot load. Pass the path without a file extension.
      RUBY
    end

    it 'registers an offense when using `require` to load extension Ruby files' do
      expect_offense(<<~RUBY)
        require "Example/main"
        ^^^^^^^ Use `Sketchup.require` when loading Ruby files for encrypted extensions. Extension Warehouse encrypts `.rb` files to `.rbe`, which Ruby's `require` cannot load. Pass the path without a file extension.
      RUBY
    end

    it 'does not register an offense when using `require` to load Ruby files not part of the extension' do
      expect_no_offenses(<<~RUBY)
        require "json"
      RUBY
    end

    it 'does not register an offense when using `Sketchup.require` to load extension Ruby files' do
      expect_no_offenses(<<~RUBY)
        Sketchup.require "Example/main"
      RUBY
    end

    it 'registers an offense when using `Sketchup::require` to load binary Ruby lib' do
      expect_offense(<<~RUBY)
        Sketchup.require("Example/cext")
        ^^^^^^^^^ Use `require` instead of `Sketchup.require` to load binary Ruby libraries.
      RUBY
    end

  end

  context 'SketchupExtension.new' do

    it 'registers an offense when using `SketchupExtension.new` with file extension' do
      expect_offense(<<~RUBY)
        extension = SketchupExtension.new("Example", "Example/main.rb")
                                                                  ^^^ Do not hard code file extensions with `SketchupExtension.new`. Extension Warehouse encrypts `.rb` files to `.rbe` and the extension would then fail to load. Remove the file extension.
      RUBY
    end

    it 'does not register an offense when the dot is part of the file name' do
      expect_no_offenses(<<~RUBY)
        extension = SketchupExtension.new("Example", "Example/main.v2")
      RUBY
    end

    it 'does not register an offense when using `SketchupExtension.new` without file extension' do
      expect_no_offenses(<<~RUBY)
        extension = SketchupExtension.new("Example", "Example/main")
      RUBY
    end

    it 'does not register an offense when using `SketchupExtension.new` variable for load param' do
      # Do not flag path params which aren't string variables as it's much harder
      # to resolve the content of the variable.
      # TODO(thomthom): This is being done elsewhere now. Can attempt to resolve
      #   this for common patterns.
      expect_no_offenses(<<~RUBY)
        loader = "Example/main.rb"
        extension = SketchupExtension.new("Example", loader)
      RUBY
    end

  end

  context 'requiring files from Tools folder' do

    described_class::TOOLS_RUBY_FILES.each { |filename|
      it "does not register an offense requiring `#{filename}`" do
        expect_no_offenses(<<~RUBY)
          Sketchup.require '#{filename}'
        RUBY
      end
    }

  end

end
