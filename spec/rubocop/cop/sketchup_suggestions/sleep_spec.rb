# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::Sleep do

  subject(:cop) { described_class.new }

  it 'registers an offense when using kernel `sleep`' do
    expect_offense(<<~RUBY)
      sleep
      ^^^^^ `sleep` freezes up SketchUp. [...]
    RUBY
  end

  it 'registers an offense when using kernel `sleep(1)`' do
    expect_offense(<<~RUBY)
      sleep(1)
      ^^^^^^^^ `sleep` freezes up SketchUp. [...]
    RUBY
  end

  it 'registers an offense when using kernel `sleep(0.5)`' do
    expect_offense(<<~RUBY)
      sleep(0.5)
      ^^^^^^^^^^ `sleep` freezes up SketchUp. [...]
    RUBY
  end

  it 'registers an offense when using kernel `Kernel.sleep(0.5)`' do
    expect_offense(<<~RUBY)
      Kernel.sleep(0.5)
      ^^^^^^^^^^^^^^^^^ `sleep` freezes up SketchUp. [...]
    RUBY
  end

  it 'does not registers an offense when using `SomeClass.sleep`' do
    expect_no_offenses(<<~RUBY)
      SomeClass.sleep
    RUBY
  end

  it 'does not registers an offense when using custom `object.sleep`' do
    expect_no_offenses(<<~RUBY)
      object.sleep
    RUBY
  end
end
