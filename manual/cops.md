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
