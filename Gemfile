source 'https://rubygems.org'

gemspec

group :test do
  gem 'rake', '~> 10.0', require: false
  gem 'rspec', '~> 3.4', require: false
end

gem 'appveyor-worker' if ENV['APPVEYOR_API_URL']
