# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::DebugMode, :config do

  it 'registers an offense when using `Sketchup#debug_mode`' do
    expect_offense(<<~RUBY)
      Sketchup.debug_mode = false
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Changing `Sketchup.debug_mode=` may hide warnings other extension developers rely on.
    RUBY
  end
end
