# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::SketchupExtension, :config do

  context 'Default source path' do

    # Based on file_name_spec.rb
    let(:config) do
      RuboCop::Config.new({}, 'fake_cop_config.yml')
    end

    old_pwd = nil

    before do
      old_pwd = Dir.pwd
      Dir.chdir('examples/extensions/valid')
    end

    after do
      Dir.chdir(old_pwd)
    end

    it 'registers an offense for missing SketchupExtension in root file' do
      expect_offense(<<~RUBY, './src/hello.rb')
        foo(123)
        ^{} SketchupExtension.new not found.
      RUBY
    end

    it 'registers an offense for missing name argument in SketchupExtension.new' do
      expect_offense(<<~RUBY, './src/hello.rb')
        extension = SketchupExtension.new
                    ^^^^^^^^^^^^^^^^^^^^^ Missing required name arguments
        Sketchup.register_extension(extension, true)
      RUBY
    end

    it 'registers an offense for missing path argument in SketchupExtension.new' do
      expect_offense(<<~RUBY, './src/hello.rb')
        extension = SketchupExtension.new('Extension Name')
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Missing second argument for the path
        Sketchup.register_extension(extension, true)
      RUBY
    end

    it 'does not register an offense for missing SketchupExtension in support file' do
      expect_no_offenses(<<~RUBY, './src/hello/world.rb')
        foo(123)
      RUBY
    end

    it 'does not register an offense for SketchupExtension in root file' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      RUBY
    end

    it 'does not register an offense for namespaced SketchupExtension in root file assigned to local variable' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          extension = SketchupExtension.new("Extension Name", filename)
          extension.description = "Hello World"
          Sketchup.register_extension(extension, true)
        end
      RUBY
    end

    it 'does not register an offense for namespaced SketchupExtension in root file assigned to instance variable' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          @extension = SketchupExtension.new("Extension Name", filename)
          @extension.description = "Hello World"
          Sketchup.register_extension(@extension, true)
        end
      RUBY
    end

    it 'does not register an offense for namespaced SketchupExtension in root file assigned to class variable' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          @@extension = SketchupExtension.new("Extension Name", filename)
          @@extension.description = "Hello World"
          Sketchup.register_extension(@@extension, true)
        end
      RUBY
    end

    it 'does not register an offense for namespaced SketchupExtension in root file assigned to global variable' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          $extension = SketchupExtension.new("Extension Name", filename)
          $extension.description = "Hello World"
          Sketchup.register_extension($extension, true)
        end
      RUBY
    end

    it 'does not register an offense for namespaced SketchupExtension in root file assigned to constant' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          EXTENSION = SketchupExtension.new("Extension Name", filename)
          EXTENSION.description = "Hello World"
          Sketchup.register_extension(EXTENSION, true)
        end
      RUBY
    end

    it 'does not register an offense when SketchupExtension is prefixed with ::' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          extension = ::SketchupExtension.new("Extension Name", filename)
          extension.description = "Hello World"
          Sketchup.register_extension(extension, true)
        end
      RUBY
    end

    it 'does not register an offense when Sketchup is prefixed with ::' do
      expect_no_offenses(<<~RUBY, './src/hello.rb')
        module Example
          extension = SketchupExtension.new("Extension Name", filename)
          extension.description = "Hello World"
          ::Sketchup.register_extension(extension, true)
        end
      RUBY
    end

    it 'does not throw an error when inspecting source' do
      expect_offense(<<~RUBY, './src/hello.rb')
        module Example
        ^{} SketchupExtension.new not found.
          msg = "Hello World"
          msg += "Foo Bar"
        end
      RUBY
    end

  end # context

  context 'Custom source path' do

    let(:config) do
      rubocop_config = {
        'AllCops' => {
          'SketchUp' => {
            'SourcePath' => 'source',
          },
        },
      }
      RuboCop::Config.new(rubocop_config, 'fake_cop_config.yml')
    end

    old_pwd = nil

    before do
      old_pwd = Dir.pwd
      Dir.chdir('examples/extensions/valid_custom_src_path')
    end

    after do
      Dir.chdir(old_pwd)
    end

    it 'registers an offense for missing SketchupExtension in root file' do
      expect_offense(<<~RUBY, './source/hello.rb')
        foo(123)
        ^{} SketchupExtension.new not found.
      RUBY
    end

    it 'does not register an offense for missing SketchupExtension in support file' do
      expect_no_offenses(<<~RUBY, './source/hello/world.rb')
        foo(123)
      RUBY
    end

    it 'does not register an offense for SketchupExtension in root file' do
      expect_no_offenses(<<~RUBY, './source/hello.rb')
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      RUBY
    end

    it 'does not register an offense for SketchupExtension in root file with only one argument' do
      expect_no_offenses(<<~RUBY, './source/hello.rb')
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension)
      RUBY
    end

  end

end
