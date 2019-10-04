# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupBugs::UniformScaling do

  context 'affected SketchUp versions' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2016')
    end

    it 'registers an offense for uniform scaling with float literal' do
      expect_offense(<<~RUBY)
        tr = Geom::Transformation.scaling(2.0)
                                          ^^^ Resulting transformation matrix might yield unexpected results.
      RUBY
    end

    it 'registers an offense for uniform scaling with integer literal' do
      expect_offense(<<~RUBY)
        tr = Geom::Transformation.scaling(25)
                                          ^^ Resulting transformation matrix might yield unexpected results.
      RUBY
    end

    it 'registers an offense for uniform scaling with local variable' do
      expect_offense(<<~RUBY)
        scale = 2.0
        tr = Geom::Transformation.scaling(scale)
                                          ^^^^^ Resulting transformation matrix might yield unexpected results.
      RUBY
    end

    it 'registers an offense for uniform scaling with instance variable' do
      expect_offense(<<~RUBY)
        @scale = 2.0
        tr = Geom::Transformation.scaling(@scale)
                                          ^^^^^^ Resulting transformation matrix might yield unexpected results.
      RUBY
    end

  end # context


  context 'unaffected SketchUp versions' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2018')
    end

    it 'does not register an offense for uniform scaling with float literal' do
      expect_no_offenses(<<~RUBY)
        tr = Geom::Transformation.scaling(2.0)
      RUBY
    end

    it 'does not register an offense for uniform scaling with integer literal' do
      expect_no_offenses(<<~RUBY)
        tr = Geom::Transformation.scaling(25)
      RUBY
    end

    it 'does not register an offense for uniform scaling with local variable' do
      expect_no_offenses(<<~RUBY)
        scale = 2.0
        tr = Geom::Transformation.scaling(scale)
      RUBY
    end

    it 'does not register an offense for uniform scaling with instance variable' do
      expect_no_offenses(<<~RUBY)
        @scale = 2.0
        tr = Geom::Transformation.scaling(@scale)
      RUBY
    end

  end

end
