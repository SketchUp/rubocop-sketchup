# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupBugs::RenderMode do

  context 'affected SketchUp versions' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2018')
    end

    described_class::RENDER_MODE_VALID.each do |var|
      it 'registers an offense for valid rendering mode' do
        expect_no_offenses(<<~RUBY)
          Sketchup.active_model.rendering_options["RenderMode"] = #{var}
        RUBY
      end
    end

    described_class::RENDER_MODE_OBSOLETE.each do |var|
      it 'registers an offense for obsolete rendering mode' do
        expect_offense(<<~RUBY)
          Sketchup.active_model.rendering_options["RenderMode"] = #{var}
                                                                  ^ Obsolete render mode will crash in SU2017 and newer versions.
        RUBY
      end
    end

    it 'registers an offense for invalid rendering mode' do
      expect_offense(<<~RUBY)
        Sketchup.active_model.rendering_options['RenderMode'] = 99
                                                                ^^ Invalid render mode will crash in SU2017 and newer versions.
      RUBY
    end

    it 'does not register an offense for other rendering options' do
      expect_no_offenses(<<~RUBY)
        Sketchup.active_model.rendering_options["EdgeType"] = 1
      RUBY
    end

  end # context


  context 'unaffected SketchUp versions' do

    subject(:cop) { described_class.new(config) }

    let(:config) do
      sketchup_version_config('SketchUp 2014')
    end

    # rubocop:disable RSpec/RepeatedExample
    described_class::RENDER_MODE_VALID.each do |var|
      it 'registers an offense for valid rendering mode' do
        expect_no_offenses(<<~RUBY)
          Sketchup.active_model.rendering_options["RenderMode"] = #{var}
        RUBY
      end
    end

    described_class::RENDER_MODE_OBSOLETE.each do |var|
      it 'registers an offense for obsolete rendering mode' do
        expect_no_offenses(<<~RUBY)
          Sketchup.active_model.rendering_options["RenderMode"] = #{var}
        RUBY
      end
    end
    # rubocop:enable RSpec/RepeatedExample

    it 'registers an offense for invalid rendering mode' do
      expect_no_offenses(<<~RUBY)
        Sketchup.active_model.rendering_options['RenderMode'] = 99
      RUBY
    end

    it 'does not register an offense for other rendering options' do
      expect_no_offenses(<<~RUBY)
        Sketchup.active_model.rendering_options["EdgeType"] = 1
      RUBY
    end

  end

end
