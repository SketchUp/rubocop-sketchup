# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module SketchUp
    class Generator < RuboCop::Cop::Generator
      def source_path
        department = snake_case(badge.department.to_s).gsub(/^sketchup_/, '')
        File.join(
            'lib',
            'rubocop',
            'sketchup', # We have our cops nested one extra level.
            'cop',
            department,
            "#{snake_case(badge.cop_name.to_s)}.rb"
          )
      end
    end
  end
end
