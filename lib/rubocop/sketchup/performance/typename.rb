# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # Weak warning. (Question?)
      class Typename < Cop
        MSG = '.typename is very slow, prefer .is_a? instead.'.freeze
        
        def on_send(node)
          _, method_name = *node
          return unless method_name == :typename
          add_offense(node, :expression)
        end
      end
    end
  end
end
