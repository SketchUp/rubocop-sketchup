# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ModelEntities do

  subject(:cop) { described_class.new }

  it 'registers an offense when fetching model.entities' do
    inspect_source(['model = Sketchup.active_model',
                    'entities = model.entities'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when fetching model.active_entities' do
    inspect_source(['model = Sketchup.active_model',
                    'entities = model.active_entities'])
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense when fetching model.entities from a method' do
    inspect_source(['def get_entities(model)',
                    '  model.entities',
                    'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when fetching mod.entities' do
    inspect_source(['mod = Sketchup.active_model',
                    'entities = mod.entities'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when fetching Sketchup.active_model.entities from a method' do
    inspect_source(['def get_entities',
                    '  entities = Sketchup.active_model.entities',
                    'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not registers an offense when fetching Sketchup.active_model.active_entities from a method' do
    inspect_source(['def get_entities',
                    '  entities = Sketchup.active_model.active_entities',
                    'end'])
    expect(cop.offenses).to be_empty
  end

  # TODO(thomthom): This fails for some reason. Still don't understand why.
  # it 'registers an offense when fetching Sketchup.active_model.entities' do
  #   inspect_source(['entities = Sketchup.active_model.entities'])
  #   expect(cop.offenses.size).to eq(1)
  # end

end
