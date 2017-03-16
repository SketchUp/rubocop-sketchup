# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ModelEntities do

  subject(:cop) { described_class.new }

  it 'registers an offense when fetching model.entities' do
    inspect_source(cop, 'entities = model.entities')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when fetching mod.entities' do
    inspect_source(cop, 'entities = mod.entities')
    expect(cop.offenses.size).to eq(1)
  end

end
