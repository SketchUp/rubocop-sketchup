# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::DynamicComponentInternals do

  subject(:cop) { described_class.new }

  described_class::DC_GLOBALS.each do |var|

    it "registers an offense when using #{var}" do
      expect_offense(<<~RUBY)
        #{var}.get_latest_class.show_configure_dialog
        #{'^' * var.size} Avoid relying on internal logic of Dynamic Components.
      RUBY
    end

    it "registers an offense when reading #{var}" do
      expect_offense(<<~RUBY)
        defined?(#{var})
                 #{'^' * var.size} Avoid relying on internal logic of Dynamic Components.
      RUBY
    end

    it "registers an offense when writing #{var}" do
      expect_offense(<<~RUBY)
        #{var} = 123
        #{'^' * var.size} Avoid relying on internal logic of Dynamic Components.
      RUBY
    end

  end

  it 'does not register an offense when not using DC internals' do
    expect_no_offenses(<<~RUBY)
      $hello = 456
    RUBY
  end

end
