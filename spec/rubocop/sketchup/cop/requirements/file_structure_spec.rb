# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::FileStructure do

  subject(:cop) {
    described_class.reset
    described_class.new(config)
  }

  context 'Valid extension' do

    let(:config) do
      RuboCop::Config.new({}, '.rubocop.yml')
    end

    it 'does not register an offense for valid extension structure' do
      Dir.chdir('examples/extensions/valid') do
        inspect_source('foo(123)', 'src/hello.rb')
        expect(cop.offenses).to be_empty
      end
    end

  end

  context 'Valid extension with mac system folder' do

    let(:config) do
      RuboCop::Config.new({}, '.rubocop.yml')
    end

    it 'does not register an offense for valid extension structure with __MACOSX folder' do
      Dir.chdir('examples/extensions/macos_folder') do
        inspect_source('foo(123)', 'examples/extensions/macos_folder/src/hello.rb')
        expect(cop.offenses).to be_empty
      end
    end

  end

  context 'Invalid extension' do

    let(:config) do
      RuboCop::Config.new({}, '.rubocop.yml')
    end

    it 'registers an offense for invalid extension structure' do
      Dir.chdir('examples/extensions/invalid') do
        inspect_source('foo(123)', 'examples/extensions/invalid/src/hello.rb')
        expect(cop.offenses.size).to eq(1)
      end
    end

  end
end
