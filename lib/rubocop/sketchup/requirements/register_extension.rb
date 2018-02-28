# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Always register extensions to load by default. Otherwise it might
      # confuse users to think the extension isn't working.
      class RegisterExtension < Cop

        include NoCommentDisable

        MSG = 'Always register extensions to load by default.'.freeze

        def_node_search :sketchup_register_extension, <<-PATTERN
          (:send
            (const nil? :Sketchup) :register_extension
            $...)
        PATTERN

        def on_send(node)
          sketchup_register_extension(node).each { |args|
            if args.size < 2
              add_offense(node, severity: :error)
              next
            end
            load_arg = args[1]
            next if load_arg.true_type?
            add_offense(load_arg, severity: :error)
          }
        end

      end
    end
  end
end
