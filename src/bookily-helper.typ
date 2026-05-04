
#import "@preview/subpar:0.2.2"
#import "@preview/suboutline:0.3.0": *
#import "bookily-defaults.typ": *
#import "bookily-data.typ": _display-author

// Reset counters
#let reset-counters = context {
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  if states.tufte.get(){
    states.sidenotecounter.update(0)
  }
  counter(footnote).update(0)
}

// Conditional set-show
#let show-if(cond, func) = body => if cond { func(body) } else { body }

// Headings
#let headings-on-odd-page(it) = {
  show heading.where(level: 1): it => {
    {
      set page(header: none, footer: none)
      pagebreak(to: "odd")
    }
    it
  }
  it
}

// Equations
#let boxeq(body) = context {
set align(center)
  box(
    stroke: 1pt + states.colors.get().boxeq.darken(35%),
    radius: 5pt,
    inset: 0.6em,
    fill: states.colors.get().boxeq,
  )[#body]
}

#let nonumeq(x) = {
   set math.equation(numbering: none)
   x
}

// Subfigure
#let subfigure = subpar.grid.with(
  gap: 1em,
  numbering: n => {numbering(states.num-pattern-fig.get(), counter(heading).get().first() , n)},
  numbering-sub-ref: (m, n) => {numbering(states.num-pattern-subfig.get(), counter(heading).get().first(), m, n)},
  supplement: fig-supplement,
  show-sub: it => {set figure.caption(position: bottom); it}
)

// Long and short captions for figures or tables
#let ls-caption(long, short) = context if states.in-outline.get() { short } else { long }

// Flatten a heading title for use in running headers/footers: suppress
// embedded linebreaks (\ and \) so multi-line chapter titles
// render as a single line in the running head.
//
// Used by: orly (T12) and classic (T11) — NOT exported from bookily.typ.
// Typst's \ scoped inside a content block is the idiomatic
// approach (precedent: fancy.typ line 131).
#let flatten-title(it) = [#show linebreak: none; #it]

