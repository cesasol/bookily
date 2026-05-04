# AGENTS.md

Guidance for AI agents working in this repo. Repo-specific facts only — generic Typst/Bash advice omitted.

## What this is

Typst package **`bookily`** (entrypoint `src/bookily.typ`, template `template/main.typ`). Fork of [`maucejo/bookly`](https://github.com/maucejo/bookly), repositioned for trade-publishing. Consumed locally — **not** published to `@preview`. Public surface centers on the `bookily(...)` show-rule.

## Toolchain

- **`typst` CLI** required on PATH. No version pin in repo; tested on 0.14.x.
- **`oxipng`** required only for the `just thumbnails` recipe.
- **`just`** is the task runner (see `justfile`).
- No CI exists (`.github/` is absent). No pre-commit hooks. Verification is manual.

## Commands

Always pass `--root .` so package-relative imports (`src/bookily.typ`) resolve. Compile from repo root.

```sh
# Compile the showcase template
typst c template/main.typ template/main.pdf --root .

# Compile the Tufte showcase
typst c template_tufte/main_tufte.typ template_tufte/main_tufte.pdf --root .

# Compile the user manual (regenerate after editing docs/manual.typ)
typst c docs/manual.typ docs/manual.pdf --root .

# Smoke tests (hidden files at repo root, only existing tests)
typst c .copilot-parity-smoke.typ /tmp/parity.pdf --root .
typst c .copilot-toc-smoke.typ    /tmp/toc.pdf    --root .
```

`just` recipes for installing the package into Typst's local registry:

| `just <recipe>`     | What it does                                                  |
|---------------------|---------------------------------------------------------------|
| `install`           | `scripts/package "@local"` — installs to `@local`             |
| `install-preview`   | `scripts/package "@preview"` — pre-release testing            |
| `uninstall`         | Removes from `@local`                                         |
| `uninstall-preview` | Removes from `@preview`                                       |
| `package <target>`  | Pack to a custom path                                         |
| `thumbnails`        | Renders `template/main.typ` → `thumbnails/{n}.png` + `oxipng` |

`scripts/package` reads `name` and `version` from `typst.toml` and respects `.typstignore` (which is **not** a standard gitignore — see warning header in the file).

## Verifying changes

When you edit anything in `src/`, **compile all five entrypoints** before claiming done:

```sh
for f in template/main.typ template_tufte/main_tufte.typ \
         .copilot-parity-smoke.typ .copilot-toc-smoke.typ docs/manual.typ; do
  typst c "$f" /tmp/check.pdf --root . > /dev/null && echo "$f ✓" || echo "$f ✗"
done
```

## Architecture

Public API enters via `src/bookily.typ` which `#import "..": *`s these modules. Re-exports flow through, so users get everything from one import.

| Module                       | Responsibility                                                                                       |
|------------------------------|------------------------------------------------------------------------------------------------------|
| `src/bookily.typ`            | The `bookily(...)` show-rule; sets fonts, math, citations, figures, tables, calls theme + title-page |
| `src/bookily-defaults.typ`   | `states` dict, `default-config-options`, `default-fonts`, `default-colors`, `default-title-page`     |
| `src/bookily-cover.typ`      | `cover()` dispatcher and 5 sub-renderers (`simple`, `full`, `image-center`, `image-bg`, `image-only`) |
| `src/bookily-copyright.typ`  | `copyright-page()` renderer                                                                          |
| `src/bookily-data.typ`       | `normalize-author`, `normalize-publisher`, `normalize-editions`, `format-edition-date`, `_display-author` |
| `src/bookily-environments.typ` | `front-matter`, `main-matter`, `back-matter`, `appendix`                                           |
| `src/bookily-outlines.typ`   | `tableofcontents`, `listoffigures`, `listoftables`                                                   |
| `src/bookily-components.typ` | `chapter`, `chapter-nonum`                                                                           |
| `src/bookily-helper.typ`     | `book-title-page`, `thesis-title-page`, `back-cover`, `subfigure`, `boxeq`, `nonumeq`, `color-svg`, `reset-counters`, `show-if`, `headings-on-odd-page`, `ls-caption` |
| `src/bookily-themes.typ`     | Theme dispatcher, `part`, `minitoc`, all `*-box` variants                                            |
| `src/bookily-tufte.typ`      | `note`, `notefigure`, `notecite`, `tufte-content` (Tufte-only helpers)                               |
| `src/themes/{classic,fancy,modern,obook,orly,pretty}.typ` | Per-theme `chapter` / `part` / page styles; `obook` and `pretty` are deprecated as of v0.2.0 |
| `src/resources/i18n/*.json`  | 7 languages (en, de, fr, es, it, pt, zh), 40 keys each                                               |

The `bookily()` show-rule runs in this order: states → fonts → equations → localization → outlines → figures → title-page → headings (theme). **States must be set before `title-page` is invoked**, because the title-page reads them via `context`.

### States

`src/bookily-defaults.typ` is the source of truth for the `states` dict, now 36 state/counter entries in the 0.2.0 architecture. The v0.2.0 publishing-data additions are `config-options`, `copyright-notice`, `cover-artist`, `cover-defaults`, `editions`, `editors`, `illustrators`, `isbn`, `publisher`, and `translators`; the cover hierarchy states (`title`, `subtitle`, `subsubtitle`, `subsubsubtitle`, `epigraph`) remain the bridge between `bookily(...)`, `cover(...)`, and title-page helpers.

### `config-options` keys

`default-config-options` includes `paper`, `text-size`, `font-size-small`, `part-numbering`, `open-right`, `alt-margins`, and `hyphenate-titles`. The v0.2.0 keys `paper`, `text-size`, and `font-size-small` drive page paper size, body text size, and small theme text (headers, footers, captions); all six themes should honor them.

### Cover hierarchy (added in this fork)

`bookily(...)` accepts `title`, `subtitle`, `subsubtitle`, `subsubsubtitle`, `epigraph` at the top level. They're stored in `states` and rendered by both `default-title-page` (bare cover) and `book-title-page` (framed cover with series/institution headers). When rendering, **arguments to `book-title-page(...)` win over states**, so existing call-sites with explicit `subtitle: "X"` keep working.

For epigraphs, pass a `quote(attribution: ...)` element. The renderer does `set quote(block: true)` so the attribution line shows.

### Tufte layout

Toggled with `tufte: true`. Every theme has `if states.tufte.get()` branches that wrap content in `marginalia.wideblock(side: "both")`. **Do not casually delete these branches** — Tufte mode is a deliberate feature for commentary editions and annotated translations of historical works (the user reverted a strip earlier in the project's history). `bookily-outlines.typ`, `bookily-environments.typ`, and every theme depend on the `marginalia` package.

### `hyphenate-titles` config option

`config-options.hyphenate-titles` (default `false`) controls hyphenation across the cover hierarchy, level-1 chapter headings, and part headings. Implemented as a `set text(hyphenate: states.hyphenate-titles.get())` at 20 total sites — the 14 original title/heading/part sites, the 5 `cover()` sub-renderers, and `copyright-page()`. Epigraphs intentionally re-set `hyphenate: auto` because they're prose, not display type. If you add a new theme or a new title-rendering site, **add the same `set text(hyphenate: ...)` line** at the top of the show-rule body.

## Conventions and gotchas

- **Naming**: package is `bookily`, function is `bookily()`, files are `src/bookily-*.typ`. Mentions of `bookly` (no `i`) refer to **upstream** (`maucejo/bookly`) and are intentional in `README.md`, `typst.toml` description, and `docs/manual.typ` historical changelog. Do not "fix" these.
- **Version**: `0.2.0`. The fork reset versioning; do not assume continuity with upstream's `3.x`.
- **Imports in templates**: every showcase chapter/appendix/front-matter file uses `#import "../../src/bookily.typ": *` (depth 2). `template/main.typ` and `template_tufte/main_tufte.typ` use `../src/bookily.typ` (depth 1). Custom-theme files (`template{,_tufte}/custom-theme.typ`) also use `../src/bookily.typ`.
- **`.typstignore` is custom**: read its header comment. Patterns are anchored from the start of the path; `*` matches across `/`. It excludes `docs/`, `template_tufte/`, `scripts/`, `justfile`, `.github`, `.gitignore` from the packaged distribution — so `just install` ships only `src/`, `template/`, `thumbnails/`, `LICENSE`, `README.md`, and `typst.toml`.
- **`docs/manual.pdf` is tracked**: also excluded from the packaged distribution (`exclude` in `typst.toml`) but kept in-repo for browsing on GitHub. Rebuild it with `typst c docs/manual.typ docs/manual.pdf --root .` whenever the manual source changes.
- **Themes — `obook` / `pretty`** are deprecated as of v0.2.0 (doc-only; they still compile). `obook` still has unique behavior: builds a per-part partial outline on its part-page and links chapter headings in the footer. **`modern`** uses `marginalia.get-right()` so it's structurally tufte-aware even with `tufte: false`.

## What's still academic-leaning (kept for now)

The fork keeps these upstream APIs because removing them is invasive; they're documented but not the focus:

- `thesis-title-page` (in `src/bookily-helper.typ`)
- Math display helpers: `boxeq`, `nonumeq`, sub-equation numbering via the `equate` package
- `proof-box`, `question-box` (in `src/bookily-themes.typ`)
- i18n keys: `habilitation`, `doctoral-school`, `committee`, `cosupervisor`/`cosupervisors`, `sponsor`/`sponsors`, `discipline`, `specialty`, `defended`, `authored`

If you're tempted to delete any of these, talk to the user first — they were preserved deliberately.

## Test coverage

Two smoke tests exist (`.copilot-parity-smoke.typ`, `.copilot-toc-smoke.typ`). Both intentionally still use `theme: obook` + `tufte: true` + `open-right: true` despite the v0.2.0 `obook` deprecation, and verify front-matter → main-matter page-numbering transitions and TOC pagebreaks via metadata markers.

**Untested** (don't assume changes to these are safe without a manual compile):

- The five non-`obook` themes (`classic`, `fancy`, `modern`, `orly`, `pretty`)
- `tufte: false` standard layout
- Languages other than `en`
- Cover hierarchy (`subtitle`, `subsubtitle`, `subsubsubtitle`, `epigraph`)
- `hyphenate-titles` opt-in
- `book-title-page`, `thesis-title-page`, `back-cover`

For non-trivial changes, compile `template/main.typ` (exercises orly + most box types) **and** `template_tufte/main_tufte.typ` (exercises pretty + tufte + alt-margins).

## Existing prose docs

- `README.md` — user-facing overview, framing of the fork's intent, install instructions.
- `MIGRATION.md` — v0.2.0 migration guide; recommended path for adopting `cover()` / `copyright-page()` without breaking 0.1.x books.
- `docs/manual.typ` — full reference manual, built with the `mantys:1.0.2` package. Argument tables, examples, theme gallery, changelog.
- `docs/manual.pdf` — built output of the above; commit when the source changes.
- `TODO.md` — author's pending-work roadmap. Read it before proposing larger changes.
