# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ToolbarRestore do

  subject(:cop) { described_class.new }

  it 'registers an offense for toolbar.show' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      toolbar.show
              ^^^^ Always use `.restore` to display your toolbar.
    RUBY
  end

  it 'registers an offense for toolbar.show with unless modifier' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      toolbar.show unless toolbar.get_last_state == TB_HIDDEN
              ^^^^ Always use `.restore` to display your toolbar.
    RUBY
  end

  it 'registers an offense for toolbar.restore within if branch' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      if toolbar.get_last_state == TB_VISIBLE
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to check toolbar state with `.restore`.
        toolbar.restore
      end
    RUBY
  end

  it 'registers an offense for toolbar.restore within if branch and state variable' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      state = toolbar.get_last_state
      if state == TB_VISIBLE
      ^^^^^^^^^^^^^^^^^^^^^^ No need to check toolbar state with `.restore`.
        toolbar.restore
      end
    RUBY
  end

  it 'registers an offense for toolbar.restore within unless branch' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      state = toolbar.get_last_state
      unless state == TB_HIDDEN
      ^^^^^^^^^^^^^^^^^^^^^^^^^ No need to check toolbar state with `.restore`.
        toolbar.restore
      end
    RUBY
  end

  it 'registers an offense for toolbar.restore with unless modifier' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      toolbar.restore unless toolbar.get_last_state == TB_HIDDEN
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to check toolbar state with `.restore`.
    RUBY
  end

  it 'registers an offense for toolbar.restore with if modifier' do
    expect_offense(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      toolbar.restore if toolbar.get_last_state == TB_VISIBLE
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to check toolbar state with `.restore`.
    RUBY
  end

  it 'does not register an offense for not finding show/restore' do
    expect_no_offenses(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
    RUBY
  end

  it 'does not register an offense for using restore correctly' do
    expect_no_offenses(<<-RUBY.strip_indent)
      toolbar = UI::Toolbar.new('Example')
      toolbar.restore
    RUBY
  end

end
