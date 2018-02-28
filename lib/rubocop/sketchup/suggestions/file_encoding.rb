# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupSuggestions
      # When using __FILE__ and __dir__, beware that Ruby doesn't apply the
      # correct encoding to the strings under Windows. When they contain
      # non-english characters it will lead to exceptions being raised when the
      # strings are used. Force encoding to work around this.
      #
      # @example Might fail
      #   basename = File.basename(__FILE__, '.*')
      #
      # @example Workaround
      #   file = __FILE__.dup
      #   file.force_encoding('UTF-8') if file.respond_to?(:force_encoding)
      #   basename = File.basename(file, '.*')
      class FileEncoding < Cop

        MSG = 'Beware encoding bug with `__FILE__` and `__dir__`.'.freeze

        def_node_matcher :file_loaded?, <<-PATTERN
          (send nil? {:file_loaded? :file_loaded} ...)
        PATTERN

        def_node_matcher :magic_dir?, <<-PATTERN
          (send nil? :__dir__)
        PATTERN

        def magic_file?(node)
          node.respond_to?(:str_type?) &&
            node.str_type? &&
            node.source_range.is?('__FILE__')
        end

        def magic_file_or_dir?(node)
          magic_file?(node) || magic_dir?(node)
        end

        def on_send(node)
          return if file_loaded?(node)
          return if node.arguments.none?(&method(:magic_file_or_dir?))
          add_offense(node, location: :expression)
        end


        def_node_search :force_encoding, <<-PATTERN
          (send
            (_ $_)
            :force_encoding ...)
        PATTERN

        def on_assign(node)
          lhs, value = *node
          return unless magic_file_or_dir?(value)
          # After assigning __FILE__ or __dir_ to a variable, check the parent
          # scope to whether .force_encoding is called on the variable.
          return if node.parent.nil?
          encoded = force_encoding(node.parent).to_a
          return if encoded.include?(lhs)
          add_offense(node)
        end

        # TODO: Review this list of aliases.
        alias on_lvasgn   on_assign
        alias on_masgn    on_assign
        alias on_casgn    on_assign
        alias on_ivasgn   on_assign
        alias on_cvasgn   on_assign
        alias on_gvasgn   on_assign
        alias on_or_asgn  on_assign
        alias on_and_asgn on_assign
        alias on_op_asgn  on_assign

      end
    end
  end
end
