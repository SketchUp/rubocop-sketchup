# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # It's tempting to use gems in an extension. However, there are issues if
      # consuming them via Gem.install;
      #
      # * Net::HTTP is unreliable. (SSL certificate issues, OpenSSL performance
      #   freeze under Windows)
      # * Compiled extensions cannot be installed like this as they require
      #   DevKit.
      # * While downloading and installing SketchUp freezes. (Bad thing if done
      #   automatically upon loading the extensions - especially without user
      #   notice. It's easy to think SU have stopped working)
      # * Version collisions. If multiple extensions want to use different
      #   versions of a gem they will clash if the versions aren't compatible
      #   with the features they use.
      #
      # They only way to ensure extensions doesn't clash is to namespace
      # everything into extension namespace. This means making a copy of the
      # gem you want to use and wrap it in your own namespace.
      class GemInstall < SketchUp::Cop

        include RangeHelp
        include SketchUp::NoCommentDisable

        MSG = '`Gem.install` is unreliable in SketchUp, and can cause ' \
              'extensions to clash.'

        # Reference: http://rubocop.readthedocs.io/en/latest/development/
        def_node_matcher :gem_install?, <<-PATTERN
          (send (const nil? :Gem) :install ...)
        PATTERN

        def on_send(node)
          return unless gem_install?(node)

          range = range_with_receiver(node)
          add_offense(node, location: range)
        end
      end
    end
  end
end
