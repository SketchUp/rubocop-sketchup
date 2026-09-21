# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::OutdatedCopyrightYear, :config do

  it 'registers an offense when calling extension.copyright= with old year' do
    expect_offense(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "1993 Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The copyright year is outdated.
    RUBY
  end

  it 'registers an offense when calling extension.copyright= with old year span' do
    expect_offense(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "1900-1993 Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The copyright year is outdated.
    RUBY
  end

  it 'registers an offense when calling EXTENSION.copyright= with old year' do
    expect_offense(<<~RUBY)
      EXTENSION = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      EXTENSION.copyright = "1993 Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The copyright year is outdated.
    RUBY
  end

  it 'also registers an offense when the extension is created with ::SketchupExtension' do
    expect_offense(<<~RUBY)
      extension = ::SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "1993 Jane Doe"
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The copyright year is outdated.
    RUBY
  end

  it 'registers an offense when the extension is set up within a load guard' do
    expect_offense(<<~RUBY)
      module Example
        unless file_loaded?(__FILE__)
          extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
          extension.copyright = "1993 Jane Doe"
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The copyright year is outdated.
          Sketchup.register_extension(extension, true)
          file_loaded(__FILE__)
        end
      end
    RUBY
  end

  it 'does not register an offense when calling extension.copyright= with current year' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "#{Time.now.year} Jane Doe"
    RUBY
  end

  it 'does not register an offense when calling extension.copyright= with current year span' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "1993-#{Time.now.year} Jane Doe"
    RUBY
  end

  it 'does not register an offense when the copyright has no year' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      extension.copyright = "Jane Doe"
    RUBY
  end

  it 'does not register an offense when the copyright is set on another object' do
    expect_no_offenses(<<~RUBY)
      extension = SketchupExtension.new("JD Cube Maker", "jane_doe_cube_maker/main")
      something_else = Object.new
      something_else.copyright = "1993 Jane Doe"
    RUBY
  end

end
