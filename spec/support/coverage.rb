# frozen_string_literal: true

# TODO(thomthom): Update when CI is configured.
on_default = ENV['TRAVIS_BRANCH'] == 'main' &&
             ENV['TRAVIS_PULL_REQUEST'] == 'false'
if on_default || ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.add_filter '/spec/'
  SimpleCov.add_filter '/vendor/bundle/'
  SimpleCov.command_name 'rspec'
  SimpleCov.start
end
