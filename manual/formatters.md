# Formatters

RuboCop comes with a set of different formatters that let you control how the results are presented.

If you want to output the result in machine readable JSON;

```bash
rubocop --format json --out results.json
```

The `rubocop-sketchup` gem provides a custom formatter designed for SketchUp related cops. It explains which cops to focus your attention on.

```bash
rubocop -f extension_review -o report.html
```

The report opens with a verdict. Errors and fatal findings are what get an extension rejected from Extension Warehouse, so they are listed first as "Will be rejected: 3 issues to fix", followed by a link to each cop that needs attention. If there are none it says "No issues". Warnings and conventions follow further down as suggestions for improving your code. They do not cause a rejection.

See [RuboCop's documentation](https://rubocop.readthedocs.io/en/latest/formatters/) for more examples.
