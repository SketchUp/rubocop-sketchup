# frozen_string_literal: true

module RuboCop
  module SketchUp

    WorkaroundCop = RuboCop::Cop::Cop.dup

    # Clone of the the normal RuboCop::Cop::Cop class so we can rewrite
    # the inherited method without breaking functionality
    class WorkaroundCop
      # Remove the Cop.inherited method to be a noop. Our SketchUp::Cop
      # class will invoke the inherited hook instead
      class << self
        undef inherited
        def inherited(*) end
      end

      # Special case `Module#<` so that the rspec support rubocop exports
      # is compatible with our subclass
      def self.<(other)
        other.equal?(RuboCop::Cop::Cop) || super
      end
    end
    private_constant(:WorkaroundCop)

    # @abstract parent class to SketchUp cops
    #
    # The criteria for whether rubocop-sketchup analyzes a certain ruby file
    # is configured via `AllCops/SketchUp`. For example, if you want to
    # customize your project to scan all files within a `test/` directory
    # then you could add this to your configuration:
    #
    # @example configuring analyzed paths
    #
    #   AllCops:
    #     SketchUp:
    #       SketchupDeprecations:
    #         Exclude:
    #         - '_test.rb$'
    #         - '(?:^|/)test/'
    class Cop < WorkaroundCop

      include SketchUp::Config

      # Invoke the original inherited hook so our cops are recognized
      def self.inherited(subclass)
        RuboCop::Cop::Cop.inherited(subclass)
      end

      def relevant_file?(file)
        relevant_rubocop_sketchup_file?(file) && super
      end

      private

      def default_severity
        sketchup_severity || super
      end

      def sketchup_severity
        case self.class.department
        when :SketchupRequirements
          :error
        when :SketchupDeprecations
          :warning
        when :SketchupPerformance
          :warning
        when :SketchupSuggestions
          :convention
        end
      end

      def department_name
        self.class.department.to_s
      end

      def relevant_rubocop_sketchup_file?(file)
        department_exclude_pattern !~ file
      end

      def department_exclude_pattern
        if department_exclude_config?
          patterns = department_exclude_config.map(&Regexp.public_method(:new))
          Regexp.union(patterns)
        else
          DEFAULT_CONFIGURATION
            .fetch(department_name)
            .fetch('Exclude')
            .map(&Regexp.public_method(:new))
        end
      end

      def department_exclude_config?
        return false unless all_cops_config.key?('SketchUp')

        sketchup_config = all_cops_config.fetch('SketchUp')
        return false unless sketchup_config.key?(department_name)

        sketchup_config.fetch(department_name).key?('Exclude')
      end

      def department_exclude_config
        sketchup_cops_config
          .fetch(department_name)
          .fetch('Exclude')
      end

    end
  end
end
