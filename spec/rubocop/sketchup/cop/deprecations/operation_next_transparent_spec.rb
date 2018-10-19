# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::OperationNextTransparent do

  subject(:cop) { described_class.new }

  it 'registers an offense for start_operation third argument' do
    inspect_source('model.start_operation("Example", true, true)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for start_operation first argument' do
    inspect_source('model.start_operation("Example")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for start_operation second argument' do
    inspect_source('model.start_operation("Example", true)')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for start_operation fourth argument' do
    inspect_source('model.start_operation("Example", true, false, true)')
    expect(cop.offenses).to be_empty
  end

end
