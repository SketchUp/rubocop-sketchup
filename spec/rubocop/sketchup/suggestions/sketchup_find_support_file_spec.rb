# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::SketchupFindSupportFile do

  subject(:cop) { described_class.new }

  it 'registers an offense when using Sketchup.find_support_file with a string literal' do
    inspect_source('Sketchup.find_support_file("filename.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when using Sketchup.find_support_file without a string literals' do
    inspect_source(['filename = "filename.rb"',
                    'Sketchup.find_support_file(filename)'])
                    expect(cop.offenses.size).to eq(1)
  end

end
