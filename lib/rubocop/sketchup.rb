# frozen_string_literal: true

require 'pathname'

module RuboCop
  # RuboCop SketchUp project namespace
  module SketchUp
    PROJECT_ROOT      = Pathname.new(__dir__).parent.parent.expand_path.freeze
    CONFIG_DEFAULT    = PROJECT_ROOT.join('config', 'default.yml').freeze
    CONFIG_OBSOLETION = PROJECT_ROOT.join('config', 'obsoletion.yml').freeze
    CONFIG            = YAML.safe_load(CONFIG_DEFAULT.read).freeze

    private_constant(:CONFIG_DEFAULT, :CONFIG_OBSOLETION, :PROJECT_ROOT)
  end
end
