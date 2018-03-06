# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::Compatibility do

  context 'SketchUp 2016 Compatibility' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2016')
    end

    it 'registers an offense when using UI::HtmlDialog' do
      inspect_source('dialog = UI::HtmlDialog.new')
      expect(cop.offenses.size).to eq(1)
    end

  end

  context 'SketchUp 2017 Compatibility' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2017')
    end

    it 'does not register an offense when using UI::HtmlDialog' do
      inspect_source('dialog = UI::HtmlDialog.new')
      expect(cop.offenses).to be_empty
    end

  end

  context 'SketchUp 2018 Compatibility' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2017')
    end

    it 'does not register an offense when using UI::HtmlDialog' do
      inspect_source('dialog = UI::HtmlDialog.new')
      expect(cop.offenses).to be_empty
    end

  end

end
