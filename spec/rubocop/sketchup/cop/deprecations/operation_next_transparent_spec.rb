# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::OperationNextTransparent do

  subject(:cop) { described_class.new }

  it 'registers an offense for start_operation third argument' do
    expect_offense(<<~RUBY)
      model.start_operation("Example", true, true)
                                             ^^^^ Third argument is deprecated.
    RUBY
  end

  it 'does not register an offense for start_operation first argument' do
    expect_no_offenses(<<~RUBY)
      model.start_operation("Example")
    RUBY
  end

  it 'does not register an offense for start_operation second argument' do
    expect_no_offenses(<<~RUBY)
      model.start_operation("Example", true)
    RUBY
  end

  it 'does not register an offense for start_operation fourth argument' do
    expect_no_offenses(<<~RUBY)
      model.start_operation("Example", true, false, true)
    RUBY
  end

end
