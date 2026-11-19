# frozen_string_literal: true

require 'spec_helper'
require 'stringio'

describe RuboCop::Formatter::ExtensionReviewFormatter do

  subject(:html) do
    formatter = described_class.new(output)
    formatter.started(['example.rb'])
    formatter.file_finished('example.rb', offenses)
    formatter.finished(['example.rb'])
    output.string
  end

  let(:output) { StringIO.new }
  let(:source) do
    RuboCop::ProcessedSource.new("one = 1\ntwo = 2\nthree = 3\n", 3.2)
  end

  def note
    "won't cause a rejection"
  end

  def banner
    html[%r{<div class="verdict.*?</div>\s*</div>}m]
  end

  # The same page with all whitespace runs collapsed, so that text wrapped over
  # several lines in the template can be searched for.
  def page
    html.gsub(/\s+/, ' ')
  end

  def banner_text
    banner.gsub(/\s+/, ' ')
  end

  def offense(severity, cop_name, message, line)
    range = source.buffer.line_range(line)
    # RuboCop prefixes the message with the cop name when DisplayCopNames is on.
    message = "#{cop_name}: #{message}"
    RuboCop::Cop::Offense.new(severity, range, message, cop_name)
  end

  context 'without any offenses' do

    let(:offenses) { [] }

    it 'reports that there are no issues' do
      expect(html).to include('No issues')
    end

    it 'does not say that the extension will be rejected' do
      expect(html).not_to include('Will be rejected')
    end

  end

  context 'with only warnings and conventions' do

    let(:offenses) do
      [
        offense(:warning, 'SketchupDeprecations/ShowRubyPanel', 'Warn.', 1),
        offense(:convention, 'SketchupSuggestions/Sleep', 'Suggest.', 2),
      ]
    end

    it 'reports that there are no issues' do
      expect(html).to include('No issues')
    end

    it 'does not list the warnings as blocking' do
      expect(html).not_to include('Will be rejected')
    end

  end

  context 'with errors' do

    let(:offenses) do
      [
        offense(:error, 'SketchupRequirements/Exit', 'Use `return`.', 1),
        offense(:error, 'SketchupRequirements/Exit', 'Use `return`.', 2),
        offense(:error, 'SketchupRequirements/LoadPath', 'Do not do it.', 3),
        offense(:warning, 'SketchupDeprecations/ShowRubyPanel', 'Warn.', 1),
      ]
    end

    it 'counts every blocking location, not warnings' do
      expect(html).to include('Will be rejected: 3 issues to fix')
    end

    it 'links each issue to its section in the report' do
      links = banner.scan(/href="(#offense_[a-z_]+)"/).flatten
      expect(links).to eq(%w[#offense_sketchuprequirements_exit
                             #offense_sketchuprequirements_loadpath])
    end

    it 'does not link warnings from the banner' do
      expect(banner).not_to include('ShowRubyPanel')
    end

    it 'tells the developer to fix the issues before submitting' do
      expect(banner_text).to include(
          'Extension Warehouse rejects extensions with these issues, ' \
          'so fix them before submitting.'
        )
    end

    it 'only shows the cop names as bullets' do
      items = banner.scan(%r{<li>(.*?)</li>}m).flatten.map { |i| i.gsub(/<[^>]+>|\s+/, ' ').strip }
      expect(items).to eq(%w[SketchupRequirements/Exit
                             SketchupRequirements/LoadPath])
    end

    it 'does not repeat the message, reference or location in the banner' do
      expect(banner_text).not_to match(/Use <code>return|example\.rb|https?:/)
    end

  end

  context 'with the same cop reported with different messages' do

    let(:offenses) do
      [
        offense(:error, 'SketchupRequirements/Exit', 'One.', 1),
        offense(:error, 'SketchupRequirements/Exit', 'Two.', 2),
      ]
    end

    it 'lists the cop once' do
      expect(banner.scan('href="#offense_sketchuprequirements_exit"').size)
        .to eq(1)
    end

  end

  context 'with errors and warnings' do

    let(:offenses) do
      [
        offense(:warning, 'SketchupDeprecations/ShowRubyPanel', 'Warn.', 1),
        offense(:error, 'SketchupRequirements/Exit', 'Use `return`.', 2),
        offense(:convention, 'SketchupSuggestions/Sleep', 'Suggest.', 3),
      ]
    end

    it 'only has the title and the links in the banner' do
      expect(banner_text).not_to include(note)
    end

    it 'explains the suggestions once, in the report body' do
      expect(page.scan(note).size).to eq(1)
    end

    it 'places the explanation after the errors' do
      expect(page.index(note)).to be > page.index('id="offense_sketchuprequirements_exit"')
    end

    it 'places the explanation before the first warning' do
      expect(page.index(note)).to be < page.index('id="offense_sketchupdeprecations_showrubypanel"')
    end

  end

  context 'with errors and a warning for the same cop' do

    let(:offenses) do
      [
        offense(:warning, 'SketchupRequirements/GetExtensionLicense', 'Warn.', 1),
        offense(:error, 'SketchupRequirements/GetExtensionLicense', 'Bad.', 2),
      ]
    end

    it 'places the explanation between the error and the warning' do
      expect(page.index("won't cause a rejection")).to be_between(
          page.index('error:</span>'), page.index('warning:</span>')
        )
    end

  end

  context 'with only errors' do

    let(:offenses) do
      [offense(:error, 'SketchupRequirements/Exit', 'Use `return`.', 1)]
    end

    it 'does not explain suggestions when there are none' do
      expect(page).not_to include("won't cause a rejection")
    end

  end

  context 'with a single error' do

    let(:offenses) do
      [offense(:error, 'SketchupRequirements/Exit', 'Use `return`.', 1)]
    end

    it 'uses the singular form' do
      expect(html).to include('Will be rejected: 1 issue to fix')
    end

  end

  context 'with a fatal error' do

    let(:offenses) do
      [offense(:fatal, 'SketchupRequirements/Exit', 'Broken.', 1)]
    end

    it 'treats fatal as blocking' do
      expect(html).to include('Will be rejected: 1 issue to fix')
    end

  end

end
