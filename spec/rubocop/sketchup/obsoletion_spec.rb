# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::SketchUp::Plugin do

  let(:project_path) { File.expand_path('../../..', __dir__) }
  let(:obsoletion_path) { File.join(project_path, 'config', 'obsoletion.yml') }
  # `YAML.safe_load_file` isn't available in the older Rubies we support.
  let(:removed_cops) { load_yaml(obsoletion_path).fetch('removed') }
  let(:default_config) do
    load_yaml(File.join(project_path, 'config', 'default.yml'))
  end

  def load_yaml(path)
    YAML.safe_load(File.read(path))
  end

  describe 'config/obsoletion.yml' do

    it 'gives a reason for every removed cop' do
      removed_cops.each do |cop_name, rule|
        expect(rule['reason']).to be_a(String), "#{cop_name} is missing a reason"
      end
    end

    it 'only lists cops that no longer exist' do
      registered = RuboCop::Cop::Registry.global.map(&:cop_name)
      expect(registered & removed_cops.keys).to be_empty
    end

    it 'only lists cops that are not in the default configuration' do
      expect(default_config.keys & removed_cops.keys).to be_empty
    end

    it 'is registered with RuboCop by the plugin' do
      plugin = described_class.new
      plugin.rules(nil)
      expect(RuboCop::ConfigObsoletion.files).to include(obsoletion_path)
    end

  end

end
