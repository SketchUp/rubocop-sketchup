# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::Exit, :config do

  it 'registers an offense for exit' do
    expect_offense(<<~RUBY)
      exit
      ^^^^ `exit` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for exit!' do
    expect_offense(<<~RUBY)
      exit!
      ^^^^^ `exit!` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for abort' do
    expect_offense(<<~RUBY)
      abort
      ^^^^^ `abort` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for exit with argument' do
    expect_offense(<<~RUBY)
      exit(1)
      ^^^^ `exit` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for exit! with argument' do
    expect_offense(<<~RUBY)
      exit!(1)
      ^^^^^ `exit!` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for abort with argument' do
    expect_offense(<<~RUBY)
      abort(1)
      ^^^^^ `abort` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.exit' do
    expect_offense(<<~RUBY)
      Kernel.exit
             ^^^^ `exit` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.exit!' do
    expect_offense(<<~RUBY)
      Kernel.exit!
             ^^^^^ `exit!` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.abort' do
    expect_offense(<<~RUBY)
      Kernel.abort
             ^^^^^ `abort` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.exit with argument' do
    expect_offense(<<~RUBY)
      Kernel.exit(1)
             ^^^^ `exit` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.exit! with argument' do
    expect_offense(<<~RUBY)
      Kernel.exit!(1)
             ^^^^^ `exit!` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'registers an offense for Kernel.abort with argument' do
    expect_offense(<<~RUBY)
      Kernel.abort(1)
             ^^^^^ `abort` attempts to kill the Ruby interpreter. Use `return`, `next`, `break` or `raise` instead.
    RUBY
  end

  it 'does not register an offense for other methods' do
    expect_no_offenses(<<~RUBY)
      rand(1)
    RUBY
  end

end
