# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RubyCoreNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES.each do |var|

    # Skip `Object` as this is the global namespace and we have separate cops
    # for that. Doing this distinction allows us to make exceptions on a more
    # granular level.
    next if var == 'Object'

    # The namespace objects are either modules or classes, but we don't know
    # what. We'll try to infer this based on the current Ruby installation
    # running the tests, defaulting back to `module`.
    # Picking the correct type isn't really that important, but we'll try in
    # order to keep as close to what they represent as possible.
    type = 'module'
    if Object.constants.include?(var.intern)
      const = Object.const_get(var)
      type = const.class.name.downcase
      next unless %w(class module).include?(type)
    end

    it "registers an offense for adding an instance method to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  def example',
                          '  end',
                          'end'])
      # This trigger two offences because it triggers on defining a module/class
      # that is part of the core as well as the method.
      expect(cop.offenses.size).to eq(2)
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  def self.example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(2)
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  EXAMPLE = 123',
                          'end'])
      expect(cop.offenses.size).to eq(2)
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  module Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(2)
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      inspect_source(cop, ["#{type} #{var}",
                          '  class Example',
                          '  end',
                          'end'])
      expect(cop.offenses.size).to eq(2)
    end
  end

end
