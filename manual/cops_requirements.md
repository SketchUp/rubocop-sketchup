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

## SketchupRequirements/Exit

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't attempt to kill the Ruby interpreter by calling `exit` or `exit!`.
SketchUp will trap `exit` and prevent that, with a message in the
console. But `exit!` is not trapped and with terminate SketchUp without
shutting down cleanly.
Use `return`, `next` or `break` instead.

## SketchupRequirements/ExtensionNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

### Configurable attributes

Name | Default value | Configurable values
--- | --- | ---
Exceptions | `[]` | Array

## SketchupRequirements/FileStructure

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Check that the extension conform to expected file structure with a
single root .rb file and a support folder with matching name.

## SketchupRequirements/GlobalConstants

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/GlobalInclude

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/GlobalMethods

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/GlobalVariables

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

This cops looks for uses of global variables.
It does not report offenses for built-in global variables.
Built-in global variables are allowed by default. Additionally
users can allow additional variables via the AllowedVariables option.

Note that backreferences like $1, $2, etc are not global variables.

## SketchupRequirements/LanguageHandlerGlobals

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Avoid using globals in general, but  especially these which are known to
be in use by other extensions made by SketchUp.
They are still in use due to compatibility reasons.

## SketchupRequirements/LoadPath

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/MinimalRegistration

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't load extension files in the root file registering the extension.
Extensions should not load additional files when it's disabled.

## SketchupRequirements/ObserversStartOperation

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/RegisterExtension

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Always register extensions to load by default. Otherwise it might
confuse users to think the extension isn't working.

## SketchupRequirements/RubyCoreNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/RubyStdLibNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

No documentation

## SketchupRequirements/ShippedExtensionsNamespace

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Don't modify SketchUp's shipped extensions.

## SketchupRequirements/SketchupExtension

Enabled by default | Supports autocorrection
--- | ---
Enabled | No

Register a single instance of SketchupExtension per extension.
This should be done by the root .rb file in the extension package.
