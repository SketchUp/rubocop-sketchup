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

See [RuboCop's documentation](https://rubocop.readthedocs.io/en/latest/formatters/) for more examples.
