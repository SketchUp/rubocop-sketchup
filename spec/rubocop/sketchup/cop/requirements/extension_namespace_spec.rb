# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ExtensionNamespace, :config do

  subject(:cop) { described_class.new(config) }

  it 'registers an offense for multiple top level namespaces' do
    expect_offense(<<-RUBY.strip_indent)
      module Example
      end
      module FooBar
             ^^^^^^ Use a single root namespace. (Found `FooBar`; Previously found `Example`)
      end
    RUBY
  end

  it 'does not register an offense for namespaced objects' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
        module SubModule
        end
      end
    RUBY
  end

  it 'does not register an offense for Ruby namespace objects' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
      end
      module Math
      end
    RUBY
  end

  it 'does not register an offense for nested namespace objects' do
    expect_offense(<<-RUBY.strip_indent)
      module Example
      end
      module FooBar
             ^^^^^^ Use a single root namespace. (Found `FooBar`; Previously found `Example`)
        module BizBaz
        end
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for Ruby StdLib namespace objects' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
      end
      class MD5
      end
    RUBY
  end

  it 'does not register an offense for Sketchup namespace objects' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
      end
      module Sketchup
      end
    RUBY
  end

  context 'configured exception' do

    let(:cop_config) do
      { 'Exceptions' => %w[Foo Bar] }
    end

    it 'does not register an offense for exempted objects' do
      expect_no_offenses(<<-RUBY.strip_indent)
        module Example
        end
        module Foo
        end
      RUBY
    end

    it 'registers an offense for multiple top level namespaces' do
      expect_offense(<<-RUBY.strip_indent)
        module Foo
        end
        module Example
        end
        module FooBar
               ^^^^^^ Use a single root namespace. (Found `FooBar`; Previously found `Example`)
        end
        module Bar
        end
        module Bar::Biz::Baz
        end
      RUBY
    end

  end # context

end
