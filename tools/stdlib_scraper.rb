require 'nokogiri'
require 'pathname'
require 'set'

require 'rubocop'
require 'rubocop-sketchup'

RUBY_CORE_NAMESPACES = Set.new(RuboCop::Cop::SketchupRequirements::RubyCoreNamespace::NAMESPACES)

# Folder with downloaded StdLib documentation. (Extracted from Zips)
# http://ruby-doc.org/
#
# 1. ruby_1_8_6_stdlib_rdocs.tgz
# 2. ruby_2_0_0_stdlib_rdocs.tgz
# 3. ruby_2_2_6_stdlib_rdocs.tgz
# 4. Unpack each archive so you have:
#    * ruby_1_8_6_stdlib
#    * ruby_2_0_0_stdlib
#    * ruby_2_2_6_stdlib
# 5. Update the path below and run script.
# 6. Take the generated output and merge into:
#    lib/rubocop/sketchup/requirements/ruby_std_namespace.rb
source_path = 'C:/Users/tthomas2/Downloads/RubyDocs'
puts source_path

ruby_versions = Pathname.new(source_path).children.select(&:directory?)

def extract_classes(file)
  page = Nokogiri::HTML(open(file))
  items = page.css('#class-index .entries p')
  # items.map(&:text)
  items.map { |item|
    {
      type: item['class'],
      name: item.css('a').text,
    }
  }
end

ruby_versions.each { |path|
  libdoc_path = path.join('libdoc')

  top_level_namespaces = {
    :class => Set.new,
    :module => Set.new,
  }

  modules = libdoc_path.children.select(&:directory?)
  modules.each { |module_path|
    # Ignore noisy tk library
    next if module_path.basename.to_s.casecmp('tk').zero?

    pattern = module_path.join('**/rdoc/index.html')
    files = Pathname.glob(pattern)

    files.each { |index_file|
      items = extract_classes(index_file)
      # Get the top level namespace of the objects found.
      top_level_items = items.map { |item|
        name = item[:name].split('::').find { |n| n != 'Object' }.to_s
        {
          type: item[:type].split(' ').first.intern,
          name: name,
        }
      }
      # Filter out anything indicate nodoc.
      # top_level_items.reject! { |item| item[:type].include?('nodoc') }
      # Filter out anything which doesn't start with a capital letter.
      top_level_items.select! { |item| /\A[[:upper:]]/.match(item[:name]) }
      # Filter out odd objects with arrow (→) in their names.  →
      top_level_items.reject! { |item| item[:name].include?("\u2192") }
      # Filter out Ruby Core namespaces.
      top_level_items.reject! { |item|
        RUBY_CORE_NAMESPACES.include?(item[:name])
      }
      # The remaining items should be the relevant top level namespaces.
      top_level_items.each { |item|
        type = item[:type]
        top_level_namespaces[type] << item[:name]
      }
    }
  }

  # Output a Ruby array with the namespaces.
  lib_name = path.basename.to_s.upcase
  puts "NAMESPACES_#{lib_name} = ["
  top_level_namespaces.each { |type, names|
    names.each { |name|
      puts %(  "#{type} #{name}",)
    }
  }
  puts '].freeze'
  puts
}
