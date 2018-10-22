# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::SelectionBulkChanges do

  subject(:cop) { described_class.new }

  it 'registers an offense for use of selection.add within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.each { |entity|
        selection.add(entity)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.remove within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.each { |entity|
        selection.remove(entity)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.toggle within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.each { |entity|
        selection.toggle(entity)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of model.selection.add within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.each { |entity|
        model.selection.add(entity)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.each { |entity|
        sel.add(entity)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of Sketchup::Selection#add within each loop' do
    inspect_source(<<-RUBY.strip_indent)
      def foo
        model = Sketchup.active_model
        selection = model.selection
        entities = model.active_entities
        selection.add(entities)
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for use of sel.add within times loop' do
    inspect_source(<<-RUBY.strip_indent)
      5.times { |i|
        sel.add(entities[i])
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within upto loop' do
    inspect_source(<<-RUBY.strip_indent)
      5.upto(10) { |i|
        sel.add(entities[i])
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within for loop' do
    inspect_source(<<-RUBY.strip_indent)
      for entity in entities
        sel.add(entity)
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of selection.add within until loop' do
    inspect_source(<<-RUBY.strip_indent)
      until condition == true do
        selection.add(entity)
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of sel.add within grep loop' do
    inspect_source(<<-RUBY.strip_indent)
      entities.grep(Sketchup::Face) { |face|
        sel.add(face)
      }
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

end
