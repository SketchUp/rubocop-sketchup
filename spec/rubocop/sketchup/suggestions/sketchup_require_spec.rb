# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::SketchupRequire do

  subject(:cop) { described_class.new }

  it 'registers an offense when using Sketchup.require with file extension' do
    inspect_source('Sketchup.require("filename.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when using Sketchup::require with file extension' do
    inspect_source('Sketchup::require("filename.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when using Sketchup.require without file extension' do
    inspect_source('Sketchup.require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using Sketchup::require without file extension' do
    inspect_source('Sketchup::require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using require without file extension' do
    inspect_source('require("filename")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using require with and file extension' do
    inspect_source('require("filename.rb")')
    expect(cop.offenses).to be_empty
  end

end
