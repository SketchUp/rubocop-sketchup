# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::TypeCheck do

  subject(:cop) { described_class.new }

  it 'registers an offense for type checking by string comparison using ==' do
    expect_offense(<<~RUBY)
      entity.class.name == "Sketchup::Group"
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ String comparisons are very slow, prefer `.is_a?` instead.
    RUBY
  end

  it 'registers an offense for type checking by string comparison using !=' do
    expect_offense(<<~RUBY)
      entity.class.name != "Sketchup::Group"
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ String comparisons are very slow, prefer `.is_a?` instead.
    RUBY
  end

  it 'does not registers an offense for comparing manipulated class name' do
    expect_no_offenses(<<~RUBY)
      entity.class.name.split('::').last != "Group"
    RUBY
  end

  it 'does not registers an offense for using the class name' do
    expect_no_offenses(<<~RUBY)
      name = "Selected: \#{entity.class.name}"
    RUBY
  end

  it 'does not registers an offense for reading the class name' do
    expect_no_offenses(<<~RUBY)
      name = entity.class.name
    RUBY
  end

end
