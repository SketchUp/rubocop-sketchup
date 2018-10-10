require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Dir['tasks/**/*.rake'].each { |t| load t }

# RSpec::Core::RakeTask.new(:spec)
RSpec::Core::RakeTask.new(:spec) { |t| t.ruby_opts = '-E UTF-8' }

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

RuboCop::RakeTask.new(:internal_investigation) do |task|
  task.options = ['--force-exclusion']
end

# desc 'Run RuboCop over itself'
# RuboCop::RakeTask.new(:internal_investigation).tap do |task|
#   if RUBY_ENGINE == 'ruby' &&
#      RbConfig::CONFIG['host_os'] !~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
#     task.options = %w[--parallel]
#   end
# end

# TODO(thomthom): Currently running rubocop on this project will trigger
# the violations in the examples folder.
# Once test specs are added reconfigure this to run Rubocop on the gem's source
# instead.
# Look at the relaxed Rubocop styleguide for base rule-set:
# http://relaxed.ruby.style/
# task default: [:spec, :rubocop]
# task default: [:spec]
task default: %i[
  documentation_syntax_check generate_cops_documentation
  spec
  internal_investigation
]

require 'yard'
YARD::Rake::YardocTask.new
