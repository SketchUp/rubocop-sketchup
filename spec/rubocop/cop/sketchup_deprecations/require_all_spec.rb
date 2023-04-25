# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupDeprecations::RequireAll, :config do

  it 'registers an offense for require_all' do
    expect_offense(<<~RUBY)
      require_all("foo/bar")
      ^^^^^^^^^^^ Method is deprecated because it adds the given path to $LOAD_PATH.
    RUBY
  end

end
