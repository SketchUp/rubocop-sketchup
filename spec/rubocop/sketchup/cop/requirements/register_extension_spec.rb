# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RegisterExtension do

  subject(:cop) { described_class.new }

  it 'does not register an offense for extension set to load by default' do
    expect_no_offenses(<<~RUBY)
      Sketchup.register_extension(extension, true)
    RUBY
  end

  it 'registers an offense for extension set to not load by default' do
    expect_offense(<<~RUBY)
      Sketchup.register_extension(extension, false)
                                             ^^^^^ Always register extensions to load by default.
    RUBY
  end

  it 'registers an offense for extension implicitly set to not load by default' do
    expect_offense(<<~RUBY)
      Sketchup.register_extension(extension)
               ^^^^^^^^^^^^^^^^^^ Always register extensions to load by default.
    RUBY
  end

  it 'registers an offense for extension not explicitly set to load by default' do
    expect_offense(<<~RUBY)
      some_var = 123
      Sketchup.register_extension(extension, some_var)
                                             ^^^^^^^^ Always register extensions to load by default.
    RUBY
  end

end
