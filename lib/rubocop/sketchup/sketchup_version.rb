# frozen_string_literal: true

module RuboCop
  module SketchUp
    class SketchUpVersion

      include Comparable

      attr_reader :version, :maintenance

      class InvalidVersion < StandardError; end

      def initialize(version)
        @version, @maintenance = parse_version(version)
      end

      def <=>(other)
        if version == other.version
          maintenance <=> other.maintenance
        else
          version <=> other.version
        end
      end

      def to_s
        string_version = version < 2013 ? version.to_f : version.to_i
        if maintenance > 0
          "SketchUp #{string_version} M#{maintenance}"
        else
          "SketchUp #{string_version}"
        end
      end

      private

      VERSION_NUMBER_REGEX = /^(?:SketchUp )?([0-9.]+)(?: M(\d+))?$/

      # This list is compiled from the list of versions reported by YARD when
      # running the `versions` template;
      #
      #   yardoc -t versions -f text
      #
      # TODO(thomthom): Push the version template to the API stubs repository.
      VALID_VERSIONS = [
        [2018, 0],
        [2017, 0],
        [2016, 1],
        [2016, 0],
        [2015, 0],
        [2014, 0],
        [2013, 0],
        [8.0, 2],
        [8.0, 1],
        [8.0, 0],
        [7.1, 1],
        [7.1, 0],
        [7.0, 1],
        [7.0, 0],
        [6.0, 0],
      ].freeze

      def parse_version(version)
        v = 0
        m = 0
        if version.is_a?(String)
          # Treat all LayOut versions as SketchUp versions for now.
          normalised_version = version.gsub('LayOut', 'SketchUp')
          result = normalised_version.match(VERSION_NUMBER_REGEX)
          if result
            v = result.captures[0].to_f
            m = (result.captures[1] || '0').to_i
          end
        elsif version.is_a?(Numeric)
          v = version
          m = 0
        end
        version_parts = [v, m]
        unless VALID_VERSIONS.include?(version_parts)
          raise InvalidVersion, "#{version} is not a valid SketchUp version"
        end

        version_parts
      end

    end
  end
end
