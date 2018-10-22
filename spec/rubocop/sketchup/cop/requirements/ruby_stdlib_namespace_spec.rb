# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RubyStdLibNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES_RUBY_STDLIB.each do |namespace|

    type, var = namespace.split(' ')

    it "registers an offense for adding an instance method to #{var} #{type}" do
      inspect_source(<<-RUBY.strip_indent)
        #{type} #{var}
          def example
          end
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      inspect_source(<<-RUBY.strip_indent)
        #{type} #{var}
          def self.example
          end
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      inspect_source(<<-RUBY.strip_indent)
        #{type} #{var}
          EXAMPLE = 123
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      inspect_source(<<-RUBY.strip_indent)
        #{type} #{var}
          module Example
          end
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      inspect_source(<<-RUBY.strip_indent)
        #{type} #{var}
          class Example
          end
        end
      RUBY
      expect(cop.offenses.size).to eq(1)
    end
  end

end
