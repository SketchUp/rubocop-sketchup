# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module SketchUp
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
            name: 'rubocop-sketchup',
            version: VERSION,
            homepage: 'https://github.com/SketchUp/rubocop-sketchup/',
            description: 'Rubocop cops for SketchUp - test against our '\
                         'Extension Warehouse technical requirements and '\
                         'other pitfalls.'
          )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
            type: :path,
            config_format: :rubocop,
            value: CONFIG_DEFAULT
          )
      end
    end
  end
end
