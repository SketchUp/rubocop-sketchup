# Cops

In RuboCop lingo the various checks performed on the code are called cops.
Each cop is responsible for detecting one particular offense. There are several
cop departments, grouping the cops by class of offense. A short description of
the different departments is provided below.

Read more about RuboCop's [cops and departments](https://docs.rubocop.org/en/latest/cops/).

## SketchUp's Cops and Departments

`rubocop-sketchup` adds new departments and cops that are specific to extension development for SketchUp.

All cops are located under [`lib/rubocop/sketchup`](lib/rubocop/sketchup), and contain examples/documentation.

### SketchupRequirements

`SketchupRequirements` is the most important department. This one checks for the technical requirements that extensions need to meet in order to be hosted on Extension Warehouse. Address flagged issues from this department as soon as possible.

Note that the complete technical requirements for Extension Warehouse is not fully covered by these cops. But they get you a long way if you pass their control.

### SketchupDeprecations

`SketchupDeprecations` is also an important department. Not rejection cause at Extension Warehouse, but worth paying attention to as it describe features of the API we would like to discourage the use of. Eventually some of them might be removed.

### SketchupPerformance

`SketchupPerformance` looks for common issues that impact performance. It's highly recommended to review what these cops report and evaluate if there are improvements that can be made to your extension.

### SketchupSuggestions

`SketchupSuggestions` might be the more noisy of the departments. These are more general gentle suggestions for common improvements to raise the quality of your extension and source code. No need to address everything this reports, evaluate to the context of your extension. In general this department will be a collection of established best practices.

### Available cops

In the following section you find all available cops:

<!-- START_COP_LIST -->
#### Department [SketchupDeprecations](cops_deprecations.md)

* [SketchupDeprecations/AddSeparatorToMenu](cops_deprecations.md#sketchupdeprecationsaddseparatortomenu)
* [SketchupDeprecations/OperationNextTransparent](cops_deprecations.md#sketchupdeprecationsoperationnexttransparent)
* [SketchupDeprecations/RequireAll](cops_deprecations.md#sketchupdeprecationsrequireall)
* [SketchupDeprecations/SetTextureProjection](cops_deprecations.md#sketchupdeprecationssettextureprojection)
* [SketchupDeprecations/ShowRubyPanel](cops_deprecations.md#sketchupdeprecationsshowrubypanel)
* [SketchupDeprecations/SketchupSet](cops_deprecations.md#sketchupdeprecationssketchupset)

#### Department [SketchupPerformance](cops_performance.md)

* [SketchupPerformance/OpenSSL](cops_performance.md#sketchupperformanceopenssl)
* [SketchupPerformance/OperationDisableUI](cops_performance.md#sketchupperformanceoperationdisableui)
* [SketchupPerformance/SelectionBulkChanges](cops_performance.md#sketchupperformanceselectionbulkchanges)
* [SketchupPerformance/TypeCheck](cops_performance.md#sketchupperformancetypecheck)
* [SketchupPerformance/Typename](cops_performance.md#sketchupperformancetypename)

#### Department [SketchupRequirements](cops_requirements.md)

* [SketchupRequirements/ApiNamespace](cops_requirements.md#sketchuprequirementsapinamespace)
* [SketchupRequirements/Exit](cops_requirements.md#sketchuprequirementsexit)
* [SketchupRequirements/ExtensionNamespace](cops_requirements.md#sketchuprequirementsextensionnamespace)
* [SketchupRequirements/FileStructure](cops_requirements.md#sketchuprequirementsfilestructure)
* [SketchupRequirements/GemInstall](cops_requirements.md#sketchuprequirementsgeminstall)
* [SketchupRequirements/GetExtensionLicense](cops_requirements.md#sketchuprequirementsgetextensionlicense)
* [SketchupRequirements/GlobalConstants](cops_requirements.md#sketchuprequirementsglobalconstants)
* [SketchupRequirements/GlobalInclude](cops_requirements.md#sketchuprequirementsglobalinclude)
* [SketchupRequirements/GlobalMethods](cops_requirements.md#sketchuprequirementsglobalmethods)
* [SketchupRequirements/GlobalVariables](cops_requirements.md#sketchuprequirementsglobalvariables)
* [SketchupRequirements/LanguageHandlerGlobals](cops_requirements.md#sketchuprequirementslanguagehandlerglobals)
* [SketchupRequirements/LoadPath](cops_requirements.md#sketchuprequirementsloadpath)
* [SketchupRequirements/MinimalRegistration](cops_requirements.md#sketchuprequirementsminimalregistration)
* [SketchupRequirements/ObserversStartOperation](cops_requirements.md#sketchuprequirementsobserversstartoperation)
* [SketchupRequirements/RegisterExtension](cops_requirements.md#sketchuprequirementsregisterextension)
* [SketchupRequirements/RubyCoreNamespace](cops_requirements.md#sketchuprequirementsrubycorenamespace)
* [SketchupRequirements/RubyStdLibNamespace](cops_requirements.md#sketchuprequirementsrubystdlibnamespace)
* [SketchupRequirements/ShippedExtensionsNamespace](cops_requirements.md#sketchuprequirementsshippedextensionsnamespace)
* [SketchupRequirements/SketchupExtension](cops_requirements.md#sketchuprequirementssketchupextension)
* [SketchupRequirements/ToolbarRestore](cops_requirements.md#sketchuprequirementstoolbarrestore)

#### Department [SketchupSuggestions](cops_suggestions.md)

* [SketchupSuggestions/AddGroup](cops_suggestions.md#sketchupsuggestionsaddgroup)
* [SketchupSuggestions/Compatibility](cops_suggestions.md#sketchupsuggestionscompatibility)
* [SketchupSuggestions/DynamicComponentInternals](cops_suggestions.md#sketchupsuggestionsdynamiccomponentinternals)
* [SketchupSuggestions/FileEncoding](cops_suggestions.md#sketchupsuggestionsfileencoding)
* [SketchupSuggestions/ModelEntities](cops_suggestions.md#sketchupsuggestionsmodelentities)
* [SketchupSuggestions/MonkeyPatchedApi](cops_suggestions.md#sketchupsuggestionsmonkeypatchedapi)
* [SketchupSuggestions/OperationName](cops_suggestions.md#sketchupsuggestionsoperationname)
* [SketchupSuggestions/SketchupFindSupportFile](cops_suggestions.md#sketchupsuggestionssketchupfindsupportfile)
* [SketchupSuggestions/SketchupRequire](cops_suggestions.md#sketchupsuggestionssketchuprequire)
* [SketchupSuggestions/ToolbarTimer](cops_suggestions.md#sketchupsuggestionstoolbartimer)

<!-- END_COP_LIST -->
