# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SketchupSet do

  subject(:cop) { described_class.new }

  it 'registers an offense for Sketchup::Set.new' do
    inspect_source('set = Sketchup::Set.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for Sketchup::Set shim' do
    inspect_source('Set = Sketchup::Set')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for Set.new' do
    inspect_source('set = Set.new')
    expect(cop.offenses).to be_empty
  end

end
