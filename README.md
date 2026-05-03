# Bookily

[![MIT License](https://img.shields.io/badge/License-MIT-forestgreen)](./LICENSE)
[![User Manual](https://img.shields.io/badge/doc-.pdf-mediumpurple)](./docs/manual.pdf)

`bookily` is a [Typst](https://typst.app) template for **traditional book publishing** — novels, essays, manuals, non-fiction, and similar long-form prose work.

It is a fork of the excellent [`bookly`](https://github.com/maucejo/bookly) template by **Mathieu Aucejo**, with a deliberately narrower scope: the upstream project targets academic writing (theses, French habilitations, scientific monographs), while this fork strips away the academic apparatus to focus on the typesetting needs of regular books.

## Why a fork?

The upstream `bookly` is a great template, but it carries a lot of machinery that book authors do not need:

- thesis title pages and committee formalities
- heavy mathematical typesetting affordances tuned for journal articles
- academic outline conventions surfaced by default
- proof / theorem-style information boxes

`bookily` is the same engine pointed at a different reader: someone preparing a book for **print or e-book distribution**, not a journal or a defense committee. The goal is to make the common path — title page → front matter → chapters → back matter → cover — clean, opinionated, and pleasant.

The fork keeps a few things that are *not* exclusively academic:

- A first-class **cover-hierarchy** (`title`, `subtitle`, `subsubtitle`, `subsubsubtitle`, `epigraph`) that flows straight into the title page.
- The **Tufte layout** is kept on purpose. It's the natural fit for commentary editions, annotated translations of historical works, and other margin-driven scholarly publishing.

> **Status:** This fork is young. Expect the trade-publishing surface to keep growing and the academic-leaning defaults to keep softening. Existing upstream documents should keep compiling.

## Acknowledgements

This project would not exist without:

- **[Mathieu Aucejo](https://github.com/maucejo)** — author of the original [`bookly`](https://github.com/maucejo/bookly) template. The architecture, themes, and the bulk of the typesetting work are his. All credit for the foundation belongs upstream; any rough edges in this fork are mine.
- The Typst community and the package maintainers listed under [Dependencies](#dependencies).

If you are writing a thesis, a habilitation, or a math-heavy scientific monograph, you almost certainly want **upstream `bookly`**, not this fork.

## Basic usage

This fork is currently consumed locally rather than via the Typst package registry. Clone the repo and point your document at the entrypoint, or copy the `template/` folder as a starting point:

```sh
git clone https://github.com/cesasol/bookily.git
cp -r bookily/template my-book
```

Then in your `.typ` file:

```typ
#import "path/to/bookily/src/bookily.typ": *

#show: bookily.with(
  title: [A long and beautiful title],
  subtitle: [Introduction to writing great subtitles],
  subsubtitle: [A redundant and sometimes necessary subtitle],
  subsubsubtitle: [A third tag-line, used sparingly],
  epigraph: quote(attribution: [Jonathan Bingus])[
    A tremendously inspirational quote that sets the tone of the book.
  ],
  author: "Author Name",
  theme: modern,
  lang: "en",
  fonts: (body: "Lato"),
  title-page: book-title-page(
    series: "An Imprint",
    cover: image("images/book-cover.jpg", width: 45%),
  ),
  config-options: (open-right: true),
)
```

A complete, runnable example lives in [`template/main.typ`](./template/main.typ). For the full reference, see the [manual](./docs/manual.pdf).

## Features

Built for prose-first publishing:

- **Cover hierarchy:** `title`, `subtitle`, `subsubtitle`, `subsubsubtitle`, `epigraph` — drop them straight into the show-rule and the cover lays itself out.
- **Themes:** `classic`, `modern`, `fancy`, `obook`, `orly`, `pretty`.
- **Two layouts:** standard prose layout, and a Tufte-style layout for commentary editions, annotated historical works, and other margin-driven publishing — toggled with `tufte: true`.
- **Languages:** English, Chinese, French, German, Italian, Portuguese, Spanish.
- **Fonts:** body / math / raw fonts each customizable.
- **Structure:** `front-matter`, `main-matter`, `appendix`, `back-matter`.
- **Headings:** `part`, `chapter`, `chapter-nonum` (plus standard Typst markup).
- **Title pages and back cover:** `book-title-page`, `back-cover`.
- **Subfigures** via `subpar`.
- **Information callouts:** `info-box`, `tip-box`, `important-box`, `custom-box`.

Inherited from upstream and kept for now (less central to trade publishing, but harmless if unused):

- Lists of figures / tables, per-chapter mini-TOCs.
- Math helpers: `boxeq`, `nonumeq`, sub-equation numbering.
- `proof-box`, `question-box`.
- `thesis-title-page`.

## Dependencies

`bookily` builds on the same Typst packages as upstream `bookly`:

| Package        | Version | Purpose                              |
| -------------- | ------- | ------------------------------------ |
| `marginalia`   | 0.3.1   | Tufte / commentary-edition margins   |
| `hydra`        | 0.6.2   | Running headers / bibliography aids  |
| `equate`       | 0.3.2   | Equation numbering                   |
| `itemize`      | 0.2.0   | List customization                   |
| `showybox`     | 2.0.4   | Information boxes                    |
| `suboutline`   | 0.3.0   | Mini tables of contents              |
| `subpar`       | 0.2.2   | Subfigures                           |

## License

MIT — see [`LICENSE`](./LICENSE).

- Original work © 2026 **Mathieu Aucejo** ([`maucejo/bookly`](https://github.com/maucejo/bookly))
- Fork modifications © 2026 **cesasol**

The MIT license of the original project is preserved in this fork.
