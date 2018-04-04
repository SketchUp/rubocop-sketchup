# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::AddSeparatorToMenu do

  subject(:cop) { described_class.new }

  it 'registers an offense for add_separator_to_menu ' do
    inspect_source('add_separator_to_menu("Plugins")')
    expect(cop.offenses.size).to eq(1)
  end

end
