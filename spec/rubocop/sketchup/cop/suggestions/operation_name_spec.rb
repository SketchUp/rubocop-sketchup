# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::OperationName, :config do

  subject(:cop) { described_class.new(config) }
  let(:cop_config) { { 'Max' => 25 } }

  it 'registers an offense when operations name is too long' do
    inspect_source('model.start_operation("Some Really Long Operation Name")')
    expect(cop.offenses.size).to eq(1)
  end

  context 'Max: 32' do
    let(:cop_config) do
      { 'Max' => 32 }
    end

    it 'allows Max operation name to be adjusted' do
      inspect_source('model.start_operation("Some Really Long Operation Name")')
      expect(cop.offenses).to be_empty
    end
  end

  it 'does not register an offense when operation name is short double quoted' do
    inspect_source('model.start_operation("Short")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when operation name is short single quoted' do
    inspect_source("model.start_operation('Short')")
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense when operations name is empty' do
    inspect_source('model.start_operation("")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when operations name ends with a period' do
    inspect_source('model.start_operation("Something.")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when operation name with prepositions or conjunctions' do
    inspect_source('model.start_operation("Short and Sweet")')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense when operation name is not capitalized' do
    inspect_source('model.start_operation("doing stuff")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'expects underscore to be empty spaces' do
    inspect_source('model.start_operation("Foo_bar")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'expects period to be empty spaces' do
    inspect_source('model.start_operation("Foo.bar")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'trims white-space at start and end' do
    inspect_source('model.start_operation("  Foo Bar  ")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'collapses whitespace' do
    inspect_source('model.start_operation("Foo  Bar")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not allow tabs' do
    inspect_source('model.start_operation("Foo\tBar")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense operation when name is capitalized' do
    inspect_source('model.start_operation("Doing Stuff")')
    expect(cop.offenses).to be_empty
  end

  it 'ignores arguments which are not string literals' do
    inspect_source(<<-RUBY.strip_indent)
      operation_name = "Hello World"
      model.start_operation(operation_name)
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'only transform the first character allowing words like HTML' do
    inspect_source('model.start_operation("Doing HTML")')
    expect(cop.offenses).to be_empty
  end

  it 'only transform the first character allowing words like SketchUp' do
    inspect_source('model.start_operation("Doing SketchUp")')
    expect(cop.offenses).to be_empty
  end

  it 'handles start_operation without arguments' do
    inspect_source(<<-RUBY.strip_indent)
      CustomClass.start_operation do
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

end
