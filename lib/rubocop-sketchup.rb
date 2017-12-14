require 'rubocop'
require 'rubocop/sketchup'
require 'rubocop/sketchup/version'
require 'rubocop/sketchup/inject'

require 'rubocop/sketchup/formatter/extension_review'
require 'rubocop/sketchup/extension_project'
require 'rubocop/sketchup/namespace'
require 'rubocop/sketchup/namespace_checker'
require 'rubocop/sketchup/no_comment_disable'

RuboCop::SketchUp::Inject.defaults!

# Load all custom cops.
pattern = File.join(__dir__, 'rubocop', 'sketchup', '**/*rb')
Dir.glob(pattern) { |file|
  require file
}
