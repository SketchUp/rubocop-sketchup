# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::Compatibility do

  context 'incompatible features' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 6')
    end

    it 'registers an offense when using incompatible class' do
      inspect_source('dialog = UI::HtmlDialog.new')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense when using incompatible module' do
      inspect_source('image = Sketchup::ImageRep.new')
      expect(cop.offenses.size).to eq(1)
    end

    it 'registers an offense when using incompatible module method' do
      inspect_source('scale = UI.scale_factor')
      expect(cop.offenses.size).to eq(1)
    end

  end


  context 'compatible features' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2018')
    end

    it 'does not register an offense when using compatible class' do
      inspect_source('dialog = UI::HtmlDialog.new')
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when using compatible module' do
      inspect_source('image = Sketchup::ImageRep.new')
      expect(cop.offenses).to be_empty
    end

    it 'does not register an offense when using compatible module method' do
      inspect_source('UI.scale_factor')
      expect(cop.offenses).to be_empty
    end

  end

end
