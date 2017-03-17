# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalConstants do

  subject(:cop) { described_class.new }

  it 'registers an offense for global constants' do
    inspect_source(cop, 'GLOBAL_EXAMPLE = 123')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for namespaced constants' do
    inspect_source(cop, ['module Example',
                         '  NAMESPACED_EXAMPLE = 123',
                         'end'])
    expect(cop.offenses).to be_empty
  end

end
