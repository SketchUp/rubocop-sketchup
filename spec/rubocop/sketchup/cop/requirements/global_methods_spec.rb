# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalMethods do

  subject(:cop) { described_class.new }

  it 'registers an offense for global methods' do
    expect_offense(<<-RUBY.strip_indent)
      def example; end
          ^^^^^^^ Do not introduce global methods.
    RUBY
  end

  it 'does not register an offense for namespaced methods' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
        def namespaced_example; end
      end
    RUBY
  end

  it 'does not register an offense for namespaced Object methods' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
        class Object
          def namespaced_example; end
        end
      end
    RUBY
  end

  # TODO(thomthom): Move this to RubyCoreNamespace cop since it's a class
  # method?
  it 'register an offense for Object methods' do
    expect_offense(<<-RUBY.strip_indent)
      def Object.foo; end
                 ^^^ Do not introduce global methods.
    RUBY
  end

  it 'does not register an offense for class method' do
    expect_no_offenses(<<-RUBY.strip_indent)
      def Example.foo; end
    RUBY
  end

  it 'does not register an offense for class method with argument' do
    expect_no_offenses(<<-RUBY.strip_indent)
      def Example.bar(hello); end
    RUBY
  end

  it 'does not register an offense for class method with splat arguments' do
    expect_no_offenses(<<-RUBY.strip_indent)
      def Example.biz(*args); end
    RUBY
  end

  it 'does not register an offense for nested class method with argument' do
    expect_no_offenses(<<-RUBY.strip_indent)
      def (Example::Nested).baz(hello); end
    RUBY
  end

  it 'does not register an offense for block local methods' do
    expect_no_offenses(<<-RUBY.strip_indent)
      module Example
        10.times do
          def hello
          end
        end
      end
    RUBY
  end

end
