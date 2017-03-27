# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ExtensionNamespace do

  subject(:cop) { described_class.new }

  it 'registers an offense for multiple top level namespaces' do
    inspect_source(cop, ['module Example',
                         'end',
                         'module FooBar',
                         'end'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for namespaced objects' do
    inspect_source(cop, ['module Example',
                         '  module SubModule',
                         '  end',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for Ruby namespace objects' do
    inspect_source(cop, ['module Example',
                         'end',
                         'module Math',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for Ruby StdLib namespace objects' do
    inspect_source(cop, ['module Example',
                         'end',
                         'class MD5',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for Sketchup namespace objects' do
    inspect_source(cop, ['module Example',
                         'end',
                         'module Sketchup',
                         'end'])
    expect(cop.offenses).to be_empty
  end

end
