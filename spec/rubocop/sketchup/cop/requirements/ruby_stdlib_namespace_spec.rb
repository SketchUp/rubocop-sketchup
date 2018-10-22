# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RubyStdLibNamespace do

  subject(:cop) { described_class.new }

  described_class::NAMESPACES_RUBY_STDLIB.each do |namespace|

    type, var = namespace.split(' ')

    it "registers an offense for adding an instance method to #{var} #{type}" do
      expect_offense(<<-RUBY.strip_indent)
        #{type} #{var}
          def example
              ^^^^^^^ Do not modify Ruby stdlib functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      expect_offense(<<-RUBY.strip_indent)
        #{type} #{var}
          def self.example
                   ^^^^^^^ Do not modify Ruby stdlib functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      expect_offense(<<-RUBY.strip_indent)
        #{type} #{var}
          EXAMPLE = 123
          ^^^^^^^ Do not modify Ruby stdlib functionality.
        end
      RUBY
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      expect_offense(<<-RUBY.strip_indent)
        #{type} #{var}
          module Example
                 ^^^^^^^ Do not modify Ruby stdlib functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      expect_offense(<<-RUBY.strip_indent)
        #{type} #{var}
          class Example
                ^^^^^^^ Do not modify Ruby stdlib functionality.
          end
        end
      RUBY
    end
  end

end
