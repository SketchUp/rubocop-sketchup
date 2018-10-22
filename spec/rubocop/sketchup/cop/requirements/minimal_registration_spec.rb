# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::MinimalRegistration do

  subject(:cop) { described_class.new(config) }

  # Based on file_name_spec.rb
  let(:config) do
    RuboCop::Config.new({}, '.rubocop.yml')
  end

  it 'registers an offense for requiring extensions files in the root file' do
    inspect_source(<<-RUBY.strip_indent, './src/hello.rb')
      module Example
        require "hello/foo"
        Sketchup.require "hello/bar"
        load "hello/biz"
        Sketchup.load "hello/baz"
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
    expect(cop.offenses.size).to eq(4)
  end

  it 'does not register an offense for requiring files not in the extension' do
    inspect_source(<<-RUBY.strip_indent, './src/hello.rb')
      module Example
        require "json"
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for requiring extensions files outside the root file' do
    inspect_source(<<-RUBY.strip_indent, './src/hello/main.rb')
      module Example
        require "hello/foo"
        Sketchup.require "hello/bar"
        load "hello/biz"
        Sketchup.load "hello/baz"
        extension = SketchupExtension.new("Extension Name", filename)
        Sketchup.register_extension(extension, true)
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

end
