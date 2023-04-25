# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::Typename, :config do

  it 'registers an offense for use of Sketchup::Entity#typename' do
    expect_offense(<<~RUBY)
      entity.typename == "Face"
             ^^^^^^^^ `.typename` is very slow, prefer `.is_a?` instead.
    RUBY
  end

end
