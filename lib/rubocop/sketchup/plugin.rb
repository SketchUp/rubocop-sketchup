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
            description: 'Rubocop cops for SketchUp - test against our ' \
                         'Extension Warehouse technical requirements and ' \
                         'other pitfalls.'
          )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        register_obsoletions

        LintRoller::Rules.new(
            type: :path,
            config_format: :rubocop,
            value: CONFIG_DEFAULT
          )
      end

      private

      # Lets RuboCop explain why a removed cop is no longer available when a
      # user's configuration still refers to it.
      def register_obsoletions
        files = RuboCop::ConfigObsoletion.files
        path = CONFIG_OBSOLETION.to_s
        files << path unless files.include?(path)
      end
    end
  end
end
