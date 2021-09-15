# frozen_string_literal: true

# This file is based of the same file in RuboCop's own repository.

require 'bump'
require 'rubocop'

namespace :cut_release do
  %w[major minor patch pre].each do |release_type|
    desc "Cut a new #{release_type} release, create release notes " \
         'and update documents.'
    task release_type do
      run(release_type)
    end
  end

  def update_versions(old_version, new_version, rubocop_version)
    max_rubocop_version = rubocop_version.requirements.last.last.to_s
    rubocop_requirements = rubocop_version.requirements.map { |requirement|
      part = requirement.map(&:to_s).join(' ')
      "'#{part}'"
    }.join(', ')
    files = %w[README.md manual/installation.md manual/integration_with_other_tools.md]
    files.each do |filename|
      content = File.read(filename)
      File.open(filename, 'w') do |file|
        file << content.gsub(
            /gem install rubocop -v \d+\.\d+(?:\.\d+)?/,
            "gem install rubocop -v #{max_rubocop_version}"
          ).gsub(
            /gem 'rubocop', '.+'/,
            "gem 'rubocop', #{rubocop_requirements}"
          ).gsub(
            "gem 'rubocop-sketchup', '~> #{old_version}",
            "gem 'rubocop-sketchup', '~> #{new_version}"
          )
      end
    end
  end

  def run(release_type)
    runtime = Bundler.setup
    rubocop_sketchup = runtime.specs.find { |spec| spec.name == 'rubocop-sketchup' }
    rubocop = rubocop_sketchup.dependencies.find { |dep| dep.name == 'rubocop' }
    rubocop_version = rubocop.requirement

    old_version = Bump::Bump.current
    Bump::Bump.run(release_type, commit: false, bundle: false, tag: false)
    new_version = Bump::Bump.current

    update_versions(old_version, new_version, rubocop_version)

    puts "Changed version from #{old_version} to #{new_version}."
  end
end
