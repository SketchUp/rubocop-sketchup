# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::MonkeyPatchedApi, :config do

  context 'Shipped Extensions API monkey-patching' do

    it 'registers an register an offense when using monkey-patched method' do
      expect_offense(<<~RUBY)
        tr = Geom::Transformation.scaling(5)
        x = tr.xscale
               ^^^^^^ Geom::Transformation#xscale is not part of the official API. It's a monkey-patched addition by Dynamic Components.
      RUBY
    end

    it 'does not register an offense when using official API method' do
      expect_no_offenses(<<~RUBY)
        tr = Geom::Transformation.scaling(5)
        matrix = tr.to_a
      RUBY
    end

    it 'does not register an offense when calling a module method' do
      expect_no_offenses(<<~RUBY)
        x = Example.xscale
      RUBY
    end

  end # context

  context 'Shipped Extensions API monkey-patching with variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      expect_offense(<<~RUBY)
        entities = Sketchup.active_model.entities
        instance = entities.grep(Sketchup::ComponentInstance)
        description = instance.description
                               ^^^^^^^^^^^ Sketchup::ComponentInstance#description is not part of the official API. It's a monkey-patched addition by Dynamic Components.
      RUBY
    end

    it 'does not register an offense when using official API method' do
      expect_no_offenses(<<~RUBY)
        entities = Sketchup.active_model.definitions
        definition = definitions.first
        description = definition.description
      RUBY
    end

  end # context

  context 'Shipped Extensions API monkey-patching with instance variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      expect_offense(<<~RUBY)
        entities = Sketchup.active_model.entities
        @instance = entities.grep(Sketchup::ComponentInstance)
        description = @instance.description
                                ^^^^^^^^^^^ Sketchup::ComponentInstance#description is not part of the official API. It's a monkey-patched addition by Dynamic Components.
      RUBY
    end

    it 'does not register an offense when using official API method' do
      expect_no_offenses(<<~RUBY)
        entities = Sketchup.active_model.definitions
        @definition = definitions.first
        description = @definition.description
      RUBY
    end

    it 'does not register an offense without variable context' do
      expect_no_offenses(<<~RUBY)
        class Example
          def typename; end
          def example
            foo = typename
            bar = typename()
          end
        end
      RUBY
    end

    it 'does not register an offense when calling a module method' do
      expect_no_offenses(<<~RUBY)
        description = Example.description
      RUBY
    end

  end # context

  context 'Shipped Extensions API monkey-patching with class variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      expect_offense(<<~RUBY)
        entities = Sketchup.active_model.entities
        @@instance = entities.grep(Sketchup::ComponentInstance)
        description = @@instance.description
                                 ^^^^^^^^^^^ Sketchup::ComponentInstance#description is not part of the official API. It's a monkey-patched addition by Dynamic Components.
      RUBY
    end

    it 'does not register an offense when using official API method' do
      expect_no_offenses(<<~RUBY)
        entities = Sketchup.active_model.definitions
        @@definition = definitions.first
        description = @@definition.description
      RUBY
    end

  end # context

end
