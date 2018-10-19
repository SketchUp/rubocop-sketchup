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
    files = %w(README.md manual/installation.md)
    files.each do |filename|
      content = File.read(filename)
      File.open(filename, 'w') do |file|
        file << content.gsub(
            /gem install rubocop -v \d+\.\d+\.\d+/,
            "gem install rubocop -v #{rubocop_version}"
        ).gsub(
            /gem 'rubocop', '~> \d+\.\d+\.\d+/,
            "gem 'rubocop', '~> #{rubocop_version}"
        ).gsub(
            "gem 'rubocop-sketchup', '~> #{old_version}",
            "gem 'rubocop-sketchup', '~> #{new_version}"
        )
      end
    end
  end

  def run(release_type)
    rubocop_version = RuboCop::Version.version

    old_version = Bump::Bump.current
    Bump::Bump.run(release_type, commit: false, bundle: false, tag: false)
    new_version = Bump::Bump.current

    update_versions(old_version, new_version, rubocop_version)

    puts "Changed version from #{old_version} to #{new_version}."
  end
end
