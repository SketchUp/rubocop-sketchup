# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::ShowRubyPanel do

  subject(:cop) { described_class.new }

  it 'registers an offense for show_ruby_panel ' do
    inspect_source('show_ruby_panel ')
    expect(cop.offenses.size).to eq(1)
  end

end
