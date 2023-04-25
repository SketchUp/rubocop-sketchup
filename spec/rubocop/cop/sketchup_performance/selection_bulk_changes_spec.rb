# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::SelectionBulkChanges, :config do

  it 'registers an offense for use of selection.add within each loop' do
    expect_offense(<<~RUBY)
      entities.each { |entity|
        selection.add(entity)
        ^^^^^^^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of selection.remove within each loop' do
    expect_offense(<<~RUBY)
      entities.each { |entity|
        selection.remove(entity)
        ^^^^^^^^^^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of selection.toggle within each loop' do
    expect_offense(<<~RUBY)
      entities.each { |entity|
        selection.toggle(entity)
        ^^^^^^^^^^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of model.selection.add within each loop' do
    expect_offense(<<~RUBY)
      entities.each { |entity|
        model.selection.add(entity)
              ^^^^^^^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of sel.add within each loop' do
    expect_offense(<<~RUBY)
      entities.each { |entity|
        sel.add(entity)
        ^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'does not registers an offense for use of Sketchup::Selection#add outside an loop' do
    expect_no_offenses(<<~RUBY)
      def foo
        model = Sketchup.active_model
        selection = model.selection
        entities = model.active_entities
        selection.add(entities)
      end
    RUBY
  end

  it 'registers an offense for use of sel.add within times loop' do
    expect_offense(<<~RUBY)
      5.times { |i|
        sel.add(entities[i])
        ^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of sel.add within upto loop' do
    expect_offense(<<~RUBY)
      5.upto(10) { |i|
        sel.add(entities[i])
        ^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

  it 'registers an offense for use of sel.add within for loop' do
    expect_offense(<<~RUBY)
      for entity in entities
        sel.add(entity)
        ^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      end
    RUBY
  end

  it 'registers an offense for use of selection.add within until loop' do
    expect_offense(<<~RUBY)
      until condition == true do
        selection.add(entity)
        ^^^^^^^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      end
    RUBY
  end

  it 'registers an offense for use of sel.add within grep loop' do
    expect_offense(<<~RUBY)
      entities.grep(Sketchup::Face) { |face|
        sel.add(face)
        ^^^^^^^ Prefer changing selection in bulk instead of modifying selection within loops.
      }
    RUBY
  end

end
