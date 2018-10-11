# SketchupPerformance

## SketchupPerformance/OpenSSL

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

There are performance issue with the OpenSSL library that Ruby ship. In
a clean SU session, default model there is a small delay observed in the
Windows version of SU.

But with a larger model loaded, or session that have had larger files
loaded the lag will be minutes.

`SecureRandom` is  also affected by this, as it uses OpenSSL to seed.

It also affects Net::HTTP if making HTTPS connections.

## SketchupPerformance/OperationDisableUI

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Weak warning. (Question?)

## SketchupPerformance/SelectionBulkChanges

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid modifying the selection set within loops. It's much faster to
change the selection in bulk.

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

## SketchupPerformance/Typename

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation
