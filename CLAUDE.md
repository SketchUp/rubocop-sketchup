# rubocop-sketchup

RuboCop extension for SketchUp extension development, published to RubyGems as
[`rubocop-sketchup`](https://rubygems.org/gems/rubocop-sketchup).

## Branches

- Name new branches `dev/<short-description>`, for example
  `dev/sketchup-2028-features`.
- Branch from the latest `origin/main`.

## Keeping history linear

`main` has a linear history: no merge commits.

- To bring a branch up to date, rebase it onto `main` instead of merging
  `main` into it:

  ```
  git fetch origin
  git rebase origin/main
  git push --force-with-lease
  ```

  Only force-push your own `dev/` branches, never `main`.
- Clean up fixup commits before merging, so each commit on the branch is a
  meaningful change (see [CONTRIBUTING.md](CONTRIBUTING.md)).
- Merge pull requests with **Rebase and merge**, or **Squash and merge** when
  the branch's commits aren't worth keeping separately. Never create merge
  commits.
- Delete the branch after merging. After a squash merge its commits aren't on
  `main`, so continuing work on it leads to conflicts.

## Checks

`bundle exec rake` regenerates the cop documentation (`manual/` and
`config/default.yml`), then runs the specs and RuboCop on the project itself.
Run it before opening a pull request, and commit any files it regenerates
along with the change. CI runs `bundle exec rake ci`, which is the specs and
RuboCop only.
