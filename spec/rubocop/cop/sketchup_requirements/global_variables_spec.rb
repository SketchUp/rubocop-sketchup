# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalVariables, :config do

  it 'registers an offense for assigning to $custom' do
    expect_offense(<<~RUBY)
      $custom = 123
      ^^^^^^^ Do not introduce global variables.
    RUBY
  end

  it 'registers an offense for operator-assigning to $custom' do
    expect_offense(<<~RUBY)
      $custom ||= 123
      ^^^^^^^ Do not introduce global variables.
    RUBY
  end

  it 'does not register an offense for reading $custom' do
    expect_no_offenses(<<~RUBY)
      puts $custom
    RUBY
  end

  it 'does not register an offense for calling method on $custom' do
    expect_no_offenses(<<~RUBY)
      puts $custom.foo
    RUBY
  end

  described_class::ALLOWED_VARS.each do |var|

    it "does not register an offense for reading built-in variable #{var}" do
      expect_no_offenses(<<~RUBY)
        puts #{var}
      RUBY
    end

    it "does not register an offense for calling built-in variable #{var}" do
      expect_no_offenses(<<~RUBY)
        puts #{var}.foo
      RUBY
    end

  end

  it 'does not register an offense for assigning built-in variable $stdout' do
    expect_no_offenses(<<~RUBY)
      $stdout = StringIO.new
    RUBY
  end

  it 'does not register an offense for backrefs like $1' do
    expect_no_offenses(<<~RUBY)
      puts $1
    RUBY
  end

  context 'Dynamic Components globals' do
    RuboCop::SketchUp::DynamicComponentGlobals::DC_GLOBALS.each do |var|

      it "does not register an offense for reading from #{var}" do
        expect_no_offenses(<<~RUBY)
          puts #{var}
        RUBY
      end

      it "registers an offense for assigning to #{var}" do
        expect_offense(<<~RUBY)
          #{var} = []
          #{'^' * var.size} Do not introduce global variables.
        RUBY
      end

    end
  end # context

end
