# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::FileEncoding, :config do

  subject(:cop) { described_class.new }

  it 'registers an offense when operations name is too long' do
    inspect_source('file = File.join(__dir__, "hello.rb")')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense when operations name is too long' do
    inspect_source('path = File.dirname(__FILE__)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense when assigning __FILE__ to a variable' do
    inspect_source('filename = __FILE__')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using __FILE__ with file_loaded?' do
    inspect_source('file_loaded?(__FILE__)')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when assigning __dir__ to a variable' do
    inspect_source('filename = __dir__')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when using __FILE__ with file_loaded' do
    inspect_source('file_loaded(__FILE__)')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when not using __FILE__ or __dir__' do
    inspect_source('path = File.dirname(filename)')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense when assigning __FILE__ to variable and forcing encoding' do
    inspect_source(['file = __FILE__',
                    'file.force_encoding("UTF-8")'])
    expect(cop.offenses).to be_empty
  end

  it 'register an offense when assigning __FILE__ to variable without forcing encoding' do
    inspect_source(['file = __FILE__',
                    'path = File.dirname(file)'])
    expect(cop.offenses.size).to eq(1)
  end

  it 'register an offense when assigning __FILE__ to instance variable without forcing encoding' do
    inspect_source(['@file = __FILE__',
                    'path = File.dirname(@file)'])
    expect(cop.offenses.size).to eq(1)
  end

end
