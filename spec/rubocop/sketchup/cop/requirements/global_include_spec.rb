# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalInclude do

  subject(:cop) { described_class.new }

  it 'registers an offense for global include' do
    inspect_source('include Math')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for Kernel include' do
    inspect_source(<<-RUBY.strip_indent)
      module Kernel
        include Math
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end


  it 'does not register an offense for module namespaced include' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        include Math
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for module namespaced include' do
    inspect_source(<<-RUBY.strip_indent)
      module Example::Kernel
        include Math
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for module namespaced include' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        module Kernel
          include Math
        end
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for class namespaced include' do
    inspect_source(<<-RUBY.strip_indent)
      class Example
        include Math
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for other method calls' do
    inspect_source('require "sketchup.rb"')
    expect(cop.offenses).to be_empty
  end

end
