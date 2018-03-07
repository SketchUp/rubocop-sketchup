# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::MonkeyPatchedApi do

  subject(:cop) { described_class.new }


  context 'Shipped Extensions API monkey-patching' do

    it 'registers an register an offense when using monkey-patched method' do
      inspect_source(['tr = Geom::Transformation.scaling(5)',
                      'x = tr.xscale'])
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using official API method' do
      inspect_source(['tr = Geom::Transformation.scaling(5)',
                      'matrix = tr.to_a'])
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when calling a module method' do
      inspect_source('x = Example.xscale')
      expect(cop.offenses).to be_empty
    end

  end # context


  context 'Shipped Extensions API monkey-patching with variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      inspect_source(['entities = Sketchup.active_model.entities',
                      'instance = entities.grep(Sketchup::ComponentInstance)',
                      'description = instance.description'])
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using official API method' do
      inspect_source(['entities = Sketchup.active_model.definitions',
                      'definition = definitions.first',
                      'description = definition.description'])
      expect(cop.offenses).to be_empty
    end

  end # context


  context 'Shipped Extensions API monkey-patching with instance variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      inspect_source(['entities = Sketchup.active_model.entities',
                      '@instance = entities.grep(Sketchup::ComponentInstance)',
                      'description = @instance.description'])
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using official API method' do
      inspect_source(['entities = Sketchup.active_model.definitions',
                      '@definition = definitions.first',
                      'description = @definition.description'])
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when calling a module method' do
      inspect_source('description = Example.description')
      expect(cop.offenses).to be_empty
    end

  end # context


  context 'Shipped Extensions API monkey-patching with class variable name context' do

    it 'registers an register an offense when using monkey-patched method' do
      inspect_source(['entities = Sketchup.active_model.entities',
                      '@@instance = entities.grep(Sketchup::ComponentInstance)',
                      'description = @@instance.description'])
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense when using official API method' do
      inspect_source(['entities = Sketchup.active_model.definitions',
                      '@@definition = definitions.first',
                      'description = @@definition.description'])
      expect(cop.offenses).to be_empty
    end

  end # context

end
