# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SketchupSet do

  subject(:cop) { described_class.new }

  it 'registers an offense for Sketchup::Set.new' do
    expect_offense(<<-RUBY.strip_indent)
      set = Sketchup::Set.new
            ^^^^^^^^^^^^^ Class is deprecated.
    RUBY
  end

  it 'registers an offense for Sketchup::Set shim' do
    expect_offense(<<-RUBY.strip_indent)
      Set = Sketchup::Set
            ^^^^^^^^^^^^^ Class is deprecated.
    RUBY
  end

  it 'does not register an offense for Set.new' do
    expect_no_offenses(<<-RUBY.strip_indent)
      set = Set.new
    RUBY
  end

end
