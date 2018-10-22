# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ExtensionNamespace, :config do

  subject(:cop) { described_class.new(config) }

  it 'registers an offense for multiple top level namespaces' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
      end
      module FooBar
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for namespaced objects' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        module SubModule
        end
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for Ruby namespace objects' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
      end
      module Math
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for nested namespace objects' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
      end
      module FooBar
        module BizBaz
        end
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for Ruby StdLib namespace objects' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
      end
      class MD5
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for Sketchup namespace objects' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
      end
      module Sketchup
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  context 'configured exception' do

    let(:cop_config) do
      { 'Exceptions' => %w[Foo Bar] }
    end

    it 'does not register an offense for exempted objects' do
      inspect_source(<<-RUBY.strip_indent)
        module Example
        end
        module Foo
        end
      RUBY
      expect(cop.offenses).to be_empty
    end

    it 'registers an offense for multiple top level namespaces' do
      inspect_source(<<-RUBY.strip_indent)
        module Foo
        end
        module Example
        end
        module FooBar
        end
        module Bar
        end
        module Bar::Biz::Baz
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end

  end # context

end
