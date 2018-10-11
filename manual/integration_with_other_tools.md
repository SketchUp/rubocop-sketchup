# Integration

See [RuboCop's own documentation](https://docs.rubocop.org/en/latest/integration_with_other_tools/) for more information.

## Editor integration

### VSCode

#### VSCode Extensions

- [Ruby](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)
- [Ruby Solargraph](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph)

#### Gems

- [RuboCop](https://rubygems.org/gems/rubocop)
- [RuboCop SketchUp](https://rubygems.org/gems/rubocop-sketchup)
- [Solargraph](https://rubygems.org/gems/solargraph)

#### Project Configuration

`.vscode/settings.json`

```json
{
  "solargraph.diagnostics": true
}
```

`.solargraph.yml`

```yml
require_paths:
- "C:/Program Files/SketchUp/SketchUp 2018/Tools"
- src

reporters:
- rubocop
```

`.rubocop.yml`

```yml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true
  SketchUp:
    SourcePath: src
    TargetSketchUpVersion: 2014

SketchupDeprecations:
  Enabled: true

SketchupPerformance:
  Enabled: true

SketchupRequirements:
  Enabled: true

SketchupSuggestions:
  Enabled: true
```

## Rake integration

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-sketchup'
end
```
