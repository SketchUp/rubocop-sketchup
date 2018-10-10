# frozen_string_literal: true

# This file is based of the same file in RuboCop's own repository.

require 'rubocop'

desc 'Generate a new cop template'
task :new_cop, [:cop] do |_task, args|
  raise 'TODO!'

  cop_name = args.fetch(:cop) do
    warn 'usage: bundle exec rake new_cop[Department/Name]'
    exit!
  end

  generator = RuboCop::Cop::Generator.new(cop_name)

  generator.write_source
  generator.write_spec
  generator.inject_require
  generator.inject_config

  puts generator.todo
end
