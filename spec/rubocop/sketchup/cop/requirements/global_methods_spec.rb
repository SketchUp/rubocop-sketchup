# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalMethods do

  subject(:cop) { described_class.new }

  it 'registers an offense for global methods' do
    expect_offense(<<~RUBY)
      def example; end
          ^^^^^^^ Do not introduce global methods.
    RUBY
  end

  it 'does not register an offense for namespaced methods' do
    expect_no_offenses(<<~RUBY)
      module Example
        def namespaced_example; end
      end
    RUBY
  end

  it 'does not register an offense for namespaced Object methods' do
    expect_no_offenses(<<~RUBY)
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
    expect_offense(<<~RUBY)
      def Object.foo; end
                 ^^^ Do not introduce global methods.
    RUBY
  end

  it 'does not register an offense for class method' do
    expect_no_offenses(<<~RUBY)
      def Example.foo; end
    RUBY
  end

  it 'does not register an offense for class method with argument' do
    expect_no_offenses(<<~RUBY)
      def Example.bar(hello); end
    RUBY
  end

  it 'does not register an offense for class method with splat arguments' do
    expect_no_offenses(<<~RUBY)
      def Example.biz(*args); end
    RUBY
  end

  it 'does not register an offense for nested class method with argument' do
    expect_no_offenses(<<~RUBY)
      def (Example::Nested).baz(hello); end
    RUBY
  end

  it 'does not register an offense for block local methods' do
    expect_no_offenses(<<~RUBY)
      module Example
        10.times do
          def hello
          end
        end
      end
    RUBY
  end

end
