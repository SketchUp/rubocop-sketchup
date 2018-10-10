# SketchupSuggestions

## SketchupSuggestions/Compatibility

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupSuggestions/DynamicComponentInternals

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Tapping into the internals of Dynamic Components is risky. It could
change at any time.

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

## SketchupSuggestions/ModelEntities

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupSuggestions/MonkeyPatchedApi

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Some of the shipped extensions in SketchUp monkey-patch the API
namespace. This is an unfortunate no-no that was done a long time ago
before the extension best-practices were established. These functions
might change or be removed at any time. They will also not work when
the extensions are disabled. Avoid using these methods.

## SketchupSuggestions/OperationName

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupSuggestions/SketchupFindSupportFile

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid Sketchup.find_support_file to find your extension's files.

## SketchupSuggestions/SketchupRequire

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Omit file extensions when using Sketchup.require to allow encrypted
files to be loaded.
