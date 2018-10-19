# Basic Usage

Refer to [RuboCop's own documentation](https://docs.rubocop.org/en/latest/basic_usage/) for general information on how to use and configure it.

## Enabling the `rubocop-sketchup` Extension

You need to tell RuboCop to load the `rubocop-sketchup` extension. There are a few ways to do this:

### RuboCop Configuration File (Recommended)

Put this into your `.rubocop.yml` in your project root:

```yaml
require: rubocop-sketchup
```

Now you can run `rubocop` and it will automatically load the RuboCop SketchUp cops together with the standard cops.

### Command Line Argument

You can also load it via the command line:

```sh
rubocop -r rubocop-sketchup
```

That will run RuboCop with all of it's own cops along with the SketchUp cops.

You can tell it to run specific departments:

```sh
rubocop -r rubocop-sketchup --only SketchupRequirements,SketchupDeprecations
```

## Running only cops for Extension Warehouse Technical requirements

If you want to focus on only the technical requirements for having your extension hosted on [Extension Warehouse](http://extensions.sketchup.com/) then you can limit the cops to only the `SketchupRequirements` department. This is the most important department which you should not ignore.

```yaml
require: rubocop-sketchup

AllCops:
  DisabledByDefault: true

SketchupRequirements:
  Enabled: true
```

## Running all SketchUp Cops

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
