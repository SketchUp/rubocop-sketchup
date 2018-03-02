# RuboCop SketchUp

[![Gem Version](https://badge.fury.io/rb/rubocop-sketchup.svg)](https://badge.fury.io/rb/rubocop-sketchup) [![Build status](https://ci.appveyor.com/api/projects/status/idwviv2nkal1gp7g?svg=true)](https://ci.appveyor.com/project/thomthom/rubocop-sketchup)

Code analysis for SketchUp extensions using the [SketchUp Ruby API](http://ruby.sketchup.com/).

Tool intended to assist with development of SketchUp extension by providing static analysis for common issues.


## Installation

### Requirements

* Standalone Ruby 2.1+ installation on the system. This is not intended to be used
  inside of SketchUp. Mac users should have Ruby already on the system, Windows
  users need to install it from https://rubyinstaller.org/.

* The [RuboCop](http://batsov.com/rubocop/) gem must also be installed.

        gem install rubocop -v 0.52

### Install

Install the `rubocop-sketchup` gem:

    gem install rubocop-sketchup

Or, if you use [bundler](http://bundler.io/) put this in your Gemfile:

    gem 'rubocop-sketchup'


## Usage

You need to tell RuboCop to load the `rubocop-sketchup` extension. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml` in your project root:

```yaml
require: rubocop-sketchup
```

Now you can run `rubocop` and it will automatically load the RuboCop SketchUp cops together with the standard cops.

#### Running only cops for Extension Warehouse Technical requirements

If you want to focus on only the technical requirements for having your extension hosted on [Extension Warehouse](http://extensions.sketchup.com/) then you can limit the cop to only the `SketchupRequirements` department. This is the most important department which you should not ignore.

```yaml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true

SketchupRequirements:
  Enabled: true
```

#### Running all SketchUp Cops

In addition to the requirements for the Extension Warehouse we have additional cops that looks for common patterns which have room for improvements. To run all of them, without all the RuboCop default cops use this configuration:

```yaml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true

SketchupDeprecations:
  Enabled: true

SketchupPerformance:
  Enabled: true

SketchupRequirements:
  Enabled: true

SketchupSuggestions:
  Enabled: true
```

#### Source Path

By default `rubocop-sketchup` expects to find the source for the SketchUp extension within a `src` directory relative to your `.rubocop.yml` config file.

This can be configured to match your own project structure by overwriting `AllCops/SketchUp/SourcePath` in your `.rubocop.yml`:

```yml
AllCops:
  SketchUp:
    SourcePath: src
```

If this isn't configured correctly then some cops, such as `SketchupRequirements/FileStructure` will fail as extension file structure is part of the Extension Warehouse technical requirements. Additionally, SketchUp expects this particular file structure to fully manage the extension.

#### Extra Details

Several cops have additional details to explain what they are checking. You can
enable this by using the `-D` command line parameter or modifying your
`.rubocop.yml` file by adding `ExtraDetails: true` under `AllCops`.

```yml
AllCops:
  ExtraDetails: true
```

### Command line

```bash
rubocop --require rubocop-sketchup --only SketchupRequirements
```

### Formatters

RuboCop comes with a set of different formatters that let you control how the results are presented.

If you want to output the result in machine readable JSON;

```bash
rubocop --out results.json --format json
```

The `rubocop-sketchup` gem provides a custom formatter designed for SketchUp related cops. It explains which cops to focus your attention on.

```bash
rubocop -f extension_review -o report.html
```

See [RuboCop's documentation](https://rubocop.readthedocs.io/en/latest/formatters/) for more examples.

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-sketchup'
end
```


## The Cops

All cops are located under [`lib/rubocop/sketchup`](lib/rubocop/sketchup), and contain examples/documentation.

### SketchupRequirements

`SketchupRequirements` is the most important department. This one checks for the technical requirements that extensions need to meet in order to be hosted on Extension Warehouse. Address flagged issues from this department as soon as possible.

Note that the complete technical requirements for Extension Warehouse is not fully covered by these cops. But they get you a long way if you pass their control.

### SketchupDeprecations

`SketchupDeprecations` is also an important department. Not rejection cause at Extension Warehouse, but worth paying attention to as it describe features of the API we would like to discourage the use of. Eventually some of them might be removed.

### SketchupPerformance

`SketchupPerformance` looks for common issues that impact performance. It's highly recommended to review what these cops report and evaluate if there are improvements that can be made to your extension.

### SketchupSuggestions

`SketchupSuggestions` might be the more noisy of the departments. These are more general gentle suggestions for common improvements to raise the quality of your extension and source code. No need to address everything this reports, evaluate to the context of your extension. In general this department will be a collection of established best practices.


## Building

### Development Requirements

Building this gem requires [bundler](http://bundler.io/).

```bash
gem install bundler
```

### Initialize Developer Environment

From the folder where you [cloned](https://help.github.com/articles/cloning-a-repository/) the repository:

```bash
bundle install
```

This will install all the developer dependencies to build the gem.

### Build

```bash
bundle exec rake install
```

After running this command `rubocop-sketchup` should be available on your system.

### Test

Running all tests:

```bash
bundle exec rake
```

Running single spec:

```bash
bundle exec rake spec SPEC=spec/rubocop/sketchup/requirements/global_methods_spec.rb
```


### Release

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

http://guides.rubygems.org/publishing/

You need the API key for an account that have ownership of the gem to push a new version. Make sure the API key is set up in `~/.gem/credentials` before running `bundle exec rake release`.

#### HTTPS GitHub Credentials under Windows

> As of 22 Feb 2018, GitHub has disabled support for weak encryption which means many users will suddenly find themselves unable to authenticate using a Git for Windows which (impacts versions older than v2.16.0). DO NOT PANIC, there's a fix. Update Git for Windows to the latest (or at least v2.16.0).

https://github.com/Microsoft/Git-Credential-Manager-for-Windows


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

`rubocop-sketchup` is MIT licensed.
