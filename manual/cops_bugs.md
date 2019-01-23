# SketchupBugs

<a name='materialname'></a>
## SketchupBugs/MaterialName

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Prior to SketchUp 2018 it was possible for the Ruby API to cause
materials to have duplicate names. This is not a valid SketchUp model
as SketchUp expects material names to be unique identifiers.

`model.materials.add('Example')` have always made materials unique by
appending a numeric post-fix to the name.

However, `material.name = 'Example'` did not perform such check. It
would blindly set the new name.

As of SketchUp 2018 the API behavior was changed to prevent this.
`material.name = 'Example'` will now raise an `ArgumentError` is the
name is not unique.

A new method was added to allow a unique material name to be generated:
`model.material.unique_name('Example')`.

Changing the name of materials can now follow the same pattern as layers
and component definitions.

Note that in SketchUp 2018 there was also a second bug introduced. A
name cache was introduced to speed up the lookup and generation of
unique names. Unfortunately this got out of sync between changing name
via the UI versus via the API. This has been fixed in SketchUp 2019.

### Examples

#### Pattern for setting material name from SketchUp 2018

```ruby
material.name = model.materials.unique_name('Example')
```
#### Pattern for setting name prior to SketchUp 2018

```ruby
# Works with SketchUp 2014 or newer:
require 'set'

module Example

  def self.rename_material(material, name)
    materials = material.model.materials
    material.name = self.unique_name(materials, name)
  end

  def self.unique_material_name(materials, name)
    if materials.respond_to?(:unique_name)
      # Use fast native implementation if possible.
      materials.unique_name(name)
    else
      # Cache names in a Set for fast lookup.
      names = Set.new(materials.map(&:name))
      unique_name = name
      # Extract the base name and post-fix.
      match = unique_name.match(/^\D.*?(\d*)$/)
      base, postfix = match ? match.captures : [unique_name, 0]
      # Ensure basename has length and postfix is an integer.
      base = unique_name if base.empty?
      postfix = postfix.to_i
      # Iteratively find a unique name.
      until !names.include?(unique_name)
        postfix = postfix.next
        unique_name = "#{base}#{postfix}"
      end
      unique_name
    end
  end

end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_bugs.md#materialname](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_bugs.md#materialname)

<a name='rendermode'></a>
## SketchupBugs/RenderMode

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

A regression was introduced in SketchUp 2017 that cause invalid render
modes to crash SketchUp. The crash might not happen exactly when the
new mode is set, but later when the viewport re-draws.

Valid render modes are: (Internal enum names in parentheses)

* `0` (`kRenderWireframe`)
* `1` (`kRenderHidden`)
* `2` (`kRenderFlat`)
* `3` (`kRenderSmooth`)
* `5` (`kRenderNoMaterials`)

### Examples

#### This obsolete render mode will crash SketchUp 2017 and newer

```ruby
Sketchup.active_model.rendering_options["RenderMode"] = 4
```
#### This invalid render mode will crash SketchUp 2017 and newer

```ruby
Sketchup.active_model.rendering_options["RenderMode"] = 99
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_bugs.md#rendermode](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_bugs.md#rendermode)
