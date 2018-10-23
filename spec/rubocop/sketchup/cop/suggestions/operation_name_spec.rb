# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::OperationName, :config do

  subject(:cop) { described_class.new(config) }
  let(:cop_config) { { 'Max' => 25 } }

  it 'registers an offense when operations name is too long' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Some Really Long Operation Name")
                                                      ^^^^^^ Operation names should not be short and concise. [31/25]
    RUBY
  end

  context 'Max: 32' do
    let(:cop_config) do
      { 'Max' => 32 }
    end

    it 'allows Max operation name to be adjusted' do
      expect_no_offenses(<<-RUBY.strip_indent)
        model.start_operation("Some Really Long Operation Name")
      RUBY
    end
  end

  it 'does not register an offense when operation is transparent' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("_", true, false, true)
    RUBY
  end

  it 'does not register an offense when operation name is short double quoted' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("Short")
    RUBY
  end

  it 'does not register an offense when operation name is short single quoted' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation('Short')
    RUBY
  end

  it 'registers an offense when operations name is empty' do
    expect_offense(<<-RUBY.strip_indent)
        model.start_operation("")
                              ^^ Operation names should not be empty.

    RUBY
  end

  it 'registers an offense when operations name ends with a period' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Something.")
                            ^^^^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Something"`
    RUBY
  end

  it 'does not register an offense when operation name with prepositions or conjunctions' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("Short and Sweet")
    RUBY
  end

  it 'registers an offense when operation name is not capitalized' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("doing stuff")
                            ^^^^^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Doing Stuff"`
    RUBY
  end

  it 'expects underscore to be empty spaces' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Foo_bar")
                            ^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Foo Bar"`
    RUBY
  end

  it 'expects period to be empty spaces' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Foo.bar")
                            ^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Foo Bar"`
    RUBY
  end

  it 'trims white-space at start and end' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("  Foo Bar  ")
                            ^^^^^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Foo Bar"`
    RUBY
  end

  it 'collapses whitespace' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Foo  Bar")
                            ^^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Foo Bar"`
    RUBY
  end

  it 'does not allow tabs' do
    expect_offense(<<-RUBY.strip_indent)
      model.start_operation("Foo\tBar")
                            ^^^^^^^^^ Operation name should be a short capitalized description. Expected: `"Foo Bar"`
    RUBY
  end

  it 'does not register an offense operation when name is capitalized' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("Doing Stuff")
    RUBY
  end

  it 'ignores arguments which are not string literals' do
    expect_no_offenses(<<-RUBY.strip_indent)
      operation_name = "Hello World"
      model.start_operation(operation_name)
    RUBY
  end

  it 'only transform the first character allowing words like HTML' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("Doing HTML")
    RUBY
  end

  it 'only transform the first character allowing words like SketchUp' do
    expect_no_offenses(<<-RUBY.strip_indent)
      model.start_operation("Doing SketchUp")
    RUBY
  end

  it 'handles start_operation without arguments' do
    expect_no_offenses(<<-RUBY.strip_indent)
      CustomClass.start_operation do
      end
    RUBY
  end

end
