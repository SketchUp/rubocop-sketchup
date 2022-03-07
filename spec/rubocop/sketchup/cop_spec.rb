# frozen_string_literal: true

describe RuboCop::SketchUp::Cop do
  subject(:cop) { fake_cop.new(config) }

  let(:config) do
    rubocop_config =
        {
          'AllCops' => {
            'SketchUp' => {
              'Exclude' => sketchup_excludes,
              'SketchupDeprecations' => {
                'Exclude' => department_excludes,
              },
            },
          },
          'SketchupDeprecations/FakeCop' => {
            'Exclude' => %w[src/bizbaz.rb],
          },
        }

    RuboCop::Config.new(rubocop_config, 'fake_cop_config.yml')
  end

  let(:fake_cop) do
    stub_const('RuboCop::SketchupDeprecations', Module.new)

    cop_class = Class.new(described_class) do
      def on_send(node)
        add_offense(node, location: :expression, message: 'I flag everything')
      end
    end
    stub_const('RuboCop::SketchupDeprecations::FakeCop', cop_class)
  end

  let(:sketchup_excludes) { %w[spec/**/* **/*_spec.rb] }
  let(:department_excludes) { %w[test/**/* **/*_test.rb] }

  context 'when the source path starts with `src`' do
    it 'registers an offense' do
      expect_offense(<<-RUBY, 'src/foo.rb')
        foo(1)
        ^^^^^^ I flag everything
      RUBY
    end

    it 'ignores the file if it is cop-excluded' do
      expect_no_offenses(<<-RUBY, 'src/bizbaz.rb')
        foo(1)
      RUBY
    end

    it 'ignores the file if it is department-excluded' do
      expect_no_offenses(<<-RUBY, 'src/bar_test.rb')
        foo(1)
      RUBY
    end

    it 'ignores the file if it is sketchup-excluded' do
      expect_no_offenses(<<-RUBY, 'src/bar_spec.rb')
        foo(1)
      RUBY
    end
  end

  context 'when the source path contains `/test/`' do
    it 'registers an offense when path starts at root' do
      expect_offense(<<-RUBY, '/test/support/thing.rb')
        foo(1)
        ^^^^^^ I flag everything
      RUBY
    end
  end

  context 'when the source path starts with `test/`' do
    it 'ignores the file if it is department-excluded' do
      expect_no_offenses(<<-RUBY, 'test/support/thing.rb')
        foo(1)
      RUBY
    end
  end

  context 'when the source path contains `/spec/`' do
    it 'registers an offense when path starts at root' do
      expect_offense(<<-RUBY, '/spec/support/thing.rb')
        foo(1)
        ^^^^^^ I flag everything
      RUBY
    end
  end

  context 'when the source path starts with `spec/`' do
    it 'ignores the file if it is sketchup-excluded' do
      expect_no_offenses(<<-RUBY, 'spec/support/thing.rb')
        foo(1)
      RUBY
    end
  end

end
