# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::InitializeEntity do

  subject(:cop) { described_class.new }

  RuboCop::Cop::SketchupRequirements::InitializeEntity::ENTITY_CLASSES.each do |keyword|
    it "registers an offense when using `Sketchup::#{keyword}.new`" do
      expect_offense(<<~RUBY, keyword: keyword)
        Sketchup::%{keyword}.new
        ^^^^^^^^^^^{keyword}^^^^ Entity objects (Face, Edge, Group etc) are managed SketchUp. Instead of using the `new` constructor, use the `Sketchup::Entities#add_*` methods.
      RUBY
    end

    it "registers an offense when using `Sketchup::#{keyword}.new(0)`" do
      expect_offense(<<~RUBY, keyword: keyword)
        Sketchup::%{keyword}.new(0)
        ^^^^^^^^^^^{keyword}^^^^^^^ Entity objects (Face, Edge, Group etc) are managed SketchUp. Instead of using the `new` constructor, use the `Sketchup::Entities#add_*` methods.
      RUBY
    end
  end
end
