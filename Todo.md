# Todo

## Suggestion Cops

### Don't hard code file extensions in `require`

SketchUp will automatically resolve a file's extension to .rb, .rbs or .rbe.

### Avoid `Sketchup.find_support_file`

Some users might manage extensions manually or via third party extension
managers. In these cases using `Sketchup.find_support_file` will fail to
resolve the path to the files. Prefer using `__FILE__` or `__dir__` to resolve
files relative to the current file.

### Beware encoding bugs in `__FILE__` and `__dir__`

Ruby under Windows doesn't provide the correct encoding for these trings.
You may experience encoding errors if you try to mix these string with other
strings. To work around this use `.force_encoding('UTF-8')`

### SketchUp compatibility

We can use YARD to provide lists of new features in each SketchUp version.
Developers can then declare minimum compatibilty and have RuboCop validate
against it. Similar to how RuboCop already can check Ruby compatibilty.
