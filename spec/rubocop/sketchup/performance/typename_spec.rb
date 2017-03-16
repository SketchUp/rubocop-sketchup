# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::Typename do

  subject(:cop) { described_class.new }

  it 'registers an offense for use of Sketchup::Entity#typename' do
    inspect_source(cop, 'entity.typename == "Face"')
    expect(cop.offenses.size).to eq(1)
  end

end
