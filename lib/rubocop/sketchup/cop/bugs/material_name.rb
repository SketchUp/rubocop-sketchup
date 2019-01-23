# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupBugs
      # Prior to SketchUp 2018 it was possible for the Ruby API to cause
      # materials to have duplicate names. This is not a valid SketchUp model
      # as SketchUp expects material names to be unique identifiers.
      #
      # `model.materials.add('Example')` have always made materials unique by
      # appending a numeric post-fix to the name.
      #
      # However, `material.name = 'Example'` did not perform such check. It
      # would blindly set the new name.
      #
      # As of SketchUp 2018 the API behavior was changed to prevent this.
      # `material.name = 'Example'` will now raise an `ArgumentError` is the
      # name is not unique.
      #
      # A new method was added to allow a unique material name to be generated:
      # `model.material.unique_name('Example')`.
      #
      # Changing the name of materials can now follow the same pattern as layers
      # and component definitions.
      #
      # Note that in SketchUp 2018 there was also a second bug introduced. A
      # name cache was introduced to speed up the lookup and generation of
      # unique names. Unfortunately this got out of sync between changing name
      # via the UI versus via the API. This has been fixed in SketchUp 2019.
      #
      # @example Pattern for setting material name from SketchUp 2018
      #   material.name = model.materials.unique_name('Example')
      #
      # @example Pattern for setting name prior to SketchUp 2018
      #   # Works with SketchUp 2014 or newer:
      #   require 'set'
      #
      #   module Example
      #
      #     def self.rename_material(material, name)
      #       materials = material.model.materials
      #       material.name = self.unique_name(materials, name)
      #     end
      #
      #     def self.unique_material_name(materials, name)
      #       if materials.respond_to?(:unique_name)
      #         # Use fast native implementation if possible.
      #         materials.unique_name(name)
      #       else
      #         # Cache names in a Set for fast lookup.
      #         names = Set.new(materials.map(&:name))
      #         unique_name = name
      #         # Extract the base name and post-fix.
      #         match = unique_name.match(/^\D.*?(\d*)$/)
      #         base, postfix = match ? match.captures : [unique_name, 0]
      #         # Ensure basename has length and postfix is an integer.
      #         base = unique_name if base.empty?
      #         postfix = postfix.to_i
      #         # Iteratively find a unique name.
      #         until !names.include?(unique_name)
      #           postfix = postfix.next
      #           unique_name = "#{base}#{postfix}"
      #         end
      #         unique_name
      #       end
      #     end
      #
      #   end
      class MaterialName < SketchUp::Cop

        include SketchUp::SketchUpTargetRange

        define_sketchup_target_max_version 'SketchUp 2017'

        MATERIAL_VARIABLES = %i[material mat].freeze

        def_node_matcher :material_set_name?, <<-PATTERN
          (send #material? :name= _)
        PATTERN

        MSG_SET_NAME = '`material.name=` might add duplicate materials in '\
            'SU2017 and older versions.'.freeze

        def on_send(node)
          return unless valid_for_target_sketchup_version?
          return unless material_set_name?(node)

          add_offense(node, message: MSG_SET_NAME)
        end

        private

        def material?(node)
          return false unless node && (node.send_type? || node.variable?)

          name = variable_name(node.children.last)
          MATERIAL_VARIABLES.include?(name)
        end

        # Returns the name without the @ or $ prefix.
        def variable_name(symbol)
          symbol.to_s.tr('$@', '').to_sym
        end

      end
    end
  end
end
