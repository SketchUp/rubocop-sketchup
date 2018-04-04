# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::OperationDisableUI do

  subject(:cop) { described_class.new }

  it 'does not register an offense when starting an operation and disabling the UI' do
    inspect_source('model.start_operation("Hello", true)')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense when starting an operation without disabling the UI' do
    inspect_source('model.start_operation("Hello")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when starting an operation explicitly disabling the UI' do
    inspect_source('model.start_operation("Hello", false)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when starting an operation WITH VAR' do
    inspect_source(['disable_ui = false',
                    'model.start_operation("Hello", disable_ui)'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when starting a transparent operation without disabling the UI' do
    inspect_source('model.start_operation("Hello", false, false, true)')
    expect(cop.offenses.size).to eq(1)
  end

end
