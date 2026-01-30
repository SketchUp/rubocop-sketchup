# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::FileStructure, :config do

  let(:config) do
    RuboCop::Config.new({}, '.rubocop.yml')
  end

  before do
    described_class.reset
  end

  context 'Valid extension' do

    it 'does not register an offense for valid extension structure' do
      Dir.chdir('examples/extensions/valid') do
        expect_no_offenses('foo(123)', 'examples/extensions/valid/src/hello.rb')
      end
    end

  end

  context 'Valid extension with mac system folder' do

    it 'does not register an offense for valid extension structure with __MACOSX folder' do
      Dir.chdir('examples/extensions/macos_folder') do
        expect_no_offenses('foo(123)', 'examples/extensions/macos_folder/src/hello.rb')
      end
    end

  end

  context 'Invalid extension' do

    it 'registers an offense for invalid extension structure' do
      Dir.chdir('examples/extensions/invalid') do
        expect_offense(<<~RUBY, 'examples/extensions/invalid/src/hello.rb')
          foo(123)
          ^{} Extensions must have a support directory matching the name of the root Ruby file. Expected hello, found hello_world
        RUBY
      end
    end

    it 'registers an offense for case mis-match' do
      Dir.chdir('examples/extensions/invalid_case_mismatch') do
        expect_offense(<<~RUBY, 'examples/extensions/valid/src/hello.rb')
          foo(123)
          ^{} Extensions must have a support directory matching the name of the root Ruby file. Expected hello, found Hello
        RUBY
      end
    end

  end
end
