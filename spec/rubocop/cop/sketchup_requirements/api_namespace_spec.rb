# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ApiNamespace, :config do

  described_class::NAMESPACES.each do |var|

    it "registers an offense for adding an instance method to #{var} module" do
      expect_offense(<<~RUBY)
        module #{var}
          def example
              ^^^^^^^ Do not modify the SketchUp API.
          end
        end
      RUBY
    end

    it "registers an offense for adding a module method to #{var} module" do
      expect_offense(<<~RUBY)
        module #{var}
          def self.example
                   ^^^^^^^ Do not modify the SketchUp API.
          end
        end
      RUBY
    end

    it "registers an offense for adding a constant to #{var} module" do
      expect_offense(<<~RUBY)
        module #{var}
          EXAMPLE = 123
          ^^^^^^^ Do not modify the SketchUp API.
        end
      RUBY
    end

    it "registers an offense for adding a module to #{var} module" do
      expect_offense(<<~RUBY)
        module #{var}
          module Example
                 ^^^^^^^ Do not modify the SketchUp API.
          end
        end
      RUBY
    end

    it "registers an offense for adding a class to #{var} module" do
      expect_offense(<<~RUBY)
        module #{var}
          class Example
                ^^^^^^^ Do not modify the SketchUp API.
          end
        end
      RUBY
    end

    it 'does not register an offense for block local methods' do
      expect_no_offenses(<<~RUBY)
        module Example
          10.times do
            def hello
            end
          end
        end
      RUBY
    end
  end

end
