# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::RubyCoreNamespace do

  self::NAMESPACE_TYPES = %w[class module].freeze
  self::MUTATORS = %w[include extend].freeze

  subject(:cop) { described_class.new }

  # described_class::NAMESPACES.each do |var|
  %w[Array Math].each do |var|

    # The namespace objects are either modules or classes, but we don't know
    # what. We'll try to infer this based on the current Ruby installation
    # running the tests, defaulting back to `module`.
    # Picking the correct type isn't really that important, but we'll try in
    # order to keep as close to what they represent as possible.
    type = 'module'
    if Object.constants.include?(var.intern)
      const = Object.const_get(var)
      type = const.class.name.downcase
      next unless self::NAMESPACE_TYPES.include?(type)
    end

    it "registers an offense for adding an instance method to #{var} #{type}" do
      expect_offense(<<~RUBY)
        #{type} #{var}
          def example
              ^^^^^^^ Do not modify Ruby core functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a module method to #{var} #{type}" do
      expect_offense(<<~RUBY)
        #{type} #{var}
          def self.example
                   ^^^^^^^ Do not modify Ruby core functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a constant to #{var} #{type}" do
      expect_offense(<<~RUBY)
        #{type} #{var}
          EXAMPLE = 123
          ^^^^^^^ Do not modify Ruby core functionality.
        end
      RUBY
    end

    it "registers an offense for adding a module to #{var} #{type}" do
      expect_offense(<<~RUBY)
        #{type} #{var}
          module Example
                 ^^^^^^^ Do not modify Ruby core functionality.
          end
        end
      RUBY
    end

    it "registers an offense for adding a class to #{var} #{type}" do
      expect_offense(<<~RUBY)
        #{type} #{var}
          class Example
                ^^^^^^^ Do not modify Ruby core functionality.
          end
        end
      RUBY
    end

    it 'does not register an offense for namespaced objects' do
      expect_no_offenses(<<~RUBY)
        module Example
        end
      RUBY
    end

    self::MUTATORS.each do |method|

      it "registers an offense for using #{method} on the #{var} #{type}" do
        expect_offense(<<~RUBY, method: method)
          module Example; end
          #{type} #{var}
            %{method} Example
            ^{method} Do not modify Ruby core functionality.
          end
        RUBY
      end

      it "does not register an offense using #{method} in namespaced scope" do
        expect_no_offenses(<<~RUBY)
          module World; end
          module Example
            #{method} World
          end
        RUBY
      end

      it "registers an offense using #{method} on the #{var} #{type} via klass.#{method}" do
        expect_offense(<<~RUBY, var: var, method: method)
          module Example; end
          %{var}.%{method} Example
          _{var} ^{method} Do not modify Ruby core functionality.
        RUBY
      end

      it "does not register an offense for using #{method} on namespaced objects" do
        expect_no_offenses(<<~RUBY)
          module Example; end
          module World; end
          Example.#{method}(World)
        RUBY
      end
    end
  end

  self::MUTATORS.each do |method|

    it "registers an offense for using #{method} in global scope" do
      expect_offense(<<~RUBY, method: method)
        module Example; end
        %{method} Example
        ^{method} Do not modify Ruby core functionality.
      RUBY
    end

    it 'does not register an offense for calling another method in global scope' do
      expect_no_offenses(<<~RUBY)
        system('notepad')
      RUBY
    end

    it 'does not register an offense for calling another method in a module scope' do
      expect_no_offenses(<<~RUBY)
        def Example
          system('notepad')
        end
      RUBY
    end
  end

end
