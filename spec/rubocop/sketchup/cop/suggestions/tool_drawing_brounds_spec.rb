# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ToolDrawingBounds do

  subject(:cop) { described_class.new }

  context 'with a draw method' do

    it 'registers an offense when `getExtents` is missing' do
      expect_offense(<<-RUBY.strip_indent)
        class ExampleTool
        ^^^^^^^^^^^^^^^^^ When drawing to the viewport implement `getExtents` so drawn geometry is not clipped.
          def draw(view)
          end
        end
      RUBY
    end


    it 'does not register an offense when `getExtents` is implemented' do
      expect_no_offenses(<<-RUBY.strip_indent)
        class ExampleTool
          def getExtents
            view.invalidate
          end
          def draw(view)
          end
        end
      RUBY
    end

  end

  it 'does not register an offense with an empty tool' do
    expect_no_offenses(<<-RUBY.strip_indent)
      class ExampleTool
      end
    RUBY
  end

  it 'does not register an offense when class name does not ends with Tool' do
    expect_no_offenses(<<-RUBY.strip_indent)
      class Example
        def draw(view)
        end
      end
    RUBY
  end

end
