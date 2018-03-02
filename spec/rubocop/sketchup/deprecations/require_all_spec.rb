# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::RequireAll do

  subject(:cop) { described_class.new }

  it 'registers an offense for require_all ' do
    inspect_source('require_all("foo/bar")')
    expect(cop.offenses.size).to eq(1)
  end

end
