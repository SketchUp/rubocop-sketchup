# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GlobalConstants, :config do

  it 'registers an offense for global constants' do
    expect_offense(<<~RUBY)
      GLOBAL_EXAMPLE = 123
      ^^^^^^^^^^^^^^ Do not introduce global constants.
    RUBY
  end

  it 'does not register an offense for namespaced constants' do
    expect_no_offenses(<<~RUBY)
      module Example
        NAMESPACED_EXAMPLE = 123
      end
    RUBY
  end

  it 'does not register an offense for qualified namespaced constants' do
    expect_no_offenses(<<~RUBY)
      module Example
      end
      Example::NAMESPACED_EXAMPLE = 123
    RUBY
  end

end
