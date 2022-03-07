# frozen_string_literal: true

describe 'RuboCop Project' do
  describe 'default configuration file' do

    subject(:default_config) do
      RuboCop::ConfigLoader.load_file('config/default.yml')
    end

    let(:cop_names) do
      project_path = File.expand_path('..', __dir__)
      cop_files = Dir.glob(File.join(project_path, 'lib',
                                     'rubocop', 'sketchup', '**', '*.rb'))
      cop_files.map do |file|
        basename = File.basename(file, '.rb')
        dirname = File.basename(File.dirname(file))
        cop_name = basename.gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
        department_name = dirname.gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }

        "Sketchup#{department_name}/#{cop_name}"
      end
    end

    let(:sketchup_config_keys) do
      default_config.keys.select { |k| k.start_with?('Sketchup') }
    end

    # TODO(thomthom): Enable once default config have been cleaned up.
    # it 'has configuration for all cops' do
    #   expect(sketchup_config_keys.sort).to eq(cop_names.sort)
    # end

    # TODO(thomthom): Enable once default config have been cleaned up.
    # it 'has a nicely formatted description for all cops' do
    #   cop_names.each do |name|
    #     description = default_config[name]['Description']
    #     expect(description).not_to be_nil
    #     expect(description).not_to include("\n")
    #   end
    # end
  end
end
