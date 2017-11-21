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

end
