# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ModelEntities do

  subject(:cop) { described_class.new }

  it 'registers an offense when fetching model.entities' do
    expect_offense(<<-RUBY.strip_indent)
      model = Sketchup.active_model
      entities = model.entities
                 ^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
    RUBY
  end

  it 'registers an offense when fetching @model.entities' do
    expect_offense(<<-RUBY.strip_indent)
      @model = Sketchup.active_model
      entities = @model.entities
                 ^^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
    RUBY
  end

  it 'registers an offense when fetching @@model.entities' do
    expect_offense(<<-RUBY.strip_indent)
      @@model = Sketchup.active_model
      entities = @@model.entities
                 ^^^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
    RUBY
  end

  it 'does not register an offense when fetching model.active_entities' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model = Sketchup.active_model
      entities = model.active_entities
    RUBY
  end

  it 'registers an offense when fetching model.entities from a method' do
    expect_offense(<<-RUBY.strip_indent)
      def get_entities(model)
        model.entities
        ^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
      end
    RUBY
  end

  it 'registers an offense when fetching mod.entities' do
    expect_offense(<<-RUBY.strip_indent)
      mod = Sketchup.active_model
      entities = mod.entities
                 ^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
    RUBY
  end

  it 'registers an offense when fetching Sketchup.active_model.entities from a method' do
    expect_offense(<<-RUBY.strip_indent)
      def get_entities
        entities = Sketchup.active_model.entities
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
      end
    RUBY
  end

  it 'does not registers an offense when fetching Sketchup.active_model.active_entities from a method' do
    expect_no_offenses(<<-RUBY.strip_indent)
      def get_entities
        entities = Sketchup.active_model.active_entities
      end
    RUBY
  end

  # TODO(thomthom): This fails for some reason. Still don't understand why.
  it 'registers an offense when fetching Sketchup.active_model.entities' do
    expect_offense(<<-RUBY.strip_indent)
      entities = Sketchup.active_model.entities
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer `model.active_entities` over `model.entities`.
    RUBY
  end

end
