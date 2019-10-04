# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupBugs::MaterialName do

  context 'when using material.name=' do

    context 'affected SketchUp versions' do

      subject(:cop) { described_class.new(config) }

      let(:config) do
        sketchup_version_config('SketchUp 2016')
      end

      it 'registers an offense for renaming a material via variable' do
        expect_offense(<<~RUBY)
          material = get_materials.add('Test')
          name = 'Example'
          material.name = name
          ^^^^^^^^^^^^^^^^^^^^ `material.name=` might add duplicate materials in SU2017 and older versions.
        RUBY
      end

      it 'registers an offense for renaming a material via string literal' do
        expect_offense(<<~RUBY)
          material = get_materials.add('Test')
          material.name = 'Example'
          ^^^^^^^^^^^^^^^^^^^^^^^^^ `material.name=` might add duplicate materials in SU2017 and older versions.
        RUBY
      end

      it 'registers an offense for using `name=` with other variable names' do
        expect_no_offenses(<<~RUBY)
          layer.name = 'Example'
        RUBY
      end

    end # context


    context 'unaffected SketchUp versions' do

      subject(:cop) { described_class.new(config) }

      let(:config) do
        sketchup_version_config('SketchUp 2018')
      end

      it 'registers an offense for renaming a material via variable' do
        expect_no_offenses(<<~RUBY)
          material = get_materials.add('Test')
          name = 'Example'
          material.name = name
        RUBY
      end

      it 'registers an offense for renaming a material via string literal' do
        # TODO(thomthom): Might want to add a SketchupSuggestions cop to detect
        # material renaming without going through materials.unique_name.
        expect_no_offenses(<<~RUBY)
          material = get_materials.add('Test')
          material.name = 'Example'
        RUBY
      end

    end # context

  end # context

end
