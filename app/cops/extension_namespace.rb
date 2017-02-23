# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupExtensionNamespace

      # Get the first component of a namespace relative to Object.
      # May return 'Object' if the namespace is in the global namespace.
      def top_level_namespace(namespace)
        namespace.split('::').find { |name| name != 'Object' } || 'Object'
      end

      # Class variables are normally frowned updon since they leak through all
      # instances. However, in this case this is exactly what we want.
      # The Cop picks up the first top level namespace it encounters and then
      # keep track of whether it detects more top level namespaces.
      @@namespace = nil
      def check_top_level_namespace(node, namespace, message = nil, severity = :error)
        top = top_level_namespace(namespace)
        # TODO(thomthom): Make this smarter - do not store any top level
        # namespaces if they are part of the core Ruby API or SketchUp API.
        # puts "Setting TLN to: #{top} (#{namespace})" if  @@namespace.nil?
        @@namespace ||= top
        # puts "Namespace: #{@@namespace} vs #{top} (#{namespace})"
        return if @@namespace == top
        add_offense(node, :name, message, severity)
      end

      # Get a namespace string that is relative to Object.
      def namespace_from_root(namespace)
        parts = namespace.split('::')
        parts.shift if parts.first == 'Object' && parts.size > 1
        parts.join('::')
      end

    end
  end
end
