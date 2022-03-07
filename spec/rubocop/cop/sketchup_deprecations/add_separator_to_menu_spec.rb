# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::AddSeparatorToMenu do

  subject(:cop) { described_class.new }

  it 'registers an offense for add_separator_to_menus' do
    expect_offense(<<~RUBY)
      add_separator_to_menu("Plugins")
      ^^^^^^^^^^^^^^^^^^^^^ Method is deprecated.
    RUBY
  end

end
