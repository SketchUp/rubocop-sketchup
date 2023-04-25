# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SketchupSet, :config do

  it 'registers an offense for Sketchup::Set.new' do
    expect_offense(<<~RUBY)
      set = Sketchup::Set.new
            ^^^^^^^^^^^^^ Class is deprecated.
    RUBY
  end

  it 'registers an offense for Sketchup::Set shim' do
    expect_offense(<<~RUBY)
      Set = Sketchup::Set
            ^^^^^^^^^^^^^ Class is deprecated.
    RUBY
  end

  it 'does not register an offense for Set.new' do
    expect_no_offenses(<<~RUBY)
      set = Set.new
    RUBY
  end

end
