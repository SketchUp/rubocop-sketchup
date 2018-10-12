# SketchupRequirements

## SketchupRequirements/ApiNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Do not modify the Sketch API. This will affect other extensions and
very likely cause them to fail.

This requirement also include adding things into the SketchUp API
namespace. The API namespace is reserved for future additions to the
API.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#apinamespace](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#apinamespace)

## SketchupRequirements/Exit

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
SketchUp will trap `exit` and prevent that, with a message in the
console. But `exit!` is not trapped and with terminate SketchUp without
shutting down cleanly.

Use `return`, `next`, `break` or `raise` instead.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#exit](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#exit)

## SketchupRequirements/ExtensionNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to use only one
root module.

### Examples

#### Good - this contains everything in the extension.

```ruby
module MyExtension
  class Foo
  end
  class Bar
  end
end
```
#### Better - this further reduce chance of clashing.

```ruby
module MyCompany
  module MyExtension
    class Foo
    end
    class Bar
    end
  end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Exceptions | `[]` | Array

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#extensionnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#extensionnamespace)

## SketchupRequirements/FileStructure

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Check that the extension conform to expected file structure with a
single root .rb file and a support folder with matching name.

### Examples

```ruby
SketchUp/Plugins
+ ex_hello_world.rb
+ ex_hello_world
  + main.rb
  + ...
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#filestructure](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#filestructure)

## SketchupRequirements/GlobalConstants

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not define
global constants.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalconstants](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalconstants)

## SketchupRequirements/GlobalInclude

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not pollute
the global namespace by including mix-in modules.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalinclude](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalinclude)

## SketchupRequirements/GlobalMethods

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not define
global methods.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalmethods](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalmethods)

## SketchupRequirements/GlobalVariables

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not define
global variables.

This cops looks for uses of global variables.
It does not report offenses for built-in global variables.
Built-in global variables are allowed by default. Additionally
users can allow additional variables via the AllowedVariables option.

Note that backreferences like $1, $2, etc are not global variables.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalvariables](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#globalvariables)

## SketchupRequirements/LanguageHandlerGlobals

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid using globals in general, but especially these which are known to
be in use by other extensions made by SketchUp.
They are still in use due to compatibility reasons.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#languagehandlerglobals](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#languagehandlerglobals)

## SketchupRequirements/LoadPath

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Do not modify the load path. Modifying `$LOAD_PATH` is bad practice
because it can cause extensions to inadvertently load the wrong file.

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#loadpath](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#loadpath)

## SketchupRequirements/MinimalRegistration

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't load extension files in the root file registering the extension.
Extensions should not load additional files when it's disabled.

### Examples

#### Bad - Extension will always load.

```ruby
module Example
  require 'example/main' # BAD! This will load even when extension
                         #      is disabled.
  unless file_loaded?(__FILE__)
    extension = SketchupExtension.new('Hello World', 'example/main')
    Sketchup.register_extension(extension, true)
    file_loaded(__FILE__)
  end
end
```
#### Good - Extension doesn't load anything unless its enabled.

```ruby
module Example
  unless file_loaded?(__FILE__)
    extension = SketchupExtension.new('Hello World', 'example/main')
    Sketchup.register_extension(extension, true)
    file_loaded(__FILE__)
  end
end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#minimalregistration](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#minimalregistration)

## SketchupRequirements/ObserversStartOperation

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Observers that perform model changes must create transparent operations
to ensure the user can easily undo.

An important part of SketchUp's user experience is to be able to easily
undo any modification to the model. This is important to prevent
accidental loss of work.

If you for example have an observer that assigns a material to new faces
then the user would still expect to undo this in a single operation.

To achieve this, set the fourth argument in `model.start_operation` to
`true` in order to chain your observer operation to the previous
operation.

### Examples

```ruby
class ExampleObserver < Sketchup::EntitiesObserver
  def onElementAdded(entities, entity)
    return unless entity.valid?
    return unless entity.is_a?(Sketchup::Face)
    entity.model.start_operation('Paint Face', true, false, true)
    entity.material = 'red'
    entity.model.commit_operation
  end
end
```

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#observersstartoperation](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#observersstartoperation)

## SketchupRequirements/RegisterExtension

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Always register extensions to load by default. Otherwise it might
confuse users to think the extension isn't working.

### Examples

#### Good - Extension will load upon first run.

```ruby
module Example
  unless file_loaded?(__FILE__)
    extension = SketchupExtension.new('Hello World', 'example/main')
    Sketchup.register_extension(extension, true)
    file_loaded(__FILE__)
  end
end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#registerextension](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#registerextension)

## SketchupRequirements/RubyCoreNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not modify
core Ruby functionality.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#rubycorenamespace](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#rubycorenamespace)

## SketchupRequirements/RubyStdLibNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Extensions in SketchUp all share the same Ruby environment on the user's
machine. Because of this it's important that each extension isolate
itself to avoid clashing with other extensions.

Extensions submitted to Extension Warehouse is expected to not modify
Ruby StdLib functionality.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#rubystdlibnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#rubystdlibnamespace)

## SketchupRequirements/ShippedExtensionsNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't modify SketchUp's shipped extensions.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#shippedextensionsnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#shippedextensionsnamespace)

## SketchupRequirements/SketchupExtension

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Register a single instance of SketchupExtension per extension.
This should be done by the root .rb file in the extension package.

### Examples

#### Good - a single SketchupExtension is registered.

```ruby
module Example
  unless file_loaded?(__FILE__)
    extension = SketchupExtension.new('Hello World', 'example/main')
    Sketchup.register_extension(extension, true)
    file_loaded(__FILE__)
  end
end
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#sketchupextension](https://github.com/SketchUp/rubocop-sketchup/tree/master/manual/cops_requirements.md#sketchupextension)
