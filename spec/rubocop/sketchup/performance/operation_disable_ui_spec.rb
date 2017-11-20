# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::OperationDisableUI do

  subject(:cop) { described_class.new }

  it 'registers an offense when starting an operation without disabling the UI' do
    inspect_source('model.start_operation("Hello")')
    expect(cop.offenses.size).to eq(1)
  end

end
