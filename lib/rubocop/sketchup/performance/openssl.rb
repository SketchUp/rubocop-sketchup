# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupPerformance
      # There are performance issue with the OpenSSL library that Ruby ship. In
      # a clean SU session, default model there is a small delay observed in the
      # Windows version of SU.
      #
      # But with a larger model loaded, or session that have had larger files
      # loaded the lag will be minutes.
      #
      # `SecureRandom` is  also affected by this, as it uses OpenSSL to seed.
      #
      # It also affects Net::HTTP if making HTTPS connections.
      class OpenSSL < Cop

        MSG = 'Avoid use of OpenSSL within SketchUp.'.freeze

        # http://www.rubydoc.info/gems/rubocop/RuboCop/NodePattern
        # https://rubocop.readthedocs.io/en/latest/node_pattern/
        def_node_matcher :require, <<-PATTERN
          (send nil? :require
            (str $_)
          )
        PATTERN

        OPEN_SSL_USAGE = %w[openssl securerandom net/https net/http]

        def on_send(node)
          filename = require(node)
          return if filename.nil?
          return unless OPEN_SSL_USAGE.include?(filename.downcase)
          add_offense(node, location: :expression)
        end
      end
    end
  end
end
