# RuboCop SketchUp

[![Gem Version](https://badge.fury.io/rb/rubocop-sketchup.svg)](https://badge.fury.io/rb/rubocop-sketchup) [![Build status](https://ci.appveyor.com/api/projects/status/idwviv2nkal1gp7g?svg=true)](https://ci.appveyor.com/project/thomthom/rubocop-sketchup)

Code analysis for SketchUp extensions using the [SketchUp Ruby API](http://ruby.sketchup.com/).

Tool intended to assist with development of SketchUp extension by providing static analysis for common issues.


## Installation

### TL;DR

```sh
gem install rubocop -v 0.58.1
gem install rubocop-sketchup
```

### The Long Version

* [Manual: Requirements and Installation](manual/installation.md)


## Usage

### TL;DR

Add `.rubocop.yml` in the root of your project:

```yaml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true
  DisplayStyleGuide: true
  ExtraDetails: true
  SketchUp:
    SourcePath: src # Path to extension sources in project directory.
    TargetSketchUpVersion: 2016 M1

SketchupDeprecations:
  Enabled: true

SketchupPerformance:
  Enabled: true

SketchupRequirements:
  Enabled: true

SketchupSuggestions:
  Enabled: true
```

### The Long Version

* [Manual: Basic Usage](manual/basic_usage.md)
* [Manual: Configuration](manual/configuration.md)


### Formatters

### TL;DR

#### JSON

```bash
rubocop --format json --out results.json
```


#### Extension Review

```bash
rubocop -f extension_review -o report.html
```

### The Long Version

* [Manual: Formatters](manual/formatters.md)


## The Cops

All cops are located under [`lib/rubocop/sketchup`](lib/rubocop/sketchup), and contain examples/documentation.

[Manual: Cops](manual/cops.md)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

`rubocop-sketchup` is MIT licensed.
