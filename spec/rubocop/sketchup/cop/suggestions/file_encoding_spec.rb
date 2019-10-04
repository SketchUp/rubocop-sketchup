# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::FileEncoding, :config do

  subject(:cop) { described_class.new }

  it 'registers an offense when using __dir__ in method parameters' do
    expect_offense(<<~RUBY)
      file = File.join(__dir__, "hello.rb")
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Beware encoding bug with `__FILE__` and `__dir__`.
    RUBY
  end

  it 'registers an offense when using __FILE__ in method parameters' do
    expect_offense(<<~RUBY)
      path = File.dirname(__FILE__)
             ^^^^^^^^^^^^^^^^^^^^^^ Beware encoding bug with `__FILE__` and `__dir__`.
    RUBY
  end

  it 'does not register an offense when assigning __FILE__ to a variable' do
    expect_no_offenses(<<~RUBY)
      filename = __FILE__
    RUBY
  end

  it 'does not register an offense when using __FILE__ with file_loaded?' do
    expect_no_offenses(<<~RUBY)
      file_loaded?(__FILE__)
    RUBY
  end

  it 'does not register an offense when assigning __dir__ to a variable' do
    expect_no_offenses(<<~RUBY)
      filename = __dir__
    RUBY
  end

  it 'does not register an offense when using __FILE__ with file_loaded' do
    expect_no_offenses(<<~RUBY)
      file_loaded(__FILE__)
    RUBY
  end

  it 'does not register an offense when not using __FILE__ or __dir__' do
    expect_no_offenses(<<~RUBY)
      path = File.dirname(filename)
    RUBY
  end

  it 'does not register an offense when assigning __FILE__ to variable and forcing encoding' do
    expect_no_offenses(<<~RUBY)
      file = __FILE__
      file.force_encoding("UTF-8")
      path = File.dirname(file)
    RUBY
  end

  it 'does not register an offense when assigning __FILE__ to an instance variable and forcing encoding' do
    expect_no_offenses(<<~RUBY)
      @file = __FILE__
      @file.force_encoding("UTF-8")
      path = File.dirname(@file)
    RUBY
  end

  it 'does not register an offense when assigning __FILE__ to an class variable and forcing encoding' do
    expect_no_offenses(<<~RUBY)
      @@file = __FILE__
      @@file.force_encoding("UTF-8")
      path = File.dirname(@@file)
    RUBY
  end

  it 'register an offense when assigning __FILE__ to variable without forcing encoding' do
    expect_offense(<<~RUBY)
      file = __FILE__
      ^^^^^^^^^^^^^^^ Beware encoding bug with `__FILE__` and `__dir__`.
      path = File.dirname(file)
    RUBY
  end

  it 'register an offense when assigning __FILE__ to instance variable without forcing encoding' do
    expect_offense(<<~RUBY)
      @file = __FILE__
      ^^^^^^^^^^^^^^^^ Beware encoding bug with `__FILE__` and `__dir__`.
      path = File.dirname(@file)
    RUBY
  end

  it 'does not raise an error with module attr_accessor' do
    expect_offense(<<~RUBY)
      module Example
        class << self; attr_accessor :foo; end
        file = __FILE__
        ^^^^^^^^^^^^^^^ Beware encoding bug with `__FILE__` and `__dir__`.
      end
    RUBY
  end

end
