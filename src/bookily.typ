// Exported packages
#import "@preview/equate:0.3.2": *
// Internals
#import "bookily-environments.typ": *
#import "bookily-outlines.typ": *
#import "bookily-components.typ": *
#import "bookily-helper.typ": *
#import "bookily-themes.typ": *
#import "bookily-tufte.typ": *
#import "bookily-cover.typ": *
#import "bookily-data.typ": normalize-author, normalize-publisher, normalize-editions, _display-author

// Template
#let bookily(
  title: "Title",
  subtitle: none,
  subsubtitle: none,
  subsubsubtitle: none,
  epigraph: none,
  author: "Author Name",
  translators: none,
  editors: none,
  illustrators: none,
  cover-artist: none,
  publisher: none,
  editions: none,
  isbn: none,
  copyright-notice: none,
  cover-defaults: none,
  theme: fancy,
  tufte: false,
  logo: none,
  lang: "en",
  fonts: default-fonts,
  colors: default-colors,
  title-page: default-title-page,
  config-options: default-config-options,
  body
) = context {
  // Document's properties
  set document(author: _display-author(normalize-author(author)), title: title)
  states.author.update(normalize-author(author))
  states.title.update(title)
  states.subtitle.update(subtitle)
  states.subsubtitle.update(subsubtitle)
  states.subsubsubtitle.update(subsubsubtitle)
  states.epigraph.update(epigraph)
  states.tufte.update(tufte)
  // Publishing data states
  states.translators.update(normalize-author(translators))
  states.editors.update(normalize-author(editors))
  states.illustrators.update(normalize-author(illustrators))
  states.cover-artist.update(normalize-author(cover-artist))
  states.publisher.update(normalize-publisher(publisher))
  states.editions.update(normalize-editions(editions))
  states.isbn.update(isbn)
  states.copyright-notice.update(copyright-notice)
  states.cover-defaults.update(cover-defaults)

  // Book colors
  let book-colors = default-colors + colors
  states.colors.update(book-colors)

  // Configuration options
  let book-options = default-config-options + config-options
  states.config-options.update(book-options)
  states.alt-margins.update(book-options.alt-margins)
  states.open-right.update(book-options.open-right)
  states.part-numbering.update(book-options.part-numbering)
  states.hyphenate-titles.update(book-options.hyphenate-titles)

  // Fonts
  set text(font: fonts.body, lang: lang, size: book-options.text-size, ligatures: false)

  // Math font
  show math.equation: set text(font: fonts.math, stylistic-set: 1)
  // Unnumbered equations
  show selector(<nonum-eq>): set math.equation(numbering: none)

  // Equations
  show: equate.with(breakable: true, sub-numbering: true)

  // Paragraphs
  set par(justify: true)

  // Localization
  let bookily-lang = if default-language.contains(lang) {
    lang
  } else {
    "en"
  }
  states.localization.update(json("resources/i18n/" + bookily-lang + ".json"))


  // References
  set ref(supplement: none)

  // Citations
  show cite: it => {
    show regex("\[|\]"): it => text(fill: black)[#it]
    it
  }

  // Footnotes
  // show footnote.entry: it => {
  //   [#h(it.indent) #text(fill: book-colors.primary, it.note) #it.note.body]
  // }

  // Outline entries
  set outline(depth: 3)

  // Figures
  let numbering-fig = n => {
      let h1 = counter(heading).get().first()
      numbering(states.num-pattern-fig.get(), h1, n)
  }

  show figure.where(kind: image): set figure(
      supplement: fig-supplement,
      numbering: numbering-fig,
      gap: 1.5em
    )

  set figure.caption(position: top) if tufte
  show: show-if(tufte, it => {
    show figure.caption.where(position: top): note.with(
      alignment: "top",
      counter: none,
      shift: "avoid",
      keep-order: true,
    )
    it
  })
  show figure: set figure.caption(separator: [ -- ])

  // Equations
  let numbering-eq = (..n) => {
    let h1 = counter(heading).get().first()
    numbering(states.num-pattern-eq.get(), h1, ..n)
  }

  set math.equation(numbering: numbering-eq)

  // Tables
  show figure.where(kind: table): set figure(
    numbering: numbering-fig,
  )

  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    it
  }

  // Title page
  if title-page != none {
    title-page
  } else {
    default-title-page
  }

  show: show-if(tufte, it => {
    let marginalia-book = if book-options.alt-margins {true} else {false}

    let m-config = (
    inner: (far: 1.25cm, width: 0cm, sep: 0cm),
    outer: (far: 1.25cm, width: 5cm, sep: 0.5cm),
    book: marginalia-book
    )

    show: marginalia.setup.with(..m-config)
    it
  })


  // show: marginalia.show-frame.with(footer: false)

  // Headings
  show: theme.with(colors: book-colors)
  show: show-if(book-options.open-right, it => {
    show: headings-on-odd-page
    it
  })

  // Unnumbered sections - Thanks to @bluss (Typst universe: How to have headings without numbers in a fluent way?)
  show selector(<nonum-sec>): set heading(numbering: none)

  body
}
