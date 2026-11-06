# frozen_string_literal: true

# Triage new API methods for INSTANCE_METHODS / OBSERVER_METHODS candidacy.
#
# Usage (from the rubocop-sketchup repo root, after FEATURES has been updated):
#
#   ruby .claude/skills/update-sketchup-features/scripts/triage_methods.rb \
#     'SketchUp 2027.0' 'LayOut 2027.0' [--stubs PATH]
#
# PATH defaults to the installed sketchup-api-stubs gem's stubs directory.
# Pass the stubs dir of a ruby-api-stubs checkout for the most current API.

require 'set'
require_relative '../../../../lib/rubocop/sketchup/features'
require_relative '../../../../lib/rubocop/sketchup/sketchup_version'

Features = RuboCop::SketchUp::Features

args = ARGV.dup
stubs_dir = nil
if (i = args.index('--stubs'))
  stubs_dir = args.delete_at(i + 1)
  args.delete_at(i)
end
versions = args
abort 'Pass one or more FEATURES version labels, e.g. "SketchUp 2027.0"' if versions.empty?

unless stubs_dir
  spec = Gem::Specification.find_by_name('sketchup-api-stubs')
  stubs_dir = File.join(spec.gem_dir, 'lib', 'sketchup-api-stubs', 'stubs')
end
abort "Stubs directory not found: #{stubs_dir}" unless File.directory?(stubs_dir)

evaluated = Features::FEATURES.select { |set| versions.include?(set[:version]) }
missing = versions - evaluated.map { |set| set[:version] }
abort "Not found in FEATURES: #{missing.join(', ')}" unless missing.empty?

missing_stubs = evaluated.flat_map { |set| set[:types][:class] || [] }
  .reject { |klass| File.exist?(File.join(stubs_dir, "#{klass.gsub('::', '/')}.rb")) }
unless missing_stubs.empty?
  warn "WARNING: #{stubs_dir} has no stubs for #{missing_stubs.join(', ')}. " \
       'The stubs look older than this release; pass --stubs with a matching ruby-api-stubs checkout.'
end

# Comparable [version, maintenance] for any version tag, independent of
# VALID_VERSIONS so unreleased stub tags still sort as newer.
# 'SketchUp 2016 M1' => [2016.0, 1], 'LayOut 2025.0.2' => [2025.0, 2]
def version_key(string)
  match = string.match(/(\d+(?:\.\d+)?)(?:\.(\d+)|\s+M(\d+))?\s*\z/)
  return nil unless match

  [match[1].to_f, (match[2] || match[3] || '0').to_i]
end

evaluated.each { |set|
  next if RuboCop::SketchUp::SketchUpVersion::VALID_VERSIONS.include?(version_key(set[:version]))

  abort "#{set[:version]} is not in VALID_VERSIONS (sketchup_version.rb). Add it first."
}

# name => { owner => introduction version } for every known instance method.
# A nil version means an untagged stub, and is treated as older than anything.
definitions = Hash.new { |h, k| h[k] = {} }
Features::FEATURES.each { |set|
  version = version_key(set[:version])
  (set[:types][:method] || []).each { |full|
    next unless full.include?('#')

    owner, name = full.split('#', 2)
    definitions[name][owner] = version
  }
}

# The stubs add the pre-7.0 API, which FEATURES doesn't cover.
Dir.glob(File.join(stubs_dir, '**', '*.rb')).each { |file|
  owner = file.delete_prefix("#{stubs_dir}/").delete_suffix('.rb').gsub('/', '::')
  version = nil
  File.foreach(file) { |line|
    if (match = line.match(/^\s*# @version (.+)$/))
      version = match[1].strip
    elsif (match = line.match(/^\s*def (?!self\.)([^\s(]+)/))
      definitions[match[1]][owner] = version && version_key(version) unless definitions[match[1]].key?(owner)
      version = nil
    end
  }
}

new_methods = evaluated.flat_map { |set|
  version = version_key(set[:version])
  (set[:types][:method] || []).map { |full| [full, version] }
}

# Owners that had the name before each new method's own version, including
# other versions in this batch.
older_by_name = Hash.new { |h, k| h[k] = Set.new }
new_methods.each { |full, version|
  next unless full.include?('#')

  owner, name = full.split('#', 2)
  definitions[name].each { |other, other_version|
    next if other == owner

    older_by_name[name] << other if other_version.nil? || (other_version <=> version) == -1
  }
}
new_methods = new_methods.map(&:first)

# Every top-level core/stdlib class and module loaded at this point, minus
# the tooling namespaces this script itself pulls in.
RUBY_CORE = Object.constants
  .reject { |const| %i[RuboCop Gem Bundler Features].include?(const) }
  .filter_map { |const| Object.const_get(const) rescue nil }
  .grep(Module)
  .uniq
  .freeze

def ruby_core_owner(name)
  sym = name.to_sym
  RUBY_CORE.find { |mod|
    mod.method_defined?(sym) || mod.private_method_defined?(sym)
  }
end

instance_methods = Features::INSTANCE_METHODS.to_set
observer_methods = Features::OBSERVER_METHODS.to_set

rows = new_methods.select { |m| m.include?('#') }
  .group_by { |m| m.split('#', 2).last }
  .map { |name, fulls|
    owners = fulls.map { |f| f.split('#', 2).first }
    observer = owners.any? { |o| o.end_with?('Observer') }
    core = ruby_core_owner(name)
    older = older_by_name[name]
    base = name.delete_suffix('?').delete_suffix('=')

    verdict, reason =
      if observer
        if observer_methods.include?(name.to_sym)
          ['present', 'already in OBSERVER_METHODS']
        else
          ['observer', 'add to OBSERVER_METHODS']
        end
      elsif instance_methods.include?(name.to_sym)
        if core || older.any?
          ['REMOVE', "already in INSTANCE_METHODS but collides: #{[core, *older.first(3)].compact.join(', ')}"]
        else
          ['present', 'already in INSTANCE_METHODS']
        end
      elsif name == 'initialize' || name.match?(/\A[^a-z_]/)
        ['exclude', 'constructor/operator']
      elsif core
        ['exclude', "Ruby core method (#{core})"]
      elsif older.any?
        ['exclude', "exists on older API: #{older.first(3).join(', ')}#{older.size > 3 ? ', ...' : ''}"]
      elsif !base.include?('_')
        ['review', 'single word; judge how common it is in general Ruby code']
      else
        ['candidate', 'unique to this version']
      end

    [verdict, name, owners.join(', '), reason]
  }

order = %w[REMOVE observer candidate review exclude present]
rows.sort_by! { |verdict, name| [order.index(verdict), name] }

rows.each { |verdict, name, owners, reason|
  puts format('%-9s %-40s %s', verdict, name, reason)
  puts format('%-9s %-40s   on: %s', '', '', owners)
}
