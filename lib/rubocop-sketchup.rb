require 'rubocop'
require_relative 'rubocop/sketchup'
require_relative 'rubocop/sketchup/version'
require_relative 'rubocop/sketchup/inject'

require_relative 'rubocop/sketchup/formatter/extension_review'
require_relative 'rubocop/sketchup/config'
require_relative 'rubocop/sketchup/cop'
require_relative 'rubocop/sketchup/dc_globals'
require_relative 'rubocop/sketchup/dc_methods'
require_relative 'rubocop/sketchup/extension_project'
require_relative 'rubocop/sketchup/features'
require_relative 'rubocop/sketchup/namespace'
require_relative 'rubocop/sketchup/namespace_checker'
require_relative 'rubocop/sketchup/no_comment_disable'
require_relative 'rubocop/sketchup/range_help'
require_relative 'rubocop/sketchup/sketchup_target_range'
require_relative 'rubocop/sketchup/sketchup_version'
require_relative 'rubocop/sketchup/tool_checker'

RuboCop::SketchUp::Inject.defaults!

# Monkey patching the built in formatter list to add a short alias for custom
# formatters. Naughty! Naughty!
class RuboCop::Formatter::FormatterSet
  formatters = BUILTIN_FORMATTERS_FOR_KEYS.dup
  formatters['extension_review'] =
      RuboCop::Formatter::ExtensionReviewFormatter
  verbose = $VERBOSE
  begin
    $VERBOSE = nil
    BUILTIN_FORMATTERS_FOR_KEYS = formatters.freeze
  ensure
    $VERBOSE = verbose
  end
end

# Make it easier to explore available methods on a method.
class Object
  def methods!(queries = true)
    sorted = methods.sort - Object.class.instance_methods
    sorted.reject! { |m| m.to_s.end_with?('?') } unless queries
    sorted
  end
end

# Load all custom cops.
pattern = File.join(__dir__, 'rubocop', 'sketchup', 'cop', '**/*rb')
Dir.glob(pattern) { |file|
  require file
}
