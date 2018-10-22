# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RegisterExtension do

  subject(:cop) { described_class.new }

  it 'does not register an offense for extension set to load by default' do
    inspect_source('Sketchup.register_extension(extension, true)')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for extension set to not load by default' do
    inspect_source('Sketchup.register_extension(extension, false)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for extension implicitly set to not load by default' do
    inspect_source('Sketchup.register_extension(extension)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for extension not explicitly set to load by default' do
    inspect_source(<<-RUBY.strip_indent)
      some_var = 123
      Sketchup.register_extension(extension, some_var)
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

end
