# frozen_string_literal: true

module RuboCop
  module SketchUp
    # Helpers for cops inspecting how the extension registrar file, the root
    # .rb file of the extension, sets up its `SketchupExtension` instance.
    #
    # Include this and implement `on_extension_attribute` to inspect the
    # attributes assigned to the extension object:
    #
    #   extension = SketchupExtension.new('Hello World', 'example/main')
    #   extension.copyright = '2016 Jane Doe'
    #   extension.version = '1.2.3'
    #
    # The attributes are resolved back to the object `SketchupExtension.new`
    # was assigned to, whether that is a variable or a constant.
    module ExtensionRegistrar

      extend NodePattern::Macros

      # Assignments that `SketchupExtension.new` might be assigned to. These
      # are the nodes this module hooks into.
      ASSIGNMENTS = %i[lvasgn ivasgn cvasgn gvasgn casgn or_asgn].freeze

      # Nodes that can reference the extension object by name. `const` nodes
      # carry their namespace, so their name is read differently from the
      # variable nodes.
      REFERENCES = %i[lvar ivar cvar gvar const].freeze

      # Example:
      #   SketchupExtension.new('Hello World', 'example/main')
      def_node_matcher :extension_new?, <<-PATTERN
        (send (const {nil? cbase} :SketchupExtension) :new ...)
      PATTERN

      # Captures the name the extension object is assigned to.
      #
      # Example:
      #   extension = SketchupExtension.new('Hello World', 'example/main')
      #   EXTENSION = SketchupExtension.new('Hello World', 'example/main')
      def_node_matcher :extension_assignment_name, <<-PATTERN
        {
          ({lvasgn ivasgn cvasgn gvasgn} $_ #extension_new?)

          (casgn _ $_ #extension_new?)

          (or_asgn
            {
              ({lvasgn ivasgn cvasgn gvasgn} $_)
              (casgn _ $_)
            }
            #extension_new?)
        }
      PATTERN

      # Example:
      #   extension.copyright = '2016 Jane Doe'
      def_node_search :attribute_assignment, <<-PATTERN
        (send ${#{REFERENCES.join(' ')}} $_ $_)
      PATTERN

      ASSIGNMENTS.each { |type|
        define_method("on_#{type}") do |node|
          check_extension_assignment(node)
        end
      }

      private

      # @param [Symbol] attribute for instance `:copyright`
      # @param [RuboCop::AST::Node] value_node the value assigned
      # @param [RuboCop::AST::Node] node the attribute assignment itself
      def on_extension_attribute(attribute, value_node, node)
        raise NotImplementedError, 'Implement this method'
      end

      def check_extension_assignment(node)
        extension_name = extension_assignment_name(node)
        return if extension_name.nil?

        # The attributes are assigned after the extension object is created,
        # thus they are found among the siblings of the assignment.
        scope_node = node.parent || node

        attribute_assignment(scope_node) do |receiver, method_name, value_node|
          next unless reference_name(receiver) == extension_name

          attribute = attribute_name(method_name)
          next if attribute.nil?

          on_extension_attribute(attribute, value_node, receiver.parent)
        end
      end

      # @return [Symbol, nil] `nil` unless it's an attribute assignment
      def attribute_name(method_name)
        name = method_name.to_s
        return unless name.end_with?('=')

        name.delete_suffix('=').to_sym
      end

      def reference_name(node)
        node.const_type? ? node.short_name : node.name
      end

    end
  end
end
