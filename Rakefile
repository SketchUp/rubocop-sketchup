require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--force-exclusion']
end

# TODO(thomthom): Currently running rubocop on this project will trigger
# the violations in the examples folder.
# Once test specs are added reconfigure this to run Rubocop on the gem's source
# instead.
# Look at the relaxed Rubocop styleguide for base rule-set:
# http://relaxed.ruby.style/
# task default: [:spec, :rubocop]
task default: [:spec]
