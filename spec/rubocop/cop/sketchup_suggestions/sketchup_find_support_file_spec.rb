# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::SketchupFindSupportFile, :config do

  it 'registers an offense when using Sketchup.find_support_file with a string literal' do
    expect_offense(<<~RUBY)
      Sketchup.find_support_file("filename.rb")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `Sketchup.find_support_file` to find your extension's files.
    RUBY
  end

  it 'registers an offense when using Sketchup.find_support_file without a string literals' do
    expect_offense(<<~RUBY)
      filename = "filename.rb"
      Sketchup.find_support_file(filename)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid `Sketchup.find_support_file` to find your extension's files.
    RUBY
  end

end
