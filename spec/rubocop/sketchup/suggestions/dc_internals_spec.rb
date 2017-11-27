# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::DynamicComponentInternals do

  subject(:cop) { described_class.new }

  described_class::DC_GLOBALS.each do |var|

    it "registers an offense when using #{var}" do
      inspect_source("#{var}.get_latest_class.show_configure_dialog")
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense when reading #{var}" do
      inspect_source("defined?(#{var})")
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense when writing #{var}" do
      inspect_source("#{var} = 123")
      expect(cop.offenses.size).to eq(1)
    end

  end

  it 'does not register an offense when not using DC internals' do
    inspect_source('$hello = 456')
    expect(cop.offenses).to be_empty
  end

end
