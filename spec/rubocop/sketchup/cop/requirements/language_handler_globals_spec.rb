# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::LanguageHandlerGlobals do

  subject(:cop) { described_class.new }

  described_class::LH_GLOBALS.each do |var|

    it "registers an offense when using #{var}" do
      inspect_source("#{var} = LanguageHandler.new('example.strings')")
      expect(cop.offenses.size).to eq(1)
    end

  end

  it 'does not register an offense when not using other globals' do
    inspect_source('$hello = 456')
    expect(cop.offenses).to be_empty
  end

end
