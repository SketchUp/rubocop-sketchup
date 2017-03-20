# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ApiNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES.each do |var|

    it "registers an offense for adding an instance method to #{var} module" do
      inspect_source(cop, ["module #{var}",
                          '  def example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module method to #{var} module" do
      inspect_source(cop, ["module #{var}",
                          '  def self.example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a constant to #{var} module" do
      inspect_source(cop, ["module #{var}",
                          '  EXAMPLE = 123',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module to #{var} module" do
      inspect_source(cop, ["module #{var}",
                          '  module Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a class to #{var} module" do
      inspect_source(cop, ["module #{var}",
                          '  class Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end
  end

end
