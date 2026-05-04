// src/bookily-copyright.typ
// Copyright page renderer for bookily 0.2.0.
// Single canonical layout — not themable.
// Opt-in: user calls #copyright-page() explicitly in front-matter.

#import "@preview/marginalia:0.3.1": wideblock
#import "bookily-defaults.typ": states
#import "bookily-data.typ": format-edition-date, _display-author

#let _publisher-dict(pub) = {
  if pub == none { return none }
  if type(pub) == str { return (commercial-name: pub) }
  if type(pub) == dictionary { return pub }
  none
}

#let _publisher-name(pub) = {
  let pub-dict = _publisher-dict(pub)
  if pub-dict == none { return "" }
  pub-dict.at("commercial-name", default: "")
}

#let _location-line(location) = {
  if location == none { return none }
  if type(location) == str { return location }
  if type(location) == dictionary {
    let parts = ()
    if "city" in location { parts = parts + (location.city,) }
    if "country" in location { parts = parts + (location.country,) }
    if parts.len() > 0 { return parts.join(", ") }
  }
  none
}

#let _edition-line(edition, fallback-publisher) = {
  let date-str = format-edition-date(edition, "en")
  let ed-publisher = if "publisher" in edition and edition.publisher != none {
    _publisher-name(edition.publisher)
  } else {
    fallback-publisher
  }
  let ed-name = edition.at("name", default: "")
  let parts = (date-str,)
  if ed-publisher != "" { parts = parts + (ed-publisher,) }
  if ed-name != "" { parts = parts + (ed-name,) }
  parts.join(" · ")
}

// Render a copyright page with publisher block, editions history, ISBN,
// misc credits, and copyright notice. Reads data from bookily() states.
// Tufte-aware: wraps content in wideblock when tufte mode is active.
#let copyright-page(
  misc-credits: none,
  notice: auto,
) = context {
  let render-content = {
    set text(hyphenate: states.hyphenate-titles.get())
    set text(size: states.config-options.get().font-size-small)

    let loc = states.localization.get()
    let pub = states.publisher.get()
    let pub-dict = _publisher-dict(pub)
    let editions = states.editions.get()
    let editions-list = if editions == none { () } else { editions }
    let isbn-val = states.isbn.get()
    let author-val = states.author.get()
    let notice-val = states.copyright-notice.get()
    let L(key, fallback) = loc.at(key, default: fallback)

    if pub-dict != none {
      let commercial-name = pub-dict.at("commercial-name", default: "")
      let legal-name = pub-dict.at("legal-name", default: none)
      let logo = pub-dict.at("logo", default: none)
      let location = _location-line(pub-dict.at("location", default: none))
      let webpage = pub-dict.at("webpage", default: none)

      if logo != none {
        logo
        v(0.5em)
      }
      if commercial-name != "" { strong[#commercial-name] }
      if legal-name != none and legal-name != commercial-name {
        linebreak()
        emph[#legal-name]
      }
      if location != none {
        linebreak()
        location
      }
      if webpage != none {
        linebreak()
        link(webpage)[#webpage]
      }
      v(1.5em)
    }

    strong[#L("editions-history", "Editions")]
    if editions-list.len() == 0 {
      linebreak()
      L("first-edition", "First edition")
    } else {
      let fallback-publisher = _publisher-name(pub)
      for edition in editions-list {
        linebreak()
        _edition-line(edition, fallback-publisher)
      }
    }
    v(1.5em)

    if isbn-val != none {
      [#L("isbn", "ISBN:") #isbn-val]
      v(0.8em)
    }

    if misc-credits != none {
      for role in misc-credits.keys() {
        let name = misc-credits.at(role)
        [#L(role, role): #name]
        linebreak()
      }
      v(1.5em)
    }

    let final-notice = if notice != auto {
      notice
    } else if notice-val != none {
      notice-val
    } else {
      let year-str = str(datetime.today().year())
      let author-str = _display-author(author-val)
      let rights = L("all-rights-reserved", "All rights reserved")
      [© #year-str #author-str. #rights.]
    }
    final-notice
  }

  if states.tufte.get() {
    wideblock(side: "both")[#render-content]
  } else {
    render-content
  }

  pagebreak(weak: true)
}
