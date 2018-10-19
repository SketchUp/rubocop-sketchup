# frozen_string_literal: true

module RuboCop
  module SketchUp
    module NoCommentDisable

      private

      # This forces the cop to be run even if there is a source code comment
      # that tries to disable it.
      def enabled_line?(_line_number)
        true
      end

    end
  end
end
