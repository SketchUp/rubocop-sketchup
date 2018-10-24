# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::AddGroup do

  subject(:cop) { described_class.new }

  it 'registers an offense when creating groups out of existing entities' do
    expect_offense(<<-RUBY.strip_indent)
      entities.add_group(entities_array, face, edge)
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid creating groups out of existing entities.
    RUBY
  end

  it 'does not register an offense when creating empty groups' do
    expect_no_offenses(<<-RUBY.strip_indent)
      entities.add_group
    RUBY
  end

end
