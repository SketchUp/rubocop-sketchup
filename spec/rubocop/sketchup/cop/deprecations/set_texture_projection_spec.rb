# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SetTextureProjection do

  subject(:cop) { described_class.new }

  it 'registers an offense for calling set_texture_projection' do
    inspect_source('face.set_texture_projection(Z_AXIS, true)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for assigning set_texture_projection' do
    inspect_source('result = face.set_texture_projection(Z_AXIS, true)')
    expect(cop.offenses.size).to eq(1)
  end

end
