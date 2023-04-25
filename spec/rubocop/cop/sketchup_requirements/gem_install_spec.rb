# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GemInstall, :config do

  it 'registers an offense for Gem.install' do
    expect_offense(<<~RUBY)
      Gem.install('rest-client')
      ^^^^^^^^^^^ `Gem.install` is unreliable in SketchUp, and can cause extensions to clash.
    RUBY
  end

  it 'does not register an offense for other methods' do
    expect_no_offenses(<<~RUBY)
      rand(1)
    RUBY
  end

end
