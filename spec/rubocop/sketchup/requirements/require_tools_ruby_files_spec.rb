# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RequireToolsRubyFiles do

  subject(:cop) { described_class.new }

  described_class::RUBY_FILES.each do |filename|

    it "registers an offense for Sketchup.require('#{filename}')" do
      inspect_source("Sketchup.require('#{filename}')")
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for Sketchup.require('#{filename}')" do
      inspect_source("Sketchup.require('#{filename}')")
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for require '#{File.basename(filename, '.*')}'" do
      inspect_source("require '#{File.basename(filename, '.*')}'")
      expect(cop.offenses.size).to eq(1)
    end

    it "does not register an offense for require '#{filename}'" do
      inspect_source("require '#{filename}'")
      expect(cop.offenses).to be_empty
    end

  end

  it 'does not register an offense for Sketchup.require("foobar.rb")' do
    inspect_source('Sketchup.require("foobar.rb")')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for require("foobar")' do
    inspect_source('require "foobar"')
    expect(cop.offenses).to be_empty
  end

end
