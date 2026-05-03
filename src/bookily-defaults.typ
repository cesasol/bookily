#let fig-supplement = [Figure]
#let text-size = 11pt
#let paper-size = "a4"

#let states = (
  alt-margins: state("alt-margins", false),
  author: state("author", none),
  colors: state("theme-colors"),
  counter-part: counter("part"),
  epigraph: state("epigraph", none),
  in-outline: state("in-outline", false),
  isappendix: state("isappendix", false),
  isfrontmatter: state("isfrontmatter", false),
  localization: state("localization"),
  num-heading: state("num-heading", "1"),
  num-pattern: state("num-pattern", "1.1."),
  num-pattern-eq: state("num-pattern-eq", "(1.1)"),
  num-pattern-fig: state("num-pattern-fig", "1.1"),
  num-pattern-subfig: state("num-pattern-subfig", "1.1a"),
  open-right: state("open-right", true),
  page-numbering: state("page-numbering", "1/1"),
  part-numbering: state("part-numbering", "1"),
  sidenotecounter: counter("sidenotecounter"),
  subsubsubtitle: state("subsubsubtitle", none),
  subsubtitle: state("subsubtitle", none),
  subtitle: state("subtitle", none),
  theme: state("theme", "fancy"),
  title: state("title", none),
  tufte: state("tufte", false),
)

#let default-language = ("en", "de", "fr",  "es", "it", "pt", "zh")

#let default-config-options = (
  part-numbering: "1",
  open-right: true,
  alt-margins: false
)

#let default-fonts = (
  body: "New Computer Modern",
  math: "New Computer Modern Math",
  raw: "Cascadia Code"
)

#let default-colors = (
  primary: rgb("#c1002a"),
  secondary: rgb("#dddddd").darken(15%),
  boxeq: rgb("#dddddd"),
  header: black,
)

// Default Title page
#let default-title-page = context {
  set page(
    paper: paper-size,
    header: none,
    footer: none,
    margin: auto,
  )

  let title = states.title.get()
  let subtitle = states.subtitle.get()
  let subsubtitle = states.subsubtitle.get()
  let subsubsubtitle = states.subsubsubtitle.get()
  let epigraph = states.epigraph.get()
  let author = states.author.get()
  let primary = states.colors.get().primary

  set align(center)
  v(1fr)

  // Title
  text(size: 2.75em, fill: primary, weight: "bold")[#smallcaps(title)]

  // Subtitle
  if subtitle != none {
    v(0.6em)
    text(size: 1.5em)[#smallcaps(subtitle)]
  }

  // Sub-subtitle (italic)
  if subsubtitle != none {
    v(0.8em)
    text(size: 1.15em, style: "italic")[#subsubtitle]
  }

  // Sub-sub-subtitle (smaller italic, may contain forced linebreaks)
  if subsubsubtitle != none {
    v(0.3em)
    text(size: 0.95em, style: "italic")[#subsubsubtitle]
  }

  v(2fr)

  // Epigraph: rule above, content (block-quoted so attributions render), rule below
  if epigraph != none {
    block(width: 70%)[
      #set align(left)
      #set quote(block: true)
      #line(length: 100%, stroke: 0.5pt)
      #v(0.4em)
      #text(size: 1em, style: "italic")[#epigraph]
      #v(0.4em)
      #line(length: 100%, stroke: 0.5pt)
    ]
  }

  v(2fr)

  // Author
  if author != none {
    text(size: 1.25em)[#smallcaps(author)]
  }

  v(1fr)
}