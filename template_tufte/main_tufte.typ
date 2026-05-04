// #import "../../src/bookily.typ": *
#import "../src/bookily.typ": *

#let config-colors = (
  primary: rgb("#1d90d0"),
  secondary: rgb("#dddddd").darken(15%)
)

#show: bookily.with(
  author: (name: "Author Name"),
  publisher: (commercial-name: "The Publisher"),
  editions: ((year: 2026, month: 5, name: "First edition"),),
  isbn: "978-0-00-000000-0",
  fonts: (
    body: "Lato",
    math: "Lete Sans Math"
  ),
  // theme: classic,
  // theme: fancy,
  // theme: modern,
  // theme: orly,
  theme: pretty,
  tufte: true,
  // lang: "fr",
  // colors: config-colors,
  title-page: [],
  config-options: (
    open-right: false,
    alt-margins: true
  )
)

#show: front-matter

#[
  #set page(header: none, footer: none)

  #cover(style: "simple")
  #copyright-page()
]

#include "front_matter_tufte/front_main_tufte.typ"

#show: main-matter

#tableofcontents

#listoffigures

#listoftables

#part("First part")

#include "chapters_tufte/ch_main_tufte.typ"

#part("Second part")// #part("Second part")

// #show: appendix

// #include "appendix_tufte/app_main_tufte.typ"

// #bibliography("bibliography/sample.yml")
#bibliography("bibliography/sample.bib")

#let abstracts-fr-en = (
  (
    title: [#set text(lang: "fr"); Résumé],
    text: [#lorem(100)]
  ),
  (
    title: [#set text(lang: "en", region: "gb"); Abstract],
    text: [#lorem(100)]
  ),
)

#let logos = (
  align(left)[#image("images/typst-logo.svg", width: 50%)],
  align(right)[#image("images/typst-logo.svg", width: 50%)]
)

#back-cover(abstracts: abstracts-fr-en, logo: logos)
