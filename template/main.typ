#import "../src/bookily.typ": *
// #import "custom-theme.typ": *

#let config-colors = (
  primary: rgb("#1d90d0"),
  secondary: rgb("#dddddd").darken(15%)
)

#show: bookily.with(
  title: [A long and beautiful title],
  subtitle: [Introduction to writing great subtitles],
  subsubtitle: [
    A redundant and sometimes necessary subtitle
  ],
  subsubsubtitle: [
    There are times that two subtitles don't make the cut so we add a third one \
    —subsubtitle—
  ],
  epigraph: quote(
    attribution: [Jonathan Bingus],
  )[This is a tremendously inspirational quote that sets the tone of this course; truly, one of the epigraphs of all time.],
  author: (name: "Author Name"),
  publisher: (commercial-name: "The Publisher", legal-name: "The Publisher Ltd."),
  editions: ((year: 2026, month: 5, name: "First edition"),),
  isbn: "978-0-00-000000-0",
  fonts: (
    body: "IBM Plex Serif",
    math: "DejaVu Math TeX Gyre"
  ),
  // theme: custom,
  // theme: classic,
  // theme: fancy,
  // theme: modern,
  // theme: obook,
  theme: orly,
  // theme: pretty,
  // tufte: true,
  lang: "en",
  // colors: config-colors,
  // Legacy pattern (still supported in v0.2.0):
  // title-page: book-title-page.with(institution: "Publisher", series: "Series"),
  title-page: [],
  config-options: (
    open-right: false,
    // alt-margins: true,
    // part-numbering: "A"
  )
)

#show: front-matter

#[
  #set page(header: none, footer: none)

  // New 0.2.0 front-matter
  #cover(style: "full")
  #pagebreak(to: "odd")
  #cover(style: "simple")
  #pagebreak(to: "odd")
  #copyright-page()
]

#include "front_matter/front_main.typ"

#show: main-matter

#tableofcontents

#listoffigures

#listoftables

#part([First part])

#include "chapters/ch_main.typ"

#part("Second part")

#show: appendix

#include "appendix/app_main.typ"

// #bibliography("bibliography/sample.yml")
#bibliography("bibliography/sample.bib")

#let abstracts-fr-en = (
  (
    title: [#set text(lang: "fr"); Résumé :],
    text: [#lorem(100)]
  ),
  (
    title: [#set text(lang: "en", region: "gb"); Abstract:],
    text: [#lorem(100)]
  ),
)

#let logos = (
  align(left)[#image("images/typst-logo.svg", width: 50%)],
  align(right)[#image("images/typst-logo.svg", width: 50%)]
)

#back-cover(abstracts: abstracts-fr-en, logo: logos)
