# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ShippedExtensionsNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES.each do |var|

    # The namespace objects are either modules or classes, but we don't know
    # what. We'll try to infer this based on the current Ruby installation
    # running the tests, defaulting back to `module`.
    # Picking the correct type isn't really that important, but we'll try in
    # order to keep as close to what they represent as possible.
    type = 'module'
    if Object.constants.include?(var.intern)
      const = Object.const_get(var)
      type = const.class.name.downcase
      next unless %w[class module].include?(type)
    end

    it "registers an offense for adding an instance method to #{var} #{type}" do
      inspect_source(["#{type} #{var}",
                      '  def example',
                      '  end',
                      'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      inspect_source(["#{type} #{var}",
                      '  def self.example',
                      '  end',
                      'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      inspect_source(["#{type} #{var}",
                      '  EXAMPLE = 123',
                      'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      inspect_source(["#{type} #{var}",
                      '  module Example',
                      '  end',
                      'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      inspect_source(["#{type} #{var}",
                      '  class Example',
                      '  end',
                      'end'])
      expect(cop.offenses.size).to eq(1)
    end

    it 'does not register an offense for namespaced objects' do
      inspect_source(['module Example',
                      'end'])
      expect(cop.offenses).to be_empty
    end
  end

end
