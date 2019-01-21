# SketchupBugs

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
