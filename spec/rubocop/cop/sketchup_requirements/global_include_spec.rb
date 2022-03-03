# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalInclude do

  subject(:cop) { described_class.new }

  it 'registers an offense for global include' do
    expect_offense(<<~RUBY)
      include Math
      ^^^^^^^ Do not include into global namespace.
    RUBY
  end

  it 'does not register an offense for Kernel include' do
    expect_offense(<<~RUBY)
      module Kernel
        include Math
        ^^^^^^^ Do not include into global namespace.
      end
    RUBY
  end


  it 'does not register an offense for module namespaced include' do
    expect_no_offenses(<<~RUBY)
      module Example
        include Math
      end
    RUBY
  end

  it 'does not register an offense for module namespaced include' do
    expect_no_offenses(<<~RUBY)
      module Example::Kernel
        include Math
      end
    RUBY
  end

  it 'does not register an offense for module namespaced include' do
    expect_no_offenses(<<~RUBY)
      module Example
        module Kernel
          include Math
        end
      end
    RUBY
  end

  it 'does not register an offense for class namespaced include' do
    expect_no_offenses(<<~RUBY)
      class Example
        include Math
      end
    RUBY
  end

  it 'does not register an offense for other method calls' do
    expect_no_offenses(<<~RUBY)
      require "sketchup.rb"
    RUBY
  end

end
