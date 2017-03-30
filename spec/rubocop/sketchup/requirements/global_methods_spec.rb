# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalMethods do

  subject(:cop) { described_class.new }

  it 'registers an offense for global methods' do
    inspect_source(cop, 'def example; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for namespaced methods' do
    inspect_source(cop, ['module Example',
                         '  def namespaced_example; end',
                         'end'])
    expect(cop.offenses).to be_empty
  end

  # TODO(thomthom): Move this to RubyCoreNamespace cop since it's a class
  # method?
  it 'does not register an offense for Object methods' do
    inspect_source(cop, 'def Object.foo; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for class method' do
    inspect_source(cop, 'def Example.foo; end')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for class method with argument' do
    inspect_source(cop, 'def Example.bar(hello); end')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for class method with splat arguments' do
    inspect_source(cop, 'def Example.biz(*args); end')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for nested class method with argument' do
    inspect_source(cop, 'def (Example::Nested).baz(hello); end')
    expect(cop.offenses).to be_empty
  end

end
