# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalVariables do

  subject(:cop) { described_class.new }

  it 'registers an offense for $custom' do
    expect_offense(<<-RUBY.strip_indent)
      puts $custom
           ^^^^^^^ Do not introduce global variables.
    RUBY
  end

  described_class::ALLOWED_VARS.each do |var|

    it "does not register an offense for reading built-in variable #{var}" do
      expect_no_offenses(<<-RUBY.strip_indent)
        puts #{var}
      RUBY
    end

    it "does not register an offense for calling built-in variable #{var}" do
      expect_no_offenses(<<-RUBY.strip_indent)
        puts #{var}.foo
      RUBY
    end

  end

  it 'does not register an offense for backrefs like $1' do
    expect_no_offenses(<<-RUBY.strip_indent)
      puts $1
    RUBY
  end

  context 'read only globals' do
    described_class::READ_ONLY_VARS.each do |var|

      it "does not register an offense for reading from #{var}" do
        expect_no_offenses(<<-RUBY.strip_indent)
          puts #{var}
        RUBY
      end

      it "does not register an offense for calling method on #{var}" do
        expect_no_offenses(<<-RUBY.strip_indent)
          puts #{var}.bar
        RUBY
      end

      it "registers an offense for assigning to #{var}" do
        expect_offense(<<-RUBY.strip_indent)
          #{var} = []
          #{'^' * var.size} Do not introduce global variables.
        RUBY
      end

    end
  end # context

end
