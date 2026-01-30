# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupSuggestions::Compatibility, :config do

  context 'incompatible features' do

    let(:config) do
      sketchup_version_config('SketchUp 6')
    end

    it 'registers an offense when using incompatible class' do
      expect_offense(<<~RUBY)
        dialog = UI::HtmlDialog.new
                 ^^^^^^^^^^^^^^ The class `UI::HtmlDialog` was added in SketchUp 2017 which is incompatible with target SketchUp 6.0.
      RUBY
    end

    it 'registers an offense when using incompatible class in a method' do
      expect_offense(<<~RUBY)
        module Example
          def self.hello
            dialog = UI::HtmlDialog.new
                     ^^^^^^^^^^^^^^ The class `UI::HtmlDialog` was added in SketchUp 2017 which is incompatible with target SketchUp 6.0.
          end
        end
      RUBY
    end

    it 'registers an offense when using incompatible class in a block' do
      expect_offense(<<~RUBY)
        module Example
          def self.hello
            5.times do |i|
              dialog = UI::HtmlDialog.new
                       ^^^^^^^^^^^^^^ The class `UI::HtmlDialog` was added in SketchUp 2017 which is incompatible with target SketchUp 6.0.
            end
          end
        end
      RUBY
    end

    it 'registers an offense when using incompatible module' do
      expect_offense(<<~RUBY)
        state = Sketchup::Licensing::LICENSED
                ^^^^^^^^^^^^^^^^^^^ The module `Sketchup::Licensing` was added in SketchUp 2015 which is incompatible with target SketchUp 6.0.
      RUBY
    end

    it 'registers an offense when using incompatible module method' do
      expect_offense(<<~RUBY)
        scale = UI.select_directory(title: "Select Directory")
                   ^^^^^^^^^^^^^^^^ The method `UI.select_directory` was added in SketchUp 2015 which is incompatible with target SketchUp 6.0.
      RUBY
    end

    it 'registers an offense when using incompatible instance method' do
      expect_offense(<<~RUBY)
        page.include_in_animation = true
             ^^^^^^^^^^^^^^^^^^^^ The method `Sketchup::Page#include_in_animation=` was added in SketchUp 2018 which is incompatible with target SketchUp 6.0.
      RUBY
    end

    it 'registers an register an offense when using incompatible observer method' do
      expect_offense(<<~RUBY)
        class ExampleObserver < Sketchup::EntitiesObserver
          def onActiveSectionPlaneChanged(entities)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^ The method `Sketchup::EntitiesObserver#onActiveSectionPlaneChanged` was added in SketchUp 2014 which is incompatible with target SketchUp 6.0.
          end
        end
      RUBY
    end

    it 'does not register an offense when shadowing incompatible module' do
      expect_no_offenses(<<~RUBY)
        module Example
          module Layout
          end
        end
      RUBY
    end

    it 'does not register an offense when shadowing incompatible class' do
      expect_no_offenses(<<~RUBY)
        module Example
          class Layout
          end
        end
      RUBY
    end

  end

  context 'compatible features' do

    let(:config) do
      sketchup_version_config('SketchUp 2018')
    end

    it 'does not register an offense when using compatible class' do
      expect_no_offenses(<<~RUBY)
        dialog = UI::HtmlDialog.new
      RUBY
    end

    it 'does not register an offense when using compatible module' do
      expect_no_offenses(<<~RUBY)
        image = Sketchup::ImageRep.new
      RUBY
    end

    it 'does not register an offense when using compatible module method' do
      expect_no_offenses(<<~RUBY)
        UI.scale_factor
      RUBY
    end

    it 'does not register an offense when using compatible instance method' do
      expect_no_offenses(<<~RUBY)
        page.include_in_animation = true
      RUBY
    end

    it 'does not register an offense when using compatible observer method' do
      expect_no_offenses(<<~RUBY)
        class ExampleObserver < Sketchup::Entities
          def onActiveSectionPlaneChanged(entities)
          end
        end
      RUBY
    end

  end

end
