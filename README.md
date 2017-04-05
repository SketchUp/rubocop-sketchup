# RuboCop SketchUp

Code analysis for SketchUp extensions using the [SketchUp Ruby API](http://ruby.sketchup.com/).

Tool intended to assist with development of SketchUp extension by providing static analysis for common issues.


## Installation

Requires [RuboCop](http://batsov.com/rubocop/) to be installed.

Install the `rubocop-sketchup` gem:

    gem install rubocop-sketchup

Or if you use bundler put this in your Gemfile:

    gem 'rubocop-sketchup'


## Usage

You need to tell RuboCop to load the `rubocop-sketchup` extension. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`:

```yaml
require: rubocop-sketchup
```

Now you can run `rubocop` and it will automatically load the RuboCop SketchUp cops together with the standard cops.

#### Running only cops for Extension Warehouse Technical requirements

If you want to focus on only the technical requirements for having your extension hosted on [Extension Warehouse](http://extensions.sketchup.com/) then you can limit the cop to only the `SketchupRequirements` department. This is the most important department which you should ignore.

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

### Command line

```bash
rubocop --require rubocop-sketchup --only SketchupRequirements
```

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

`rubocop-sketchup` is MIT licensed.
