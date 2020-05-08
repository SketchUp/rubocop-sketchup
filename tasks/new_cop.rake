# frozen_string_literal: true

# This file is based of the same file in RuboCop's own repository.

require 'rubocop'

# TODO(thomthom): Move to  RuboCop::SketchUp::Cop::Generator
class SketchupCopGenerator < RuboCop::Cop::Generator

  def inject_config(config_file_path: 'config/default.yml')
    config = File.readlines(config_file_path)
    content = <<-YAML.strip_indent
      #{badge}:
        Description: 'TODO: Write a description of the cop.'
        Enabled: true

    YAML
    target_line = config.find.with_index(1) do |line, index|
      next if /^[\s#]/.match?(line)
      break index - 1 if badge.to_s < line
    end
    config.insert(target_line, content)
    File.write(config_file_path, config.join)
    output.puts <<-MESSAGE.strip_indent
      [modify] A configuration for the cop is added into #{config_file_path}.
               If you want to disable the cop by default, set `Enabled` option to false.
    MESSAGE
  end

  def todo
    <<-TODO.strip_indent
      Do 3 steps:
        1. Modify the description of #{badge} in config/default.yml
        2. Implement your new cop in the generated file
        3. Make sure your new cop have tests!
    TODO
  end

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

  # TODO(thomthom): Ensure requirement cops include
  #   include SketchUp::NoCommentDisable
  generator = SketchupCopGenerator.new(cop_name, github_user)

  generator.write_source
  generator.write_spec
  # Not needed as all cops are detected and required dynamically.
  # generator.inject_require(root_file_path: 'lib/rubocop-sketchup.rb')
  generator.inject_config

  puts generator.todo
end
