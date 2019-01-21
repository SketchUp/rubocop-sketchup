# frozen_string_literal: true

require 'rubocop/sketchup/sketchup_target_range'

describe RuboCop::SketchUp::SketchUpTargetRange do

  subject(:cop) { fake_cop.new(config) }

  context 'cop with minimum sketchup target' do

    let(:fake_cop) do
      stub_const('RuboCop::SketchupBugs', Module.new)
      class RuboCop::SketchupBugs::FakeCop < RuboCop::SketchUp::Cop

        include RuboCop::SketchUp::SketchUpTargetRange

        define_sketchup_target_min_version 'SketchUp 2016'

        def on_send(node)
          return unless valid_for_target_sketchup_version?

          add_offense(node, location: :expression, message: 'I flag everything')
        end
      end
      RuboCop::SketchupBugs::FakeCop
    end

    context 'and target is below' do

      let(:config) do
        sketchup_version_config('SketchUp 2014')
      end

      it 'does not register an offense' do
        expect_no_offenses(<<-RUBY, 'test/support/thing.rb')
          foo(1)
        RUBY
      end

    end # context 'and target is below'

    context 'and target is above' do

      let(:config) do
        sketchup_version_config('SketchUp 2018')
      end

      it 'registers an offense' do
        expect_offense(<<-RUBY, '/test/support/thing.rb')
          foo(1)
          ^^^^^^ I flag everything
        RUBY
      end

    end # context 'and target is below'

  end # context 'cop with minimum sketchup target'


  context 'cop with maximum sketchup target' do

    let(:fake_cop) do
      stub_const('RuboCop::SketchupBugs', Module.new)
      class RuboCop::SketchupBugs::FakeCop < RuboCop::SketchUp::Cop

        include RuboCop::SketchUp::SketchUpTargetRange

        define_sketchup_target_max_version 'SketchUp 2016'

        def on_send(node)
          return unless valid_for_target_sketchup_version?

          add_offense(node, location: :expression, message: 'I flag everything')
        end
      end
      RuboCop::SketchupBugs::FakeCop
    end

    context 'and target is below' do

      let(:config) do
        sketchup_version_config('SketchUp 2014')
      end

      it 'registers an offense' do
        expect_offense(<<-RUBY, '/test/support/thing.rb')
          foo(1)
          ^^^^^^ I flag everything
        RUBY
      end

    end # context

    context 'and target is above' do

      let(:config) do
        sketchup_version_config('SketchUp 2018')
      end

      it 'does not register an offense' do
        expect_no_offenses(<<-RUBY, 'test/support/thing.rb')
          foo(1)
        RUBY
      end

    end # context

  end # context 'cop with maximum sketchup target'


  context 'cop with minimum and maximum sketchup target' do

    let(:fake_cop) do
      stub_const('RuboCop::SketchupBugs', Module.new)
      class RuboCop::SketchupBugs::FakeCop < RuboCop::SketchUp::Cop

        include RuboCop::SketchUp::SketchUpTargetRange

        define_sketchup_target_min_version 'SketchUp 2015'
        define_sketchup_target_max_version 'SketchUp 2017'

        def on_send(node)
          return unless valid_for_target_sketchup_version?

          add_offense(node, location: :expression, message: 'I flag everything')
        end
      end
      RuboCop::SketchupBugs::FakeCop
    end

    context 'and target is below range' do

      let(:config) do
        sketchup_version_config('SketchUp 2014')
      end

      it 'does not register an offense' do
        expect_no_offenses(<<-RUBY, 'test/support/thing.rb')
          foo(1)
        RUBY
      end

    end # context

    context 'and target is within at range start' do

      let(:config) do
        sketchup_version_config('SketchUp 2015')
      end

      it 'registers an offense' do
        expect_offense(<<-RUBY, '/test/support/thing.rb')
          foo(1)
          ^^^^^^ I flag everything
        RUBY
      end

    end # context

    context 'and target is within range' do

      let(:config) do
        sketchup_version_config('SketchUp 2016')
      end

      it 'registers an offense' do
        expect_offense(<<-RUBY, '/test/support/thing.rb')
          foo(1)
          ^^^^^^ I flag everything
        RUBY
      end

    end # context

    context 'and target is within at range end' do

      let(:config) do
        sketchup_version_config('SketchUp 2017')
      end

      it 'registers an offense' do
        expect_offense(<<-RUBY, '/test/support/thing.rb')
          foo(1)
          ^^^^^^ I flag everything
        RUBY
      end

    end # context

    context 'and target is above range' do

      let(:config) do
        sketchup_version_config('SketchUp 2018')
      end

      it 'does not register an offense' do
        expect_no_offenses(<<-RUBY, 'test/support/thing.rb')
          foo(1)
        RUBY
      end

    end # context

  end # context 'cop with minimum and maximum sketchup target'

end
