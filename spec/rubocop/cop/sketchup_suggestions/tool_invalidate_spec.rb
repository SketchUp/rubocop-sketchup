# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::ToolInvalidate, :config do

  context 'with a draw method' do

    it 'registers an offense when `deactivate` is missing' do
      expect_offense(<<~RUBY)
        class ExampleTool
        ^^^^^^^^^^^^^^^^^ When drawing to the viewport, make sure to `suspend` and `deactivate` calls `view.invalidate`.
          def suspend(view)
            view.invalidate
          end
          def draw(view)
          end
        end
      RUBY
    end

    it 'registers an offense when `deactivate` is missing `view.invalidate`' do
      expect_offense(<<~RUBY)
        class ExampleTool
          def deactivate(view)
          ^^^^^^^^^^^^^^^^^^^^ When drawing to the viewport, make sure to call `view.invalidate` when the tool becomes inactive.
          end
          def suspend(view)
            view.invalidate
          end
          def draw(view)
          end
        end
      RUBY
    end

    it 'registers an offense when `suspend` is missing' do
      expect_offense(<<~RUBY)
        class ExampleTool
        ^^^^^^^^^^^^^^^^^ When drawing to the viewport, make sure to `suspend` and `deactivate` calls `view.invalidate`.
          def deactivate(view)
            view.invalidate
          end
          def draw(view)
          end
        end
      RUBY
    end

    it 'registers an offense when `suspend` is missing `view.invalidate`' do
      expect_offense(<<~RUBY)
        class ExampleTool
          def deactivate(view)
            view.invalidate
          end
          def suspend(view)
          ^^^^^^^^^^^^^^^^^ When drawing to the viewport, make sure to call `view.invalidate` when the tool becomes inactive.
          end
          def draw(view)
          end
        end
      RUBY
    end

    it 'does not register an offense when `deactivate` and `suspend` is calling `view.invalidate`' do
      expect_no_offenses(<<~RUBY)
        class ExampleTool
          def deactivate(view)
            view.invalidate
          end
          def suspend(view)
            view.invalidate
          end
          def draw(view)
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
