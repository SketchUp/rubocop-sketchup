# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ToolbarTimer, :config do

  it 'registers an offense when calling .restore within a timer' do
    expect_offense(<<~RUBY)
      tb = UI::Toolbar.new('Example')
      tb.restore
      UI.start_timer(0.1, false) {
        tb.restore
        ^^^^^^^^^^ Wrapping `toolbar.restore` in `UI.start_timer` is redundant.
      }
    RUBY
  end

  it 'registers an offense when within a state check' do
    expect_offense(<<~RUBY)
      tb = UI::Toolbar.new('Example')
      state = tb.get_last_state
      if (state == TB_VISIBLE)
        tb.restore
        # Per bug 2902434, adding a timer call to restore the toolbar. This
        # fixes a toolbar resizing regression on PC as the restore() call
        # does not seem to work as the script is first loading.
        UI.start_timer(0.1, false) {
          tb.restore
          ^^^^^^^^^^ Wrapping `toolbar.restore` in `UI.start_timer` is redundant.
      }
      end
    RUBY
  end

  it 'does not register an offense when not using a timer' do
    expect_no_offenses(<<~RUBY)
      tb = UI::Toolbar.new('Example')
      tb.restore
    RUBY
  end

end
