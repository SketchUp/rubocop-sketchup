# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::Exit do

  subject(:cop) { described_class.new }

  it 'registers an offense for exit' do
    inspect_source('exit')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for exit!' do
    inspect_source('exit!')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for exit with argument' do
    inspect_source('exit(1)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for exit! with argument' do
    inspect_source('exit!(1)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for Kernel.exit' do
    inspect_source('Kernel.exit')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for Kernel.exit!' do
    inspect_source('Kernel.exit!')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for Kernel.exit with argument' do
    inspect_source('Kernel.exit(1)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for Kernel.exit! with argument' do
    inspect_source('Kernel.exit!(1)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for other methods' do
    inspect_source('rand(1)')
    expect(cop.offenses).to be_empty
  end

end