// Book title page (legacy slot — see #cover() for the recommended 0.2.0 path).
// Accepts both old arg names (institution, series) and new preferred names
// (publishing-house, collection). New names win when both are supplied.
//
// Most "title" content (title, subtitle, subsubtitle, subsubsubtitle, epigraph,
// author) flows in from the top-level `bookily()` call via states. The
// arguments below override those states when explicitly provided, which keeps
// pre-existing call sites working.
#let book-title-page(
  subtitle: none,
  subsubtitle: none,
  subsubsubtitle: none,
  epigraph: none,
  edition: "First edition",
  institution: "Institution",      // legacy alias — prefer publishing-house
  publishing-house: auto,          // preferred 0.2.0 name; auto = use institution
  series: "Discipline",             // legacy alias — prefer collection
  collection: auto,                // preferred 0.2.0 name; auto = use series
  year: datetime.today().year(),
  cover: none,
  logo: none,
) = context {
  let resolved-publishing-house = if publishing-house == auto { institution } else { publishing-house }
  let resolved-collection = if collection == auto { series } else { collection }
  let primary = states.colors.get().primary

  // Resolve content: argument wins, otherwise fall back to the state set by `bookily()`.
  let resolved-subtitle = if subtitle != none { subtitle } else { states.subtitle.get() }
  let resolved-subsubtitle = if subsubtitle != none { subsubtitle } else { states.subsubtitle.get() }
  let resolved-subsubsubtitle = if subsubsubtitle != none { subsubsubtitle } else { states.subsubsubtitle.get() }
  let resolved-epigraph = if epigraph != none { epigraph } else { states.epigraph.get() }

  let header = {
    box(fill: primary, width: 100%, inset: 1em)[
      #set align(center + horizon)
      #text(fill: white, size: 1.5em)[#strong(delta: 400)[#resolved-collection]]
    ]
  }

  let footer = {
    box(fill: primary, width: 100%, inset: 1em)[
      #set align(center + horizon)
      #text(fill: white, size: 1.5em)[#strong(delta: 400)[#resolved-publishing-house]]
    ]
  }

  set page(
    paper: paper-size,
    header: header,
    footer: footer,
    margin: (left: 0em, right: 0em, top: 4em, bottom: 4em),
  )

  let title-page = context {
    let title = states.title.get()
    let author = _display-author(states.author.get())

    // Display-type hyphenation policy (config-options.hyphenate-titles).
    set text(hyphenate: states.hyphenate-titles.get())

    align(horizon)[
      #move(dx: 2em)[
        #line(stroke: 1.5pt + primary, length: 90%)
        #v(1em)
      ]

      #move(dx: 4em)[
        #text(size: 3em)[*#smallcaps(title)*]
        #linebreak()

        #if resolved-subtitle != none {
          v(0.5em)
          text(size: 1.75em)[#smallcaps(resolved-subtitle)]
          linebreak()
        }

        #if resolved-subsubtitle != none {
          v(0.4em)
          text(size: 1.25em, style: "italic")[#resolved-subsubtitle]
          linebreak()
        }

        #if resolved-subsubsubtitle != none {
          v(0.3em)
          text(size: 1em, style: "italic")[#resolved-subsubsubtitle]
          linebreak()
        }

        #if edition != none {
          v(0.5em)
          text(size: 1.25em)[_ #edition _]
          linebreak()
          v(0.5em)
        }

        #v(0.5em)
        #text(size: 1.5em)[#smallcaps(author)]
      ]

      #move(dx: 2em)[
        #v(1em)
        #line(stroke: 1.5pt + primary, length: 90%)
      ]

      #if cover != none {
        v(1.5em)
        align(center)[#cover]
      }
    ]

    set page(
      paper: paper-size,
      header: none,
      footer: none,
      margin: auto,
    )

    if states.open-right.get() {
      pagebreak(to: "odd")
    }

    // Inner cover
    set align(center)
    v(1fr)

    text(size: 3em)[*#smallcaps(title)*]

    if resolved-subtitle != none {
      v(0.5em)
      text(size: 1.75em)[#smallcaps(resolved-subtitle)]
    }

    if resolved-subsubtitle != none {
      v(0.6em)
      text(size: 1.25em, style: "italic")[#resolved-subsubtitle]
    }

    if resolved-subsubsubtitle != none {
      v(0.3em)
      text(size: 1em, style: "italic")[#resolved-subsubsubtitle]
    }

    if edition != none {
      v(0.8em)
      text(size: 1.25em)[_ #edition _]
    }

    v(2fr)

    // Epigraph block, framed by horizontal rules.
    // `set quote(block: true)` ensures `#quote(attribution: ...)` renders the
    // attribution line, which Typst hides in inline mode. Epigraph is
    // body-style prose, so we restore normal hyphenation here.
    if resolved-epigraph != none {
      block(width: 70%)[
        #set align(left)
        #set quote(block: true)
        #set text(hyphenate: auto)
        #line(length: 100%, stroke: 0.5pt)
        #v(0.5em)
        #text(size: 1em, style: "italic")[#resolved-epigraph]
        #v(0.5em)
        #line(length: 100%, stroke: 0.5pt)
      ]
    }

    v(2fr)

    text(size: 1.25em)[#smallcaps(_display-author(states.author.get()))]

    v(1fr)

    if logo != none {
      set image(width: 35%)
      place(bottom + center, dy: -4em, logo)
    }

    place(bottom)[
      #text(size: 0.85em)[#states.localization.get().version-usage \ #sym.copyright #_display-author(states.author.get()), #year.]
    ]
  }

  title-page
}

// Thesis title page
#let thesis-title-page(
  type: "phd",
  school: "School name",
  doctoral-school: "Name of the doctoral school",
  supervisor: ("Supervisor name",),
  cosupervisor: none,
  laboratory: "Laboratory name",
  defense-date: "01 January 1970",
  discipline: "Discipline",
  specialty: "Specialty",
  committee: (:),
  logo: none
) = context {
  set page(
      paper: paper-size,
      header: none,
      footer: none,
      margin: auto
    )

  place(top + left, dx: -16%, dy: -10%,
      rect(fill: states.colors.get().primary, height: 121%, width: 20%)
  )

  let title-page = {
    if logo != none {
      set image(width: 35%)
      place(top + right, dx: 0%, dy: -15%, logo)
    }
    text([#states.localization.get().doctoral-school #h(0.25em) #doctoral-school], size: 1.25em)
    v(0.25em)
    text(school, size: 1.25em)

    v(0.25em)
    text(laboratory, size: 1.25em)
    v(2em)
    if type.contains("phd") {
      text([*#states.localization.get().phd*], size: 1.5em)
    } else {
      text([*#states.localization.get().habilitation*], size: 1.5em)
    }
    v(0.25em)
    text([_ #states.localization.get().authored _ *#_display-author(states.author.get())*], size: 1.15em)
    v(0.25em)
    text([_ #states.localization.get().defended _ *#defense-date*], size: 1.15em)
    v(0.25em)
    text([_ #states.localization.get().discipline _ *#discipline*], size: 1.1em)
    v(0.15em)
    text([_ #states.localization.get().specialty _ *#specialty*], size: 1.1em)
    v(2em)
    line(stroke: 1.75pt + states.colors.get().primary, length: 104%)
    align(center)[#text(strong(states.title.get()), size: 2em)]
    line(stroke: 1.75pt + states.colors.get().primary, length: 104%)
    v(1em)

    if supervisor != none {
      let n = supervisor.len()
      let dir = none
      if n == 1 {
        if type.contains("phd") {
          dir = states.localization.get().supervisor
      } else {
        dir = states.localization.get().sponsor
      }
      } else {
        if type.contains("phd") {
          dir = states.localization.get().supervisors
        } else {
          dir = states.localization.get().sponsors
        }
      }

      let names-dir = ()
      for director in supervisor {
        names-dir.push(director)
      }

      text(1.15em)[#dir *#names-dir.join(",", last: states.localization.get().and)*]
      v(0.5em)
    }

    if cosupervisor != none {
      let m = cosupervisor.len()
      let codir = none
      if m == 1 {
        if type.contains("phd") {
          codir = states.localization.get().cosupervisor
        } else {
          codir = states.localization.get().cosponsor
        }
      } else {
        if type.contains("phd") {
          codir = states.localization.get().cosupervisors
        } else {
          codir = states.localization.get().cosponsors
        }
      }

      let names-codir = ()
        for codirector in cosupervisor {
          names-codir.push(codirector)
        }

      text(1.15em)[#codir *#names-codir.join(",", last: states.localization.get().and)*]
      v(0.5em)
    }

    if committee.len() > 0 {
      v(1fr)
      align(center)[
        #text([*#states.localization.get().committee*])
        #v(0.5em)
        #set text(size: 0.9em)
        #grid(
          columns: 4,
          column-gutter: 1.5em,
          row-gutter: 1em,
          align: left,
          stroke: none,
          ..for (name, position, affiliation, role) in committee {
            ([*#name*], position, affiliation, role)
          },
        )
      ]

      v(1fr)
    }
  }

  place(dx: 8%, dy: 11%,
    block(
      height: 100%,
      width: 100%,
      breakable: false,
      title-page
    )
  )
}

// Back cover
#let back-cover(abstracts: (), logo: none) = context{
  set page(margin: auto, header: none, footer: none)

  if states.open-right.get() {
    pagebreak(to: "even", weak: true)
  }

  set align(horizon)

  if logo != none {
    grid(columns : logo.len(),
      column-gutter: 1fr,
      ..logo.map((logos) => logos)
    )
  }

  context{
    v(2em)
    align(center)[
      #text([*#_display-author(states.author.get())*], size: 1.5em, fill: states.colors.get().primary)

      #text([*#states.title.get()*], size: 1.25em)

      #v(1em)
    ]
  }

  for abstract in abstracts {
    context{
      block(
        width: 100%,
        stroke: 1pt + states.colors.get().primary,
        inset: 1em,
        radius: 0.5em,
        below: 2em
      )[
        #text([*#abstract.title * #abstract.text], size: 0.9em)
      ]
    }
  }
}

// Boxes - Utility
#let box-title(a, b) = {
  grid(columns: 2, column-gutter: 0.5em, align: (horizon),
    a,
    b
  )
}

#let colorize(svg, color) = {
  let blk = black.to-hex();
  if svg.contains(blk) {
    svg.replace(blk, color.to-hex())
  } else {
    svg.replace("<svg ", "<svg fill=\""+ color.to-hex() + "\" ")
  }
}

#let color-svg(
  path,
  color,
  ..args,
) = {
  let data = colorize(read(path), color)
  return image(bytes(data), ..args)
}
