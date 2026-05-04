# Migration Guide: bookily 0.1.0 → 0.2.0

**Bookily 0.2.0 is an additive release.** No public APIs were removed.
Every 0.1.0 book continues to compile unchanged on 0.2.0. This guide
documents the new APIs and the *recommended* (but not required) path
from the legacy cover system to the new `#cover()` / `#copyright-page()`
primitives.

## What's Preserved (zero migration required)

- `book-title-page(institution: ..., series: ..., ...)` — works exactly as in 0.1.0.
- `default-title-page` — preserved as the default value of the `bookily(title-page: ...)` arg.
- `bookily(title-page: ...)` — arg preserved; show-rule still auto-renders the supplied title-page.
- `back-cover(abstracts: ..., logo: ...)` — preserved.
- `thesis-title-page(...)` — preserved.

## What's New (additive)

### `#cover(style: ...)` — the recommended new cover primitive

Standalone function, opt-in. Five styles: `simple`, `full`, `image-center`, `image-bg`, `image-only`.
Reads structured publisher / author / editions data from top-level `bookily()` args.

```typ
#show: bookily.with(
  title: "T", author: (name: "Jane Doe"),
  publisher: (commercial-name: "Acme Press"),
)
#cover(style: "full")
```

### `#copyright-page()` — the new copyright-page primitive

Single canonical layout. Pulls ISBN, editions history, publisher block, copyright notice from state.

```typ
#copyright-page(misc-credits: (cover-design: "Designer Name"))
```

### New top-level `bookily(...)` args

- `translators`, `editors`, `illustrators`, `cover-artist` — author-shaped (string | dict | array)
- `publisher` — string or dict (`commercial-name`, `legal-name`, `logo`, `webpage`, `socials`, `location`)
- `editions` — array of edition dicts with `year` required plus optional `month` / `day`, `name`, and `publisher`
- `isbn` — string
- `copyright-notice` — content override (defaults to localized “© year author. All rights reserved.” template)
- `cover-defaults` — dict of arg overrides applied across all `#cover()` calls in the document

### Polymorphic `author`

`author` arg now accepts:

- `author: "Jane Doe"` (string, legacy — still works)
- `author: (name: "Jane", viaf: "12345", ...)` (single dict)
- `author: ("Jane", (name: "John"))` (array — multi-author)

### `book-title-page` arg aliases

- `publishing-house` (preferred) is an alias for `institution` (still works)
- `collection` (preferred) is an alias for `series` (still works)

Both old and new names accepted; new names win when both are supplied.

### `config-options` extended

- `paper` — Typst paper string OR `(width, height)` length dict
- `text-size` — body text size
- `font-size-small` — used by themes for footers/captions

All 6 themes now honor these (previously hardcoded to globals).

## Theme Changes

- `obook` and `pretty` are **soft-deprecated** (doc-only — no further updates planned). They continue to compile. New books should prefer `classic`, `fancy`, `modern`, or `orly`.
- `modern` chapter heading: title is now visually prominent; chapter number is subordinate.
- `orly` and `classic` running headers strip embedded line breaks from chapter titles.
- All themes now honor `paper` and `text-size` from `config-options`.

## Recommended Path (optional)

If you want to move from `book-title-page` to the new `#cover()` / `#copyright-page()` primitives:

1. Move publishing metadata from `book-title-page(...)` args to top-level `bookily(...)` args (`publisher`, `editions`, `isbn`).
2. Drop the `title-page: book-title-page.with(...)` arg from your `bookily()` call (or set `title-page: []` to suppress the auto-render).
3. Add `#cover(style: "...")` and `#copyright-page()` to your front matter in the order you want them rendered.
4. Optional: prefer `publishing-house` and `collection` over `institution` and `series` if you keep using `book-title-page`.

## Follow-up (Out of Scope for v0.2.0, planned for v0.3.0)

- PDF metadata expansion (publisher, keywords, date on `set document(...)`)
- Cover style: `image-grid` for collected works
- Locale-aware month names if Typst's built-in datetime locale proves insufficient for any of the 7 supported languages
