#
# https://github.com/ukoloff/appveyor-worker/issues/1
#
require 'appveyor/worker'

module AppVeyor::Worker::RSpec
    def self.welcome
        ::AppVeyor::Worker.message "RSpec seed: #{RSpec.configuration.seed}"
        []
    end

    def self.report example
        res = example.execution_result
        return unless res.status

        ::AppVeyor::Worker.test testFramework: 'RSpec',
            testName: example.full_description,
            fileName: example.location,
            outcome: ({passed: 'Passed', failed: 'Failed', pending: 'Ignored'}[res.status] || '?'),
            durationMilliseconds: res.run_time*1000
            #   StdOut: YAML.dump('assertions'=>result.assertions),
            #   ErrorStackTrace: (result.failure.backtrace * "\n" rescue nil)

        true
    end

    def self.examples
        @examples ||= welcome
    end

    def self.add example
        process
        examples.push example
    end

    def self.process
        ex = examples
        @examples = []
        ex.each do |example|
            unless report example
                examples.push example
            end
        end
    end

    def self.intercept!
        this = self
        RSpec.configure do |config|
            config.before :each do |example|
                this.add example
            end

            config.after :all do
                this.process
            end
        end
    end

    intercept! if defined? RSpec
end
