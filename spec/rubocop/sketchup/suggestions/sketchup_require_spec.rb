# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::SketchupRequire do

  subject(:cop) { described_class.new }

  it 'registers an offense when using `Sketchup.require` with file extension' do
    inspect_source('Sketchup.require("filename.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when using `Sketchup::require` with file extension' do
    inspect_source('Sketchup::require("filename.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when using `Sketchup.require` without file extension' do
    inspect_source('Sketchup.require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using `Sketchup::require` without file extension' do
    inspect_source('Sketchup::require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using `Sketchup.require` with a variable' do
    # Don't flag path params which aren't string variables as it's much harder
    # to resolve the content of the variable.
    inspect_source(['filename = "filename.rb"',
                    'Sketchup.require(filename)'])
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using `require` without file extension' do
    inspect_source('require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using `require` with a file extension' do
    inspect_source('require("filename.rb")')
    expect(cop.offenses).to be_empty
  end


  context 'SketchupExtension.new' do

    it 'registers an offense when using `SketchupExtension.new` with file extension' do
      inspect_source('extension = SketchupExtension.new("Example", "Example/main.rb")')
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using `SketchupExtension.new` without file extension' do
      inspect_source('extension = SketchupExtension.new("Example", "Example/main")')
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when using `SketchupExtension.new` variable for load param' do
      # Don't flag path params which aren't string variables as it's much harder
      # to resolve the content of the variable.
      inspect_source(['loader = "Example/main.rb"',
                      'extension = SketchupExtension.new("Example", loader)'])
      expect(cop.offenses).to be_empty
    end

  end

end
