# SketchupSuggestions

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

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Details | `When using `__FILE__` and `__dir__`, beware that Ruby doesn't apply the correct encoding to the strings under Windows. When they contain non-english characters it will lead to exceptions being raised when the strings are used. Force encoding to work around this.` | String

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#fileencoding](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#fileencoding)

## SketchupSuggestions/ModelEntities

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Prefer `model.active_entities` over `model.entities`.

Most tools/actions act upon the active entities context. This could be
an opened group or component instance. Because of this, prefer
`model.active_entities` by default over `model.entities` unless you
have an explicit reason to work in the root model context.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Details | `In SketchUp the norm is that editing is performed in the opened instance (`model.active_entities`). `model.entities` refer to the model root.` | String

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#modelentities](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#modelentities)

## SketchupSuggestions/MonkeyPatchedApi

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Some of the shipped extensions in SketchUp monkey-patch the API
namespace. This is an unfortunate no-no that was done a long time ago
before the extension best-practices were established. These functions
might change or be removed at any time. They will also not work when
the extensions are disabled. Avoid using these methods.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Details | `These methods stops working when the extensions are disabled and may change or be removed.` | String

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#monkeypatchedapi](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#monkeypatchedapi)

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
Details | `This check is very naive and might produce false positives. Use as guidance only.` | String
Max | `25` | Integer

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#operationname](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#operationname)

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

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Details | `Extensions might be installed outside the SketchUp Plugins folder. Use `__FILE__` and `__dir__` to locate your files relative to the executing file.` | String

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchupfindsupportfile](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchupfindsupportfile)

## SketchupSuggestions/SketchupRequire

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Omit file extensions when using `Sketchup.require` to allow encrypted
files to be loaded.

### Examples

#### Bad - This will fail if extension is encrypted

```ruby
Sketchup.require 'hello/world.rb'
```
#### Good - This will work for `.rbe`, `.rbs` and `rb` files.

```ruby
Sketchup.require 'hello/world'
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchuprequire](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_suggestions.md#sketchuprequire)
