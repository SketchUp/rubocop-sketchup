# encoding: utf-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubocop/sketchup/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop-sketchup'
  spec.summary = 'RuboCop rules for SketchUp extensions.'
  spec.description = 'RuboCop rules for SketchUp extensions.'
  spec.homepage = 'http://github.com/sketchup/rubocop-sketchup'
  spec.authors = ['Trimble Inc, SketchUp Team']
  spec.licenses = ['MIT']

  spec.version = RuboCop::SketchUp::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.0.0'

  spec.require_paths = ['lib']
  spec.files = Dir[
    'config/**/*',
    'lib/**/*',
    '*.gemspec',
    'Gemfile'
  ]

  spec.add_dependency 'rubocop', '~> 0.51.0'
  spec.add_development_dependency 'bundler', '~> 1.13'
end
