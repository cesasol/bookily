// NOTE: This smoke test intentionally uses `theme: obook` (deprecated in v0.2.0)
// to verify front-matter→main-matter page-numbering and TOC pagebreak invariants.
// Do not migrate to a non-deprecated theme — the test's purpose is layout-invariant
// validation, not theme advocacy.

#import "src/bookily.typ": *

#show: bookily.with(
  title: "TOC smoke",
  author: "Copilot",
  theme: obook,
  tufte: true,
  title-page: book-title-page(),
  config-options: (
    open-right: true,
  ),
)

#show: front-matter

= Front

#lorem(20)

#show: main-matter

#context[#metadata((tag: "before-toc", physical: here().page(), display: counter(page).display())) <before-toc>]

#tableofcontents

#context[#metadata((tag: "after-toc", physical: here().page(), display: counter(page).display())) <after-toc>]

= Main

#context[#metadata((tag: "main-heading", physical: here().page(), display: counter(page).display())) <main-heading>]

#lorem(20)