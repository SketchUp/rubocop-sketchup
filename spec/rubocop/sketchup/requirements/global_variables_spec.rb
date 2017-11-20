# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalVariables do

  subject(:cop) { described_class.new }

  it 'registers an offense for $custom' do
    inspect_source('puts $custom')
    expect(cop.offenses.size).to eq(1)
  end

  described_class::BUILT_IN_VARS.each do |var|
    it "does not register an offense for built-in variable #{var}" do
      inspect_source("puts #{var}")
      expect(cop.offenses).to be_empty
    end
  end

  it 'does not register an offense for backrefs like $1' do
    inspect_source('puts $1')
    expect(cop.offenses).to be_empty
  end

end
