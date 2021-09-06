# SketchupRequirements

<a name='apinamespace'></a>
## SketchupRequirements/ApiNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Do not modify the Sketch API. This will affect other extensions and
very likely cause them to fail.

This requirement also include adding things into the SketchUp API
namespace. The API namespace is reserved for future additions to the
API.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#apinamespace](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#apinamespace)

<a name='exit'></a>
## SketchupRequirements/Exit

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
SketchUp will trap `exit` and prevent that, with a message in the
console. But `exit!` is not trapped and will terminate SketchUp without
shutting down cleanly.

Use `return`, `next`, `break` or `raise` instead.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#exit](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#exit)

<a name='extensionnamespace'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#extensionnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#extensionnamespace)

<a name='filestructure'></a>
## SketchupRequirements/FileStructure

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Check that the extension conform to expected file structure with a
single root .rb file and a support folder with matching name.

Make sure to match upper and lower case characters between the root .rb
file and the support folder.

### Examples

```ruby
SketchUp/Plugins
+ ex_hello_world.rb
+ ex_hello_world
  + main.rb
  + ...
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#filestructure](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#filestructure)

<a name='geminstall'></a>
## SketchupRequirements/GemInstall

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

It's tempting to use gems in an extension. However, there are issues if
consuming them via Gem.install;

* Net::HTTP is unreliable. (SSL certificate issues, OpenSSL performance
  freeze under Windows)
* Compiled extensions cannot be installed like this as they require
  DevKit.
* While downloading and installing SketchUp freezes. (Bad thing if done
  automatically upon loading the extensions - especially without user
  notice. It's easy to think SU have stopped working)
* Version collisions. If multiple extensions want to use different
  versions of a gem they will clash if the versions aren't compatible
  with the features they use.

They only way to ensure extensions doesn't clash is to namespace
everything into extension namespace. This means making a copy of the
gem you want to use and wrap it in your own namespace.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#geminstall](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#geminstall)

<a name='getextensionlicense'></a>
## SketchupRequirements/GetExtensionLicense

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
SketchUp will trap `exit` and prevent that, with a message in the
console. But `exit!` is not trapped and with terminate SketchUp without
shutting down cleanly.

Use `return`, `next`, `break` or `raise` instead.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#getextensionlicense](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#getextensionlicense)

<a name='globalconstants'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalconstants](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalconstants)

<a name='globalinclude'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalinclude](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalinclude)

<a name='globalmethods'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalmethods](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalmethods)

<a name='globalvariables'></a>
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

Note that backreferences like `$1`, `$2`, etc are not global variables.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalvariables](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#globalvariables)

<a name='languagehandlerglobals'></a>
## SketchupRequirements/LanguageHandlerGlobals

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid using globals in general, but especially these which are known to
be in use by other extensions made by SketchUp.
They are still in use due to compatibility reasons.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#languagehandlerglobals](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#languagehandlerglobals)

<a name='loadpath'></a>
## SketchupRequirements/LoadPath

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Do not modify the load path. Modifying `$LOAD_PATH` is bad practice
because it can cause extensions to inadvertently load the wrong file.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#loadpath](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#loadpath)

<a name='minimalregistration'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#minimalregistration](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#minimalregistration)

<a name='observersstartoperation'></a>
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

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#observersstartoperation](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#observersstartoperation)

<a name='registerextension'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#registerextension](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#registerextension)

<a name='rubycorenamespace'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#rubycorenamespace](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#rubycorenamespace)

<a name='rubystdlibnamespace'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#rubystdlibnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#rubystdlibnamespace)

<a name='shippedextensionsnamespace'></a>
## SketchupRequirements/ShippedExtensionsNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't modify SketchUp's shipped extensions.

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#shippedextensionsnamespace](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#shippedextensionsnamespace)

<a name='sketchupextension'></a>
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

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#sketchupextension](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#sketchupextension)

<a name='sketchuprequire'></a>
## SketchupRequirements/SketchupRequire

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Omit file extensions when using `Sketchup.require` to allow encrypted
files to be loaded.

Ruby C extensions, `.so`/`.bundle` libraries must always be loaded via
the normal `require`.

### Examples

#### Bad - This will fail if extension is encrypted

```ruby
Sketchup.require 'hello/world.rb'
```
#### Good - This will work for `.rbe`, `.rbs` and `rb` files.

```ruby
Sketchup.require 'hello/world'
```
#### Bad - This will fail if extension is encrypted

```ruby
extension = SketchupExtension.new("Example", "Example/main.rb")
```
#### Good - This will work for `.rbe`, `.rbs` and `rb` files.

```ruby
extension = SketchupExtension.new("Example", "Example/main")
```

### References

* [https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#sketchuprequire](https://github.com/SketchUp/rubocop-sketchup/tree/main/manual/cops_requirements.md#sketchuprequire)
