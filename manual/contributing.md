# Issues

Report issues and suggest features and improvements on the
[GitHub issue tracker](https://github.com/sketchup/rubocop-sketchup/issues).

If you want to file a bug, please provide all the necessary info listed in
our issue reporting template (it's loaded automatically when you create a
new GitHub issue).

# Patches

Patches in any form are always welcome! GitHub pull requests are even better! :)

Before submitting a patch or a pull request make sure all tests are
passing and that your patch is in line with the [contribution
guidelines](https://github.com/sketchup/rubocop-sketchup/blob/main/CONTRIBUTING.md).
Also see the [Development section](development.md).

# Documentation

Good documentation is just as important as good code. Check out the
[Documentation section](development.md#documentation) of this guide and consider
adding or improving Cop descriptions.

## Working on the Manual

The manual is generated from the markdown files in the
[doc](https://github.com/sketchup/rubocop-sketchup/tree/main/manual) folder of RuboCop's
GitHub repo and is published to [Read the Docs](https://readthedocs.org/). The
[MkDocs](https://www.mkdocs.org/) tool is used to convert the markdown sources to
HTML.

To make changes to the manual you simply have to change the files under
`manual`. The manual will be regenerated automatically when changes to those files
are merged in `main` (or the latest stable branch).

You can install `MkDocs` locally and use the command `mkdocs serve` to see the
result of changes you make to the manual locally:

```
$ cd path/to/rubocop-sketchup/repo
$ mkdocs serve
```

If you want to make changes to the manual's page structure you'll have to edit
[mkdocs.yml](https://github.com/sketchup/rubocop-sketchup/blob/main/mkdocs.yml).
