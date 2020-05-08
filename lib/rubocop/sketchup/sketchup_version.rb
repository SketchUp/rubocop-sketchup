# frozen_string_literal: true

module RuboCop
  module SketchUp
    class SketchUpVersion

      include Comparable

      attr_reader :version, :maintenance

      class InvalidVersion < StandardError; end

      # @overload initialize(version_string)
      #   @param [String] version_string
      #
      # @overload initialize(version, maintenance)
      #   @param [Integer, Float] version
      #   @param [Integer] maintenance
      def initialize(*args)
        if args.size == 1
          @version, @maintenance = parse_version(args.first)
        elsif args.size == 2
          validate(args)
          @version, @maintenance = args
        else
          raise ArgumentError, "expected 1..2 arguments, got #{args.size}"
        end
      end

      # @return [SketchUpVersion, nil]
      def succ
        version_parts = [@version, @maintenance]
        index = VALID_VERSIONS.index(version_parts)
        next_version_parts = VALID_VERSIONS[index + 1]
        return nil if next_version_parts.nil?

        self.class.new(*next_version_parts)
      end

      def <=>(other)
        if version == other.version
          maintenance <=> other.maintenance
        else
          version <=> other.version
        end
      end

      # @return [String]
      def to_s
        string_version = version < 2013 ? version.to_f : version.to_i
        if maintenance > 0
          "SketchUp #{string_version} M#{maintenance}"
        else
          "SketchUp #{string_version}"
        end
      end

      private

      VERSION_NUMBER_REGEX = /^(?:SketchUp )?([0-9.]+)(?: M(\d+))?$/.freeze

      # This list is compiled from the list of versions reported by YARD when
      # running the `versions` template on the API stubs repository;
      #
      #   yardoc -t versions -f text
      #
      # The second item in the array is maintenance annotation
      VALID_VERSIONS = [
        [2020.1, 0],
        [2020.0, 0],
        [2019.2, 0],
        [2019.0, 0], # SketchUp dropped M notation as of SU2019.
        [2019, 0], # Documentation still refer to SU2019 instead of SU2019.0
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
      ].reverse.freeze

      # @param [String] version
      # @return [Array(Float, Integer)]
      def parse_version(version)
        v = 0
        m = 0
        if version.is_a?(String)
          # Treat all LayOut versions as SketchUp versions for now.
          normalized_version = version.gsub('LayOut', 'SketchUp')
          result = normalized_version.match(VERSION_NUMBER_REGEX)
          if result
            v = result.captures[0].to_f
            m = (result.captures[1] || '0').to_i
          end
        elsif version.is_a?(Numeric)
          v = version
          m = 0
        end
        validate([v, m])
      end

      # @param [Array(Float, Integer)] version_parts
      def validate(version_parts)
        unless VALID_VERSIONS.include?(version_parts)
          version = version_parts.join('.')
          raise InvalidVersion, "#{version} is not a valid SketchUp version"
        end

        version_parts
      end

    end
  end
end
