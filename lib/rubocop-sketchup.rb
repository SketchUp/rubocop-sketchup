require 'rubocop'
require 'rubocop/sketchup/version'

require 'rubocop/sketchup/extension_namespace'
require 'rubocop/sketchup/namespace'
require 'rubocop/sketchup/namespace_checker'
require 'rubocop/sketchup/no_comment_disable'

# Load all custom cops.
pattern = File.join(__dir__, 'rubocop', 'sketchup', '**/*rb')
Dir.glob(pattern) { |file|
  require file
}
