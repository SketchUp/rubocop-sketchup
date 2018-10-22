# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::SketchupRequire do

  subject(:cop) { described_class.new }

  it 'registers an offense when using `Sketchup.require` with file extension' do
    expect_offense(<<-RUBY.strip_indent)
      Sketchup.require("filename.rb")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't hard code file extensions with Sketchup.require
    RUBY
  end

  it 'registers an offense when using `Sketchup::require` with file extension' do
    expect_offense(<<-RUBY.strip_indent)
      Sketchup::require("filename.rb")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't hard code file extensions with Sketchup.require
    RUBY
  end

  it 'does not register an offense when using `Sketchup.require` without file extension' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Sketchup.require("filename")
    RUBY
  end

  it 'does not register an offense when using `Sketchup::require` without file extension' do
    expect_no_offenses(<<-RUBY.strip_indent)
      Sketchup::require("filename")
    RUBY
  end

  it 'does not register an offense when using `Sketchup.require` with a variable' do
    # Don't flag path params which aren't string variables as it's much harder
    # to resolve the content of the variable.
    expect_no_offenses(<<-RUBY.strip_indent)
      filename = "filename.rb"
      Sketchup.require(filename)
    RUBY
  end

  it 'does not register an offense when using `require` without file extension' do
    expect_no_offenses(<<-RUBY.strip_indent)
      require("filename")
    RUBY
  end

  it 'does not register an offense when using `require` with a file extension' do
    expect_no_offenses(<<-RUBY.strip_indent)
      require("filename.rb")
    RUBY
  end


  context 'SketchupExtension.new' do

    it 'registers an offense when using `SketchupExtension.new` with file extension' do
      expect_offense(<<-RUBY.strip_indent)
        extension = SketchupExtension.new("Example", "Example/main.rb")
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't hard code file extensions with Sketchup.require
      RUBY
    end

    it 'does not register an offense when using `SketchupExtension.new` without file extension' do
      expect_no_offenses(<<-RUBY.strip_indent)
        extension = SketchupExtension.new("Example", "Example/main")
      RUBY
    end

    it 'does not register an offense when using `SketchupExtension.new` variable for load param' do
      # Don't flag path params which aren't string variables as it's much harder
      # to resolve the content of the variable.
      expect_no_offenses(<<-RUBY.strip_indent)
        loader = "Example/main.rb"
        extension = SketchupExtension.new("Example", loader)
      RUBY
    end

  end


  context 'requiring files from Tools folder' do

    described_class::TOOLS_RUBY_FILES.each { |filename|
      it "does not register an offense requiring `#{filename}`" do
        expect_no_offenses(<<-RUBY.strip_indent)
          Sketchup.require '#{filename}'
        RUBY
      end
    }

  end

end
