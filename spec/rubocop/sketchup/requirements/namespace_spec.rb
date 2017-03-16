# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ExtensionNamespace do

  subject(:cop) { described_class.new }

  it 'registers an offense for global methods' do
    inspect_source(cop, 'def example;end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for global constants' do
    inspect_source(cop, 'GLOBAL_EXAMPLE = 123')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for multiple top level namespaces' do
    inspect_source(cop, ['module Example',
                         'end',
                         'module FooBar',
                         'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for namespaced objects' do
    inspect_source(cop, ['module Example',
                         '  EXAMPLE = 123',
                         '  def example;end',
                         '  module SubModule',
                         '    SUB_EXAMPLE = 123',
                         '    def self.foo;end',
                         '  end',
                         'end'])
    expect(cop.offenses).to be_empty
  end
  
end
