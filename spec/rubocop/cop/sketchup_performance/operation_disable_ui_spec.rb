# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::OperationDisableUI do

  subject(:cop) { described_class.new }

  it 'does not register an offense when starting an operation and disabling the UI' do
    expect_no_offenses(<<~RUBY)
      model.start_operation("Hello", true)
    RUBY
  end

  it 'registers an offense when starting an operation without disabling the UI' do
    expect_offense(<<~RUBY)
      model.start_operation("Hello")
            ^^^^^^^^^^^^^^^ Operations should disable the UI for performance gain.
    RUBY
  end

  it 'registers an offense when starting an operation explicitly disabling the UI' do
    expect_offense(<<~RUBY)
      model.start_operation("Hello", false)
                                     ^^^^^ Operations should disable the UI for performance gain.
    RUBY
  end

  it 'registers an offense when starting an operation WITH VAR' do
    expect_offense(<<~RUBY)
      disable_ui = false
      model.start_operation("Hello", disable_ui)
                                     ^^^^^^^^^^ Operations should disable the UI for performance gain.
    RUBY
  end

  it 'registers an offense when starting a transparent operation without disabling the UI' do
    expect_offense(<<~RUBY)
      model.start_operation("Hello", false, false, true)
                                     ^^^^^ Operations should disable the UI for performance gain.
    RUBY
  end

end
