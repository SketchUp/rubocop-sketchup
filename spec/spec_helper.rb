# frozen_string_literal: true

# Coverage support needs to be required *before* the RuboCop code is required!
# require 'support/coverage'

require 'rubocop'
require 'rubocop/rspec/support'

project_path = File.join(File.dirname(__FILE__), '..')
Dir["#{project_path}/spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect # Disable `should`
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect # Disable `should_receive` and `stub`
  end

  config.include Helpers::Config
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubocop-sketchup'
