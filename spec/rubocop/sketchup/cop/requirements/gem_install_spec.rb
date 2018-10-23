# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GemInstall do

  subject(:cop) { described_class.new }

  it 'registers an offense for Gem.install' do
    expect_offense(<<-RUBY.strip_indent)
      Gem.install('rest-client')
      ^^^^^^^^^^^ `Gem.install` is unreliable in SketchUp, and can cause extensions to clash.
    RUBY
  end

  it 'does not register an offense for other methods' do
    expect_no_offenses(<<-RUBY.strip_indent)
      rand(1)
    RUBY
  end

end
