# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::ShowRubyPanel do

  subject(:cop) { described_class.new }

  it 'registers an offense for show_ruby_panel' do
    expect_offense(<<~RUBY)
      show_ruby_panel
      ^^^^^^^^^^^^^^^ Method is deprecated. Use `SKETCHUP_CONSOLE.show` instead.
    RUBY
  end

end
