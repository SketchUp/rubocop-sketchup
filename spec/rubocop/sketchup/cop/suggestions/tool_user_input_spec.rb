# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ToolUserInput do

  subject(:cop) { described_class.new }

  context 'with a onUserText method' do

    it 'registers an offense when `enableVCB?` is missing' do
      expect_offense(<<~RUBY)
        class ExampleTool
        ^^^^^^^^^^^^^^^^^ When accepting user input, make sure to define `enableVCB?`.
          def onUserText(text, view)
          end
        end
      RUBY
    end

    it 'does not register an offense when `enableVCB?` is defined' do
      expect_no_offenses(<<~RUBY)
        class ExampleTool
          def enableVCB?
            true
          end
          def onUserText(text, view)
          end
        end
      RUBY
    end

  end

  it 'does not register an offense with an empty tool' do
    expect_no_offenses(<<~RUBY)
      class ExampleTool
      end
    RUBY
  end

  it 'does not register an offense when class name does not ends with Tool' do
    expect_no_offenses(<<~RUBY)
      class Example
        def draw(view)
        end
      end
    RUBY
  end

end
