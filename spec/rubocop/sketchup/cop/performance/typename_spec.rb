# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::Typename do

  subject(:cop) { described_class.new }

  it 'registers an offense for use of Sketchup::Entity#typename' do
    expect_offense(<<-RUBY.strip_indent)
      entity.typename == "Face"
             ^^^^^^^^ `.typename` is very slow, prefer `.is_a?` instead.
    RUBY
  end

end
