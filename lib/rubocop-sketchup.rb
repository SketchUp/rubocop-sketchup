require 'rubocop'
require 'rubocop/sketchup'
require 'rubocop/sketchup/version'
require 'rubocop/sketchup/inject'

require 'rubocop/sketchup/formatter/extension_review'
require 'rubocop/sketchup/config'
require 'rubocop/sketchup/dc_globals'
require 'rubocop/sketchup/dc_methods'
require 'rubocop/sketchup/extension_project'
require 'rubocop/sketchup/features'
require 'rubocop/sketchup/namespace'
require 'rubocop/sketchup/namespace_checker'
require 'rubocop/sketchup/no_comment_disable'
require 'rubocop/sketchup/sketchup_version'

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

# Load all custom cops.
pattern = File.join(__dir__, 'rubocop', 'sketchup', '**/*rb')
Dir.glob(pattern) { |file|
  require file
}
