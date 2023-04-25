# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::SetTextureProjection, :config do

  it 'registers an offense for calling set_texture_projection' do
    expect_offense(<<~RUBY)
      face.set_texture_projection(Z_AXIS, true)
           ^^^^^^^^^^^^^^^^^^^^^^ Method is deprecated. It can create invalid UV mapping.
    RUBY
  end

  it 'registers an offense for assigning set_texture_projection' do
    expect_offense(<<~RUBY)
      result = face.set_texture_projection(Z_AXIS, true)
                    ^^^^^^^^^^^^^^^^^^^^^^ Method is deprecated. It can create invalid UV mapping.
    RUBY
  end

end
