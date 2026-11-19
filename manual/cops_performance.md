# SketchupPerformance

<a name='operationdisableui'></a>
## SketchupPerformance/OperationDisableUI

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Operations should disable the UI for performance gain.

This cop is disabled by default because disabling the UI is not always
desirable, for example for small or interactive operations.

### Examples

```ruby
model = Sketchup.active_model
model.start_operation('Operation Name', true)
# <model changes>
model.commit_operation
```

<a name='selectionbulkchanges'></a>
## SketchupPerformance/SelectionBulkChanges

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Prefer changing selection in bulk instead of modifying selection within
loops. It's much faster to change the selection in bulk. UI updates are
triggered when you update the selection, so reduce the amount of calls.

### Examples

#### Poor performance

```ruby
model = Sketchup.active_model
model.active_entities.each { |entity|
  model.selection.add(entity) if entity.is_a?(Sketchup::Face)
}
```
#### Better performance

```ruby
model = Sketchup.active_model
faces = model.active_entities.map { |entity|
  entity.is_a?(Sketchup::Face)
}
model.selection.add(faces)
```
#### Better performance and simpler

```ruby
model = Sketchup.active_model
faces = model.active_entities.grep(Sketchup::Face)
model.selection.add(faces)
```

<a name='typecheck'></a>
## SketchupPerformance/TypeCheck

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

String comparisons for type checks are very slow.

`entity.class.name == 'Sketchup::Face'` is slow because it performs a
string comparison. `is_a?` is much faster because it's a simple type
check.

If you know you need a strict type check, compare the classes directly:
`entity.class == Sketchup::Face`.

### Examples

#### Poor performance

```ruby
entity.class.name == 'Sketchup::Face'
```
#### Good performance

```ruby
entity.class == Sketchup::Face
```
#### Good performance and idiomatic Ruby convention

```ruby
entity.is_a?(Sketchup::Face)
```

<a name='typename'></a>
## SketchupPerformance/Typename

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

`.typename` is very slow, prefer `.is_a?` instead.

`entity.typename == 'Face'` is slow because it performs a string
comparison. `is_a?` is much faster because it's a simple type check.
