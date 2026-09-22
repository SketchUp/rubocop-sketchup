# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::UnsafeExecuteScript, :config do

  it 'registers an offense when interpolating a value as-is' do
    expect_offense(<<~RUBY)
      def show_message(message)
        dialog.execute_script("showMessage('\#{message}')")
                                              ^^^^^^^ Convert the value with `to_json` where it is interpolated.
      end
    RUBY
  end

  it 'registers an offense when the value is converted by other means' do
    expect_offense(<<~RUBY)
      dialog.execute_script("showMessage('\#{message.to_s}')")
                                            ^^^^^^^^^^^^ Convert the value with `to_json` where it is interpolated.
    RUBY
  end

  it 'registers an offense for each unsafe interpolation' do
    expect_offense(<<~RUBY)
      dialog.execute_script("showMessage('\#{title}', '\#{message}')")
                                            ^^^^^ Convert the value with `to_json` where it is interpolated.
                                                        ^^^^^^^ Convert the value with `to_json` where it is interpolated.
    RUBY
  end

  # Only the last expression of the interpolation ends up in the string.
  it 'registers an offense when the last expression is unconverted' do
    expect_offense(<<~RUBY)
      dialog.execute_script("show(\#{value.to_json; message})")
                                                   ^^^^^^^ Convert the value with `to_json` where it is interpolated.
    RUBY
  end

  # The cop deliberately does not trace where a value came from. Converting up
  # front reads as safe but cannot be verified at the call, so these are
  # offenses by design - not false positives to be fixed by adding tracing.
  it 'registers an offense even when the value was converted to JSON earlier' do
    expect_offense(<<~RUBY)
      json = message.to_json
      dialog.execute_script("showMessage(\#{json})")
                                           ^^^^ Convert the value with `to_json` where it is interpolated.
    RUBY
  end

  it 'registers an offense even when an instance variable was converted elsewhere' do
    expect_offense(<<~RUBY)
      class Example
        def prepare(message)
          @json = message.to_json
        end

        def show
          dialog.execute_script("showMessage(\#{@json})")
                                               ^^^^^ Convert the value with `to_json` where it is interpolated.
        end
      end
    RUBY
  end

  it 'does not register an offense when the value is converted to JSON' do
    expect_no_offenses(<<~RUBY)
      dialog.execute_script("showMessage(\#{message.to_json})")
    RUBY
  end

  it 'does not register an offense when the value is converted by the JSON module' do
    expect_no_offenses(<<~RUBY)
      dialog.execute_script("a(\#{JSON.generate(message)})")
      dialog.execute_script("b(\#{JSON.dump(message)})")
      dialog.execute_script("c(\#{::JSON.generate(message)})")
    RUBY
  end

  it 'does not register an offense when the last expression is converted' do
    expect_no_offenses(<<~RUBY)
      dialog.execute_script("show(\#{log(value); value.to_json})")
    RUBY
  end

  it 'does not register an offense when an instance variable is converted in the interpolation' do
    expect_no_offenses(<<~RUBY)
      class Example
        def show
          dialog.execute_script("showMessage(\#{@message.to_json})")
        end
      end
    RUBY
  end

  it 'does not register an offense when there is no interpolation' do
    expect_no_offenses(<<~RUBY)
      dialog.execute_script("showMessage('Hello World')")
    RUBY
  end

  # The cop only inspects string literals interpolated directly into the call.
  # JavaScript assembled elsewhere is a known blind spot.
  it 'does not register an offense when the script is built up beforehand' do
    expect_no_offenses(<<~RUBY)
      js = "showMessage('\#{message}');"
      dialog.execute_script(js)
    RUBY
  end

  it 'does not register an offense for other methods' do
    expect_no_offenses(<<~RUBY)
      dialog.set_html("<p>\#{message}</p>")
    RUBY
  end

end
