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

## Source Path

By default `rubocop-sketchup` expects to find the source for the SketchUp extension within a `src` directory relative to your `.rubocop.yml` config file.

This can be configured to match your own project structure by overwriting `AllCops/SketchUp/SourcePath` in your `.rubocop.yml`:

```yml
AllCops:
  SketchUp:
    SourcePath: src
```

If this isn't configured correctly then some cops, such as `SketchupRequirements/FileStructure` will fail as extension file structure is part of the Extension Warehouse technical requirements. Additionally, SketchUp expects this particular file structure to fully manage the extension.

## Target SketchUp Version

The `SketchupSuggestions/Compatibility` cop checks for usage of the SketchUp API against a configured target version.

Currently the default is `SketchUp 2016`.

```
rubocop --only SketchupSuggestions/Compatibility
Inspecting 30 files
.....................C........

Offenses:

examples/snippets/deprecations/compatibility.rb:9:13: C: SketchupSuggestions/Compatibility: The class Sketchup::ImageRep was added in SketchUp 2018 which is incompatible with target SketchUp 2014.
    image = Sketchup::ImageRep.new
            ^^^^^^^^^^^^^^^^^^
examples/snippets/deprecations/compatibility.rb:23:13: C: SketchupSuggestions/Compatibility: The constant Geom::PolygonMesh::MESH_POINTS was added in SketchUp 2018 which is incompatible with target SketchUp 2014.
    flags = Geom::PolygonMesh::MESH_POINTS | Geom::PolygonMesh::MESH_NORMALS
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
examples/snippets/deprecations/compatibility.rb:38:5: C: SketchupSuggestions/Compatibility: The method #onPidChanged was added in SketchUp 2017 which is incompatible with target SketchUp 2014.
    def onPidChanged(model, old_pid, new_pid) ...
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

30 files inspected, 3 offenses detected
```

This can be configured to match your own project structure by overwriting `AllCops/SketchUp/SourcePath` in your `.rubocop.yml`:

```yml
AllCops:
  SketchUp:
    TargetSketchUpVersion: 2016 M1
```

Available versions are:

```
2018
2017
2016 M1
2016
2015
2014
2013
8.0 M2
8.0 M1
8.0
7.1 M1
7.1
7.0 M1
7.0
6.0
```

## Department Excludes

Current version of RuboCop doesn't support exclude filters for departments. To make it easier to exclude certain files for the SketchUp departments this can be configured in the SketchUp config section:

```yml
AllCops:
  SketchUp:
    SketchupPerformance:
      Exclude:
      - src/example/biz.rb
    SketchupSuggestions:
      Exclude:
      - src/example/foo.rb
      - src/example/bar.rb
      - test/
```

## Extra Details

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
