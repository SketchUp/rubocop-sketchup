# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      class LoadPath < Cop

        include NoCommentDisable

        MSG = 'Do not modify the load path.'.freeze

        def_node_matcher :load_path_mutator?, <<-PATTERN
          (send
            (gvar #load_path?) $#mutator?
            ...
          )
        PATTERN

        LOAD_PATH_ALIASES = %i(
          $: $LOAD_PATH
        )

        MUTATORS = %i(
          []=
          clear
          collect!
          compact!
          concat
          delete
          delete_at
          delete_if
          drop
          drop_while
          fill
          flatten!
          insert
          keep_if
          map!
          pop
          push
          reject!
          replace
          reverse!
          rotate!
          select!
          shift
          shuffle!
          slice!
          sort!
          sort_by!
          uniq!
          unshift
        )

        def load_path?(sym)
          LOAD_PATH_ALIASES.include?(sym)
        end

        def mutator?(sym)
          MUTATORS.include?(sym)
        end

        def on_gvasgn(node)
          global_var, = *node

          add_offense(node, :name, nil, :error) if load_path?(global_var)
        end

        def on_send(node)
          method_name = load_path_mutator?(node)
          return unless method_name

          add_offense(node, :expression, nil, :error)
        end

      end
    end
  end
end
