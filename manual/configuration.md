# General

Refer to the [RuboCop documentation](https://github.com/rubocop-hq/rubocop/blob/master/manual/configuration.md) about general configuration of RuboCop itself.

# `rubocop-sketchup` Configuration

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

## Reference URLs

For even more details, enable `DisplayStyleGuide` to display an URL to a more
detailed explanation for each cop. Add `-S` to the command line or modify
your `.rubocop.yml` file to set it permanently.

```yml
AllCops:
  DisplayStyleGuide: true
```
