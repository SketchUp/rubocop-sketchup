# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

unless ENV['CI']
  # This doesn't need to load in CI builds.
  require 'yard/rake/yardoc_task'
  Dir['tasks/**/*.rake'].each { |task_file| load task_file }
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.ruby_opts = '-E UTF-8'
end

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

YARD::Rake::YardocTask.new unless ENV['CI']

task default: %i[
  generate_cops_documentation
  spec
  internal_investigation
]

desc 'Run CI tasks'
task ci: %i[
  spec
  internal_investigation
]

desc 'Generate a new cop with a template'
task :new_cop, [:cop] do |_task, args|
  require 'rubocop'

  cop_name = args.fetch(:cop) do
    warn 'usage: bundle exec rake new_cop[Department/Name]'
    exit!
  end

  github_user = `git config github.user`.chop
  github_user = 'your_id' if github_user.empty?

  generator = RuboCop::Cop::Generator.new(cop_name, github_user)

  generator.write_source
  generator.write_spec
  # generator.inject_require(root_file_path: 'lib/rubocop/cop/foobar_cops.rb')
  generator.inject_config(config_file_path: 'config/default.yml')

  puts generator.todo
end
