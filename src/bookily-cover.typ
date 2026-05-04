// src/bookily-cover.typ
// Trade-publishing cover system for bookily 0.2.0.
// Opt-in: user calls #cover(style: ...) explicitly in front-matter.
// Coexists with the legacy bookily(title-page: ...) mechanism.
//
// Tufte note: cover() ignores tufte mode (always full-bleed, no wideblock).

#import "bookily-defaults.typ": states
#import "bookily-data.typ": _display-author

#let _publisher-name(pub) = {
  if pub == none { return none }
  if type(pub) == str { return pub }
  if type(pub) == dictionary { return pub.at("commercial-name", default: none) }
  none
}

#let _render-cover-image(value, width: auto, height: auto) = {
  if value == none { return none }
  if type(value) == str { image(value, width: width, height: height) } else { value }
}

#let _divider(stroke: 0.5pt + gray) = line(length: 100%, stroke: stroke)

#let _cover-simple(title, subtitle, subsubtitle, author, publisher, header, footer, logo) = {
  set text(hyphenate: states.hyphenate-titles.get())
  set page(header: none, footer: none, margin: (x: 2cm, y: 2.5cm))
  let primary = states.colors.get().primary
  let pub-name = _publisher-name(publisher)

  set align(center)
  if header != auto and header != none { header }
  v(1fr)
  if author != "" and author != none {
    text(size: 1.1em)[#smallcaps(author)]
  }
  v(1fr)
  if title != none {
    text(size: 3em, fill: primary, weight: "bold")[#smallcaps(title)]
    v(0.8em)
    line(length: 45%, stroke: 1pt + primary)
  }
  if subtitle != none {
    v(0.8em)
    text(size: 1.3em, style: "italic")[#subtitle]
  }
  if subsubtitle != none {
    v(0.45em)
    text(size: 1.05em, style: "italic")[#subsubtitle]
  }
  v(2fr)
  if footer != auto and footer != none { footer }
  if pub-name != none and pub-name != "" {
    text(size: 1em)[#smallcaps(pub-name)]
  }
  if logo != none {
    v(1em)
    _render-cover-image(logo, width: 25%)
  }
}

#let _cover-full(title, subtitle, subsubtitle, subsubsubtitle, epigraph, author, publisher, header, footer, logo) = {
  set text(hyphenate: states.hyphenate-titles.get())
  set page(header: none, footer: none, margin: (x: 2cm, y: 2.5cm))
  let primary = states.colors.get().primary
  let pub-name = _publisher-name(publisher)

  set align(center)
  if header != auto and header != none { header }
  v(1fr)
  if title != none {
    text(size: 2.8em, fill: primary, weight: "bold")[#smallcaps(title)]
  }
  v(0.8em)
  _divider()
  if subtitle != none {
    v(0.8em)
    text(size: 1.4em, style: "italic")[#subtitle]
  }
  if subsubtitle != none {
    v(0.45em)
    text(size: 1.1em, style: "italic")[#subsubtitle]
  }
  if subsubsubtitle != none {
    v(0.35em)
    text(size: 0.95em)[#subsubsubtitle]
  }
  v(0.8em)
  _divider()
  if epigraph != none {
    v(1em)
    block(width: 70%)[
      #set align(left)
      #set quote(block: true)
      #set text(hyphenate: auto)
      #text(size: 1em, style: "italic")[#epigraph]
    ]
    v(1em)
    _divider()
  }
  v(1.2em)
  if author != "" and author != none {
    text(size: 1.2em)[#smallcaps(author)]
  }
  v(2fr)
  if footer != auto and footer != none { footer }
  if pub-name != none and pub-name != "" {
    text(size: 1em)[#smallcaps(pub-name)]
  }
  if logo != none {
    v(0.8em)
    _render-cover-image(logo, width: 22%)
  }
}

#let _cover-image-center(title, subtitle, subsubtitle, subsubsubtitle, epigraph, author, image, header, footer, logo) = {
  set text(hyphenate: states.hyphenate-titles.get())
  set page(header: none, footer: none, margin: (x: 2cm, y: 2.5cm))
  let primary = states.colors.get().primary

  set align(center)
  if header != auto and header != none { header }
  v(0.7fr)
  if title != none {
    text(size: 2.5em, fill: primary, weight: "bold")[#smallcaps(title)]
  }
  if subtitle != none {
    v(0.6em)
    text(size: 1.3em, style: "italic")[#subtitle]
  }
  v(1em)
  _render-cover-image(image, width: 50%)
  if subsubtitle != none {
    v(0.9em)
    text(size: 1.1em, style: "italic")[#subsubtitle]
  }
  if subsubsubtitle != none {
    v(0.35em)
    text(size: 0.95em)[#subsubsubtitle]
  }
  v(0.9em)
  _divider()
  if epigraph != none {
    v(0.8em)
    block(width: 70%)[
      #set align(left)
      #set quote(block: true)
      #set text(hyphenate: auto)
      #text(size: 0.95em, style: "italic")[#epigraph]
    ]
  }
  v(1fr)
  if author != "" and author != none {
    text(size: 1.1em)[#smallcaps(author)]
  }
  if footer != auto and footer != none {
    v(0.8em)
    footer
  }
  if logo != none {
    v(0.8em)
    _render-cover-image(logo, width: 22%)
  }
}

#let _cover-image-bg(title, subtitle, author, image) = {
  set text(hyphenate: states.hyphenate-titles.get())
  set page(margin: 0pt, header: none, footer: none)
  let primary = states.colors.get().primary

  place(top + left, dx: 0pt, dy: 0pt)[#_render-cover-image(image, width: 100%, height: 100%)]
  block(width: 100%, height: 100%)[
    #set align(center + horizon)
    #block(fill: white.transparentize(30%), inset: 1.5em, radius: 4pt)[
      #if title != none {
        text(size: 2.7em, fill: primary, weight: "bold")[#smallcaps(title)]
      }
      #if subtitle != none {
        v(0.6em)
        text(size: 1.3em, style: "italic")[#subtitle]
      }
      #if author != "" and author != none {
        v(1em)
        text(size: 1.1em)[#smallcaps(author)]
      }
    ]
  ]
}

#let _cover-image-only(image) = {
  set text(hyphenate: states.hyphenate-titles.get())
  set page(margin: 0pt, header: none, footer: none)
  _render-cover-image(image, width: 100%, height: 100%)
}

#let cover(
  style: "simple",
  image: none,
  header: auto,
  footer: auto,
  title: auto,
  subtitle: auto,
  subsubtitle: auto,
  subsubsubtitle: auto,
  epigraph: auto,
  author: auto,
  logo: none,
) = context {
  let valid-styles = ("simple", "full", "image-center", "image-bg", "image-only")
  if not valid-styles.contains(style) {
    panic("bookily cover(): invalid style '" + style + "'. Valid styles: " + valid-styles.join(", "))
  }

  if style.starts-with("image") and image == none {
    panic("bookily cover(): style '" + style + "' requires an image argument")
  }

  let defaults = states.cover-defaults.get()
  let resolved-title = if title != auto { title }
    else if defaults != none and "title" in defaults { defaults.title }
    else { states.title.get() }
  let resolved-subtitle = if subtitle != auto { subtitle }
    else if defaults != none and "subtitle" in defaults { defaults.subtitle }
    else { states.subtitle.get() }
  let resolved-subsubtitle = if subsubtitle != auto { subsubtitle }
    else if defaults != none and "subsubtitle" in defaults { defaults.subsubtitle }
    else { states.subsubtitle.get() }
  let resolved-subsubsubtitle = if subsubsubtitle != auto { subsubsubtitle }
    else if defaults != none and "subsubsubtitle" in defaults { defaults.subsubsubtitle }
    else { states.subsubsubtitle.get() }
  let resolved-epigraph = if epigraph != auto { epigraph }
    else if defaults != none and "epigraph" in defaults { defaults.epigraph }
    else { states.epigraph.get() }
  let resolved-author = if author != auto { author }
    else { _display-author(states.author.get()) }
  let pub = states.publisher.get()

  pagebreak(weak: true)
  if style == "simple" {
    _cover-simple(resolved-title, resolved-subtitle, resolved-subsubtitle, resolved-author, pub, header, footer, logo)
  } else if style == "full" {
    _cover-full(resolved-title, resolved-subtitle, resolved-subsubtitle, resolved-subsubsubtitle, resolved-epigraph, resolved-author, pub, header, footer, logo)
  } else if style == "image-center" {
    _cover-image-center(resolved-title, resolved-subtitle, resolved-subsubtitle, resolved-subsubsubtitle, resolved-epigraph, resolved-author, image, header, footer, logo)
  } else if style == "image-bg" {
    _cover-image-bg(resolved-title, resolved-subtitle, resolved-author, image)
  } else if style == "image-only" {
    _cover-image-only(image)
  }
  pagebreak(weak: true)
}
