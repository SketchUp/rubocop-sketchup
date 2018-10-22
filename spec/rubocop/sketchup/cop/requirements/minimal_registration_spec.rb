# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::MinimalRegistration do

  subject(:cop) { described_class.new(config) }

  # Based on file_name_spec.rb
  let(:config) do
    RuboCop::Config.new({}, '.rubocop.yml')
  end

  it 'registers an offense for requiring extensions files in the root file' do
    expect_offense(<<-RUBY.strip_indent, './src/hello.rb')
      module Example
        require "hello/foo"
        ^^^^^^^^^^^^^^^^^^^ Don't load extension files in the root file registering the extension.
        Sketchup.require "hello/bar"
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Don't load extension files in the root file registering the extension.
        load "hello/biz"
        ^^^^^^^^^^^^^^^^ Don't load extension files in the root file registering the extension.
        Sketchup.load "hello/baz"
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Don't load extension files in the root file registering the extension.
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
  end

  it 'does not register an offense for requiring files not in the extension' do
    expect_no_offenses(<<-RUBY.strip_indent, './src/hello.rb')
      module Example
        require "json"
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
  end

  it 'does not register an offense for requiring extensions files outside the root file' do
    expect_no_offenses(<<-RUBY.strip_indent, './src/hello/main.rb')
      module Example
        require "hello/foo"
        Sketchup.require "hello/bar"
        load "hello/biz"
        Sketchup.load "hello/baz"
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
  end

end
