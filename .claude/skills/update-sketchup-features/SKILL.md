---
name: update-sketchup-features
description: Updates rubocop-sketchup for a new SketchUp/LayOut release - pastes the YARD rubocop-changelog into FEATURES, updates VALID_VERSIONS, and curates INSTANCE_METHODS and OBSERVER_METHODS with the judgement needed to avoid false positives. Use when updating features.rb or sketchup_version.rb, adding a new SketchUp or LayOut version, or processing rubocop-changelog.txt.
---

# Update rubocop-sketchup for a new SketchUp version

Files: `lib/rubocop/sketchup/features.rb` (`FEATURES`, `INSTANCE_METHODS`,
`OBSERVER_METHODS`) and `lib/rubocop/sketchup/sketchup_version.rb`
(`VALID_VERSIONS`). The `Compatibility` cop
(`lib/rubocop/sketchup/cop/suggestions/compatibility.rb`) consumes them.

The mechanical part (FEATURES, VALID_VERSIONS) is copy-and-prune. The part
that needs judgement is choosing method names for `INSTANCE_METHODS`. Do the
mechanical part, run the triage script, then make and **explain** the
judgement calls so a human can review them.

## Workflow

```
- [ ] 1. Get rubocop-changelog.txt and the versions list
- [ ] 2. Update VALID_VERSIONS
- [ ] 3. Paste new FEATURES blocks, prune unreleased versions
- [ ] 4. Run triage script
- [ ] 5. Curate INSTANCE_METHODS / OBSERVER_METHODS
- [ ] 6. bundle exec rake
- [ ] 7. Report decisions for review
```

### 1. Inputs

Generated in a `ruby-api-stubs` checkout that matches the release (ask the
user for it if `rubocop-changelog.txt` in the repo root is empty or missing):

```sh
yardoc -t versions -f text                                    # all versions
yardoc -c -t rubocop-changelog -f text > rubocop-changelog.txt # FEATURES shape
```

Ask the user which versions have **actually shipped**. Never infer it from
the changelog: YARD lists versions that are tagged but not yet released.

### 2. VALID_VERSIONS

Add `[version, maintenance]` entries, e.g. `[2027.0, 0]`, `[2025.0, 2]` for
`SketchUp 2025.0.2`. LayOut labels are parsed as SketchUp versions, so a
LayOut-only version (e.g. `LayOut 2026.2`) also needs an entry.

Insert by version, not at the top. LayOut ships separately, so its versions
can be numbered at or below the current newest entry. This applies to
`FEATURES` too. `SketchUpVersion#succ` relies on the order, so an entry out
of place makes it return the wrong version.

### 3. FEATURES

Copy every version block whose `version:` label isn't in `FEATURES` yet,
keeping the generated shape and the blank line between blocks, in version
order. Drop blocks for unreleased versions. Never edit or remove existing
blocks. Every `version:` label must have a `VALID_VERSIONS` entry.

### 4. Triage

From the repo root, pass every version label you just added:

```sh
ruby .claude/skills/update-sketchup-features/scripts/triage_methods.rb \
  'SketchUp 2027.0' 'LayOut 2027.0' [--stubs path/to/ruby-api-stubs/lib/sketchup-api-stubs/stubs]
```

It defaults to the installed `sketchup-api-stubs` gem; prefer `--stubs` with
the same checkout that produced the changelog. If it warns that the stubs
look older than the release, rerun with `--stubs` before trusting the
verdicts. Verdicts:

| Verdict | Action |
|---|---|
| `REMOVE` | Existing `INSTANCE_METHODS` entry that collides. Remove it and say so. |
| `observer` | Add to `OBSERVER_METHODS`. |
| `candidate` | Unique name. Add unless a rule below says otherwise. |
| `review` | Single-word name. Apply the rules below. |
| `exclude` | Ruby core method, operator, constructor, or the name already exists on an older API class. Don't add. |
| `present` | Already listed. Nothing to do. |

The script only checks collisions with Ruby core and the SketchUp API. It
cannot judge how common a name is in general extension code; that is step 5.

### 5. Curate: the judgement

**Why it matters.** The cop can't infer receiver types, so a name in
`INSTANCE_METHODS` is matched on *any* call `foo.name(...)` and reported as
the newest feature ending in `#name`. One bad name = a false positive on
every extension targeting an older version. A missing name = a missed
warning. False positives are worse: they train users to disable the cop.

**Never add:**
- Ruby core/stdlib names (`dup`, `each`, `size`, `name`, `to_s`, `write`, `push`).
- `initialize` and operators (`==`, `[]`). Calls to them never look like `x.initialize`.
- Names that already exist on an older SketchUp/LayOut class (`get_attribute`
  on `Layout::Entity` would flag every `Sketchup::Entity#get_attribute` call).
- Module functions (`UI.show_extension_warehouse`, `Sketchup.mdi?`). Calls with a
  constant receiver are already checked against `FEATURES` directly.

**Judge (`review`, and `candidate` names that read like plain English):**
Would an extension author plausibly define or call this name on their own
objects? Exclude words like `run`, `validate`, `font`, `duplicate`,
`conversion`, `thumbnail`, `environment`. Keep words that are domain-specific
to SketchUp (`eastings`, `northings`, `workflow`). When unsure, leave it out
and flag it.

**Callback methods** (methods the extension *defines* and SketchUp calls,
e.g. `Sketchup::Procedure#run`, `#on_button_clicked`): `INSTANCE_METHODS`
only checks calls, so adding them has no effect. Don't add them. Only
`*Observer` classes go into `OBSERVER_METHODS`, which checks `def`.

**Setter/query pairs:** add `foo` and `foo=` (or `foo?`) together, or neither.

Keep both lists in alphabetical order.

### 6. Verify

```sh
bundle exec rake
git diff
```

The diff must contain only additions in `FEATURES`/`VALID_VERSIONS`, plus
the curated list changes.

### 7. Report

End with this so the reviewer can check each judgement call quickly:

```markdown
## rubocop-sketchup update: <versions>

Added to INSTANCE_METHODS: <names>
Added to OBSERVER_METHODS: <names>
Removed (collisions): <name>: <reason>
Excluded after review: <name>: <one-line reason>
Unsure, needs a human decision: <name>: <the trade-off>
Pruned as unreleased: <version labels>
```

## Worked examples

From the 2025.0 to 2026.1 update (Thomas Thomassen):
- Added: Material PBR accessors (`roughness_factor=`, `ao_texture`), Environment
  accessors (`skydome_exposure`, `use_for_reflections?`), `device_height`.
- Added to OBSERVER_METHODS: `onEnvironmentAdd`, `onScaleFactorChange`.
- Excluded: all `Layout::Dictionary` methods (Hash-like names) and the LayOut
  attribute methods (`get_attribute`, `set_attribute`: they exist on `Sketchup::Entity`).
- Excluded: `Environment#name`, `#path`, `#description`, `#thumbnail`, `Snap#up`, `#set`.

From the 2026.2 to 2027.0 update, review found two mistakes:
- `dup` (`HatchPatternData#dup`) and `initialize` were added. Both should be
  removed: every `.dup` call would be reported as a 2027.0 feature.
- `manifold?`, `bounds`, `clip_mask`, `fill_color` were correctly left out
  (older classes already have them).
