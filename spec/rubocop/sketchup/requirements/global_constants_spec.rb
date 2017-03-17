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
                         '  def example; end',
                         'end'])
    expect(cop.offenses).to be_empty
  end

end
