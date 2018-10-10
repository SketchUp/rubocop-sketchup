require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard/rake/yardoc_task'

Dir['tasks/**/*.rake'].each { |task_file| load task_file }

RSpec::Core::RakeTask.new(:spec) { |task| task.ruby_opts = '-E UTF-8' }

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

# TODO(thomthom): Look at the relaxed Rubocop styleguide for base rule-set:
# http://relaxed.ruby.style/
RuboCop::RakeTask.new(:internal_investigation)

# RuboCop::RakeTask.new(:internal_investigation) do |task|
#   task.options = ['--force-exclusion']
# end

YARD::Rake::YardocTask.new

task default: %i[
  generate_cops_documentation
  spec
  internal_investigation
]

