# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::OperationName do

  subject(:cop) { described_class.new }

  it 'registers an offense when operations name is too long' do
    inspect_source('model.start_operation("Some Really Long Operation Name")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when operation name is short' do
    inspect_source('model.start_operation("Short")')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense when operations name ends with a period' do
    inspect_source('model.start_operation("Something.")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when operation name is not capitalized' do
    inspect_source('model.start_operation("doing stuff")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense operation when name is capitalized' do
    inspect_source('model.start_operation("Doing Stuff")')
    expect(cop.offenses).to be_empty
  end

end
