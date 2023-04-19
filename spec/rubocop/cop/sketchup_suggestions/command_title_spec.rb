# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::CommandTitle do

  subject(:cop) { described_class.new }

  bad_capitalization = [
    'text',
    'text text',
    'Text text',
    'text Text',
    'Text.',
    'Text Text.',
    'Text text.',
    'text 2-Point',
    'text 2-point'
  ]

  bad_capitalization.each do |keyword|
    it "registers an offense when using UI::Command.new(\"#{keyword}\")" do
      expect_offense(<<~RUBY, keyword: keyword)
        UI::Command.new("%{keyword}")
        ^^^^^^^^^^^^^^^^^^{keyword}^^ Use title case in command titles. [...]
      RUBY
    end

    # TODO: Add for setter methods.
    # Can we test by how a local variable was defined? Or only by its name?
    #
    # command = UI::Command.new("Test")
    # command.menu_text = "%{keyword}"
    #
    # menu.add_item("%{keyword}")
  end

  good_capitalization = [
    'Text',
    'Text Text',
    'Text 2-Point',
    '文本'
  ]

  good_capitalization.each do |keyword|
    it "does not register an offense when using UI::Command.new(\"#{keyword}\")" do
      expect_no_offenses(<<~RUBY, keyword: keyword)
        UI::Command.new("%{keyword}")
      RUBY
    end
  end

  it 'does not register an offense when using UI::Command.new(variable)' do
    expect_no_offenses(<<~RUBY)
      UI::Command.new(variable)
    RUBY
  end

end
