# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SetTextureProjection do

  subject(:cop) { described_class.new }

  it 'registers an offense for calling set_texture_projection' do
    expect_offense(<<-RUBY.strip_indent)
      face.set_texture_projection(Z_AXIS, true)
           ^^^^^^^^^^^^^^^^^^^^^^ Method is deprecated. It can create invalid UV mapping.
    RUBY
  end

  it 'registers an offense for assigning set_texture_projection' do
    expect_offense(<<-RUBY.strip_indent)
      result = face.set_texture_projection(Z_AXIS, true)
                    ^^^^^^^^^^^^^^^^^^^^^^ Method is deprecated. It can create invalid UV mapping.
    RUBY
  end

end
