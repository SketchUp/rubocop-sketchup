## Cops

In RuboCop lingo the various checks performed on the code are called cops.
Each cop is responsible for detecting one particular offense. There are several
cop departments, grouping the cops by class of offense. A short description of
the different departments is provided below.

Many of the Style and Layout cops have configuration options, allowing them to
enforce different coding conventions.

You can also load [custom cops](extensions.md#custom-cops).

### Style

Style cops check for stylistic consistency of your code. Many of the them are
based on the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).

### Layout

Layout cops inspect your code for consistent use of indentation, alignment,
and white space.

### Lint

Lint cops check for ambiguities and possible errors in your code.

RuboCop implements, in a portable way, all built-in MRI lint checks
(`ruby -wc`) and adds a lot of extra lint checks of its own.

You can run only the Lint cops like this:

```sh
$ rubocop -l
```

The `-l`/`--lint` option can be used together with `--only` to run all the
enabled Lint cops plus a selection of other cops.

Disabling Lint cops is generally a bad idea.

### Metrics

Metrics cops deal with properties of the source code that can be measured,
such as class length, method length, etc. Generally speaking, they have a
configuration parameter called `Max` and when running
`rubocop --auto-gen-config`, this parameter will be set to the highest value
found for the inspected code.

### Naming

Naming cops check for naming issue of your code, such as method name, constant
name, file name, etc.

### Performance

Performance cops catch Ruby idioms which are known to be slower than another,
semantically equivalent idiom.

### Security

Security cops checks for method calls and constructs which are known to be
associated with potential security issues.

### Rails

Rails cops are specific to the Ruby on Rails framework. Unlike all other cop
types they are not used by default, and you have to request them explicitly:

```sh
$ rubocop -R
```

or add the following directive to your `.rubocop.yml`:

```yaml
Rails:
  Enabled: true
```

### Bundler

Bundler cops check for style or bad practices in Bundler files, e.g. `Gemfile`.

### Gemspec

Gemspec cops check for style or bad practices in gemspec files, e.g. `rubocop.gemspec`.

### Available cops

In the following section you find all available cops:

<!-- START_COP_LIST -->
#### Department [SketchupDeprecations](cops_sketchupdeprecations.md)

* [SketchupDeprecations/AddSeparatorToMenu](cops_sketchupdeprecations.md#sketchupdeprecationsaddseparatortomenu)
* [SketchupDeprecations/OperationNextTransparent](cops_sketchupdeprecations.md#sketchupdeprecationsoperationnexttransparent)
* [SketchupDeprecations/RequireAll](cops_sketchupdeprecations.md#sketchupdeprecationsrequireall)
* [SketchupDeprecations/SetTextureProjection](cops_sketchupdeprecations.md#sketchupdeprecationssettextureprojection)
* [SketchupDeprecations/ShowRubyPanel](cops_sketchupdeprecations.md#sketchupdeprecationsshowrubypanel)
* [SketchupDeprecations/SketchupSet](cops_sketchupdeprecations.md#sketchupdeprecationssketchupset)

#### Department [SketchupPerformance](cops_sketchupperformance.md)

* [SketchupPerformance/OpenSSL](cops_sketchupperformance.md#sketchupperformanceopenssl)
* [SketchupPerformance/OperationDisableUI](cops_sketchupperformance.md#sketchupperformanceoperationdisableui)
* [SketchupPerformance/SelectionBulkChanges](cops_sketchupperformance.md#sketchupperformanceselectionbulkchanges)
* [SketchupPerformance/Typename](cops_sketchupperformance.md#sketchupperformancetypename)

#### Department [SketchupRequirements](cops_sketchuprequirements.md)

* [SketchupRequirements/ApiNamespace](cops_sketchuprequirements.md#sketchuprequirementsapinamespace)
* [SketchupRequirements/Exit](cops_sketchuprequirements.md#sketchuprequirementsexit)
* [SketchupRequirements/ExtensionNamespace](cops_sketchuprequirements.md#sketchuprequirementsextensionnamespace)
* [SketchupRequirements/FileStructure](cops_sketchuprequirements.md#sketchuprequirementsfilestructure)
* [SketchupRequirements/GlobalConstants](cops_sketchuprequirements.md#sketchuprequirementsglobalconstants)
* [SketchupRequirements/GlobalInclude](cops_sketchuprequirements.md#sketchuprequirementsglobalinclude)
* [SketchupRequirements/GlobalMethods](cops_sketchuprequirements.md#sketchuprequirementsglobalmethods)
* [SketchupRequirements/GlobalVariables](cops_sketchuprequirements.md#sketchuprequirementsglobalvariables)
* [SketchupRequirements/LanguageHandlerGlobals](cops_sketchuprequirements.md#sketchuprequirementslanguagehandlerglobals)
* [SketchupRequirements/LoadPath](cops_sketchuprequirements.md#sketchuprequirementsloadpath)
* [SketchupRequirements/MinimalRegistration](cops_sketchuprequirements.md#sketchuprequirementsminimalregistration)
* [SketchupRequirements/ObserversStartOperation](cops_sketchuprequirements.md#sketchuprequirementsobserversstartoperation)
* [SketchupRequirements/RegisterExtension](cops_sketchuprequirements.md#sketchuprequirementsregisterextension)
* [SketchupRequirements/RubyCoreNamespace](cops_sketchuprequirements.md#sketchuprequirementsrubycorenamespace)
* [SketchupRequirements/RubyStdLibNamespace](cops_sketchuprequirements.md#sketchuprequirementsrubystdlibnamespace)
* [SketchupRequirements/ShippedExtensionsNamespace](cops_sketchuprequirements.md#sketchuprequirementsshippedextensionsnamespace)
* [SketchupRequirements/SketchupExtension](cops_sketchuprequirements.md#sketchuprequirementssketchupextension)

#### Department [SketchupSuggestions](cops_sketchupsuggestions.md)

* [SketchupSuggestions/Compatibility](cops_sketchupsuggestions.md#sketchupsuggestionscompatibility)
* [SketchupSuggestions/DynamicComponentInternals](cops_sketchupsuggestions.md#sketchupsuggestionsdynamiccomponentinternals)
* [SketchupSuggestions/FileEncoding](cops_sketchupsuggestions.md#sketchupsuggestionsfileencoding)
* [SketchupSuggestions/ModelEntities](cops_sketchupsuggestions.md#sketchupsuggestionsmodelentities)
* [SketchupSuggestions/MonkeyPatchedApi](cops_sketchupsuggestions.md#sketchupsuggestionsmonkeypatchedapi)
* [SketchupSuggestions/OperationName](cops_sketchupsuggestions.md#sketchupsuggestionsoperationname)
* [SketchupSuggestions/SketchupFindSupportFile](cops_sketchupsuggestions.md#sketchupsuggestionssketchupfindsupportfile)
* [SketchupSuggestions/SketchupRequire](cops_sketchupsuggestions.md#sketchupsuggestionssketchuprequire)

<!-- END_COP_LIST -->
