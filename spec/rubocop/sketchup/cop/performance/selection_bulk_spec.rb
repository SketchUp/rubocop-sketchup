# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::SelectionBulkChanges do

  subject(:cop) { described_class.new }

  it 'registers an offense for use of selection.add within each loop' do
    inspect_source(['entities.each { |entity|',
                    '  selection.add(entity)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.remove within each loop' do
    inspect_source(['entities.each { |entity|',
                    '  selection.remove(entity)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.toggle within each loop' do
    inspect_source(['entities.each { |entity|',
                    '  selection.toggle(entity)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of model.selection.add within each loop' do
    inspect_source(['entities.each { |entity|',
                    '  model.selection.add(entity)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within each loop' do
    inspect_source(['entities.each { |entity|',
                    '  sel.add(entity)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of Sketchup::Selection#add within each loop' do
    inspect_source(['def foo',
                    '  model = Sketchup.active_model',
                    '  selection = model.selection',
                    '  entities = model.active_entities',
                    '  selection.add(entities)',
                    'end'])
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for use of sel.add within times loop' do
    inspect_source(['5.times { |i|',
                    '  sel.add(entities[i])',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within upto loop' do
    inspect_source(['5.upto(10) { |i|',
                    '  sel.add(entities[i])',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within for loop' do
    inspect_source(['for entity in entities',
                    '  sel.add(entity)',
                    'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.add within until loop' do
    inspect_source(['until condition == true do',
                    '  selection.add(entity)',
                    'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within grep loop' do
    inspect_source(['entities.grep(Sketchup::Face) { |face|',
                    '  sel.add(face)',
                    '}'])
    expect(cop.offenses.size).to eq(1)
  end

end
