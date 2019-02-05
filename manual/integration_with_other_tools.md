# Integration

See [RuboCop's own documentation](https://docs.rubocop.org/en/latest/integration_with_other_tools/) for more information.

## Editor integration

### VSCode

#### VSCode Extensions

- [Ruby](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph)

#### Gems

- [Bundler](https://rubygems.org/gems/bundler)
- [RuboCop](https://rubygems.org/gems/rubocop)
- [RuboCop SketchUp](https://rubygems.org/gems/rubocop-sketchup)
- [Solargraph](https://rubygems.org/gems/solargraph)

#### Project Configuration

This setup uses Bundler to manage the gem dependencies for your project. It ensures you can use different version of `rubocop` and `rubocop-sketchup` for each of your projects.

Start by installing the VSCode extensions listed above.

Then add these configuration files relative to your project root:

`Gemfile`

```ruby
# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'rubocop', '~> 0.63.1'
  gem 'rubocop-sketchup', '~> 0.8.0'
  gem 'sketchup-api-stubs' # Not required for rubocop-sketchup, but nice to have
  gem 'solargraph'
end

```

`.vscode/settings.json`

```json
{
  "solargraph.diagnostics": true,
  "solargraph.useBundler": true
}
```

`.solargraph.yml`

```yml
require_paths:
- "C:/Program Files/SketchUp/SketchUp 2018/Tools" # Modify as needed
- src # Match with AllCops/SketchUp/SourcePath in .rubocop.yml.

reporters:
- rubocop
```

`.rubocop.yml`

```yml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true
  SketchUp:
    SourcePath: src # Modify as needed - refer to rubocop-sketchup's configuration
    TargetSketchUpVersion: 2014

SketchupDeprecations:
  Enabled: true

SketchupPerformance:
  Enabled: true

SketchupRequirements:
  Enabled: true

SketchupSuggestions:
  Enabled: true

SketchupBugs:
  Enabled: true
```

Once that is done, run `bundle install` to allow Bundler to install the required gems for your projects.

Now you should be ready to use VSCode with inline feedback from rubocop-sketchup.

## Rake integration

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-sketchup'
end
```
