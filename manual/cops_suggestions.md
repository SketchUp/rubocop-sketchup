# SketchupSuggestions

<a name='addgroup'></a>
## SketchupSuggestions/AddGroup

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

The idiomatic way to create groups via the Ruby API differ from the
way you'd do it from the UI.

Using the API you should prefer to create the group first, then add
your geometry into the group. This is more performant and predictable.

Grouping existing geometry via the API have historically been affected
by bugs and issues.

If you do have to group existing geometry via the API, make sure you
group geometry from the active context; `model.active_entities`.
Otherwise you might run into unexpected issues, even crashes.

### Examples

#### Adding new geometry

```ruby
# bad
face1 = model.active_entities.add_face(points1)
face2 = model.active_entities.add_face(points2)
group = model.active_entities.add_group([face1, face2])

# good
group = model.active_entities.add_group
face1 = group.entities.add_face(points1)
face2 = group.entities.add_face(points2)
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#addgroup](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#addgroup)

<a name='compatibility'></a>
## SketchupSuggestions/Compatibility

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

It's easy to lose track of what API feature was added in what version or
SketchUp. You can configure your target SketchUp version and be notified
if you use features introduced in newer versions.

### Examples

#### Add this to your .rubocop.yml

```ruby
AllCops:
  SketchUp:
    TargetSketchUpVersion: 2016 M1
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#compatibility](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#compatibility)

<a name='dynamiccomponentinternals'></a>
## SketchupSuggestions/DynamicComponentInternals

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Tapping into the internals of Dynamic Components is risky. It could
change at any time. If you create an extension that depend on the
internal logic of another extension you are at the mercy of change and
luck!

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#dynamiccomponentinternals](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#dynamiccomponentinternals)

<a name='fileencoding'></a>
## SketchupSuggestions/FileEncoding

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

When using __FILE__ and __dir__, beware that Ruby doesn't apply the
correct encoding to the strings under Windows. When they contain
non-english characters it will lead to exceptions being raised when the
strings are used. Force encoding to work around this.

### Examples

#### Might fail

```ruby
basename = File.basename(__FILE__, '.*')
```
#### Workaround

```ruby
file = __FILE__.dup
file.force_encoding('UTF-8') if file.respond_to?(:force_encoding)
basename = File.basename(file, '.*')
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#fileencoding](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#fileencoding)

<a name='modelentities'></a>
## SketchupSuggestions/ModelEntities

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Prefer `model.active_entities` over `model.entities`.

Most tools/actions act upon the active entities context. This could be
an opened group or component instance. Because of this, prefer
`model.active_entities` by default over `model.entities` unless you
have an explicit reason to work in the root model context.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#modelentities](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#modelentities)

<a name='monkeypatchedapi'></a>
## SketchupSuggestions/MonkeyPatchedApi

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Some of the shipped extensions in SketchUp monkey-patch the API
namespace. This is an unfortunate no-no that was done a long time ago
before the extension best-practices were established. These functions
might change or be removed at any time. They will also not work when
the extensions are disabled. Avoid using these methods.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#monkeypatchedapi](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#monkeypatchedapi)

<a name='operationname'></a>
## SketchupSuggestions/OperationName

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Operation name should be a short capitalized description. It will be
visible to the user in the Edit > Undo menu. Make sure to give it a
short human readable name, similar to SketchUp's own operation names.

This cop make some very naive assumptions and will have more false
positives than most of the other cops. It's purpose is mainly to enable
awareness.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Max | `25` | Integer

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#operationname](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#operationname)

<a name='sketchupfindsupportfile'></a>
## SketchupSuggestions/SketchupFindSupportFile

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid `Sketchup.find_support_file` to find your extension's files.

Users might install your extension to locations other than the default
Plugins directory. If you use `Sketchup.find_support_file` to build
a path for files in your extension it will fail in these scenarios.

Instead prefer to use `__FILE__` or `__dir__` to build paths relative
to your source files. This have the added benefit of allowing you to
load your extensions directly from external directories under version
control.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchupfindsupportfile](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchupfindsupportfile)

<a name='tooldrawingbounds'></a>
## SketchupSuggestions/ToolDrawingBounds

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

When drawing 3D geometry to the viewport from a tool, make sure to
implement `getExtents` that return a `Geom::BoundingBox` object large
enough to encompass what you draw.

With out doing that the drawn content might end up being clipped.

### Examples

```ruby
# good
class ExampleTool

  def getExtents
    bounds = Geom::BoundingBox.new
    bounds.add(@points)
    bounds
  end

  def draw(view)
    view.draw(GL_LINES, @points)
  end

end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#tooldrawingbounds](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#tooldrawingbounds)

<a name='toolinvalidate'></a>
## SketchupSuggestions/ToolInvalidate

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

After having drawn to the viewport from a tool, make sure to invalidate
the view on `deactivate` and `suspend`.

If you don't do that the things you drew might stick around for longer
than the life-span of the tool and cause confusion for the user.

### Examples

```ruby
# good
class ExampleTool

  def deactivate(view)
    view_invalidate
  end

  def suspend(view)
    view_invalidate
  end

  def draw(view)
    view.draw(GL_LINES, @points)
  end

end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#toolinvalidate](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#toolinvalidate)

<a name='tooluserinput'></a>
## SketchupSuggestions/ToolUserInput

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

When a tool takes user input via `onUserText`, make sure to define
`enableVCB?` so that the VCB is enabled.

### Examples

```ruby
# good
class ExampleTool

  def enableVCB?
    true
  end

  def onUserText(text, view)
    # ...
  end

end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#tooluserinput](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#tooluserinput)

<a name='toolbartimer'></a>
## SketchupSuggestions/ToolbarTimer

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Wrapping `toolbar.restore` in `UI.start_timer` is redundant. It was a
workaround for an issue in a very old version of SketchUp. There is no
need to still be using this workaround.

### Examples

#### Creating a new toolbar

```ruby
# bad
toolbar = UI::Toolbar.new('Example')
# ...
toolbar.restore
UI.start_timer(0.1, false) {
  toolbar.restore
}

# good
toolbar = UI::Toolbar.new('Example')
# ...
toolbar.restore
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#toolbartimer](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#toolbartimer)
