# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::DynamicCopyrightYear, :config do

  it 'registers an offense when calling extension.copyright= with Time.now' do
    expect_offense(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "\#{Time.now.year} Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Dynamically using the current year as copyright year is misleading. Prefer hardcoded actual year.
    RUBY
  end

  it 'registers an offense when calling EXTENSION.copyright= with Time.now' do
    expect_offense(<<~RUBY)
      EXTENSION = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      EXTENSION.copyright = "\#{Time.now.year} Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Dynamically using the current year as copyright year is misleading. Prefer hardcoded actual year.
    RUBY
  end

  it 'registers an offense when calling @extension.copyright= with Time.now' do
    expect_offense(<<~RUBY)
      @extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      @extension.copyright = "\#{Time.now.year} Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Dynamically using the current year as copyright year is misleading. Prefer hardcoded actual year.
    RUBY
  end

  it 'does not register an offense when calling extension.copyright= without Time.now' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "2026 Jane Doe"
    RUBY
  end

  it 'does not register an offense when calling EXTENSION.copyright= without Time.now' do
    expect_no_offenses(<<~RUBY)
      EXTENSION = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      EXTENSION.copyright = "2026 Jane Doe"
    RUBY
  end

  it 'does not register an offense when the constant is not the extension' do
    expect_no_offenses(<<~RUBY)
      EXTENSION = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      SOMETHING_ELSE.copyright = "\#{Time.now.year} Jane Doe"
    RUBY
  end

  it 'does not register an offense when the variable is not the extension' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      something_else = Object.new
      something_else.copyright = "\#{Time.now.year} Jane Doe"
    RUBY
  end

  it 'does not register an offense for a multiple assignment' do
    expect_no_offenses(<<~RUBY)
      a, b = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      a.copyright = "\#{Time.now.year} Jane Doe"
    RUBY
  end

end
