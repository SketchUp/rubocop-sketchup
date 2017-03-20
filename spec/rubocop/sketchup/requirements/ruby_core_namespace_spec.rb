# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RubyCoreNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES.each do |var|

    next unless Object.constants.include?(var.intern)
    const = Object.const_get(var)
    type = const.class.name.downcase
    next unless %w(class module).include?(type)

    it "registers an offense for adding an instance method to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  def example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  def self.example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  EXAMPLE = 123',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  module Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  class Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(1)
    end
  end

end
