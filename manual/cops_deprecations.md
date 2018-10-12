# SketchupDeprecations

## SketchupDeprecations/AddSeparatorToMenu

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid adding separators to top level menus. If you require grouping use
a sub-menu instead.

## SketchupDeprecations/OperationNextTransparent

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

If set to true, then whatever operation comes after this one will be
appended into one combined operation, allowing the user the undo both
actions with a single undo command.

This flag is a highly difficult one, since there are so many ways that a
SketchUp user can interrupt a given operation with one of their own.

Only use this flag if you have no other option, for instance to work
around bug in how `Sketchup::Model#place_component` starts operations.

## SketchupDeprecations/RequireAll

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Method is deprecated because it adds the given path to `$LOAD_PATH`.
Modifying `$LOAD_PATH` is bad practice because it can cause extensions
to inadvertently load the wrong file.

## SketchupDeprecations/SetTextureProjection

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Method is deprecated because it creates invalid UV mapping. Saving the
model will display a dialog indicating that the model needs to be
repaired. Once repaired the UV mapping will visually change.

## SketchupDeprecations/ShowRubyPanel

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Method is deprecated. Use `SKETCHUP_CONSOLE.show` instead.

## SketchupDeprecations/SketchupSet

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

From SketchUp 6 until SketchUp 2013 the SketchUp API shipped with a
`Set` class. When SketchUp started shipping with the Ruby StdLib in
SketchUp 2014 the class was changed from `Set` to `Sketchup::Set` in
order to avoid conflict with the Ruby Standard Library.

The `Sketchup::Set` class is much slower than Ruby's own `Set` class
and less versatile.
