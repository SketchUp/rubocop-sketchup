# frozen_string_literal: true

# This file is based of the same file in RuboCop's own repository.

require 'rubocop'

# TODO(thomthom): Move to  RuboCop::SketchUp::Cop::Generator
class SketchupCopGenerator < RuboCop::Cop::Generator

  private

  def spec_path
    File.join(
        'spec',
        'rubocop',
        'sketchup',
        'cop',
        short_department_name(badge.department.to_s),
        "#{snake_case(badge.cop_name.to_s)}_spec.rb"
    )
  end

  def source_path
    File.join(
        'lib',
        'rubocop',
        'sketchup',
        'cop',
        short_department_name(badge.department.to_s),
        "#{snake_case(badge.cop_name.to_s)}.rb"
    )
  end

  def short_department_name(cop_name)
    snake_case(cop_name).sub(/^sketchup_/, '')
  end

end

desc 'Generate a new cop template'
task :new_cop, [:cop] do |_task, args|
  cop_name = args.fetch(:cop) do
    warn 'usage: bundle exec rake new_cop[Department/Name]'
    exit!
  end

  github_user = `git config github.user`.chop
  github_user = 'your_id' if github_user.empty?

  generator = SketchupCopGenerator.new(cop_name, github_user)

  generator.write_source
  generator.write_spec
  # Not needed as all cops are detected and required dynamically.
  # generator.inject_require(root_file_path: 'lib/rubocop-sketchup.rb')
  generator.inject_config

  puts generator.todo
end
