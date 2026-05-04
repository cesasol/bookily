// src/bookily-data.typ
// Pure data normalization for bookily v0.2.0 publishing models.
// Inspired by schema.org/Book and VIAF.
// Used by: bookily.typ (state init), bookily-cover.typ (rendering),
// bookily-copyright.typ (rendering).
//
// No rendering in this module — pure functions only.
// No state updates — callers do that.

#let _allowed-author-keys = ("name", "dob", "pob", "dod", "pod", "website", "socials", "wikipedia", "viaf")
#let _allowed-publisher-keys = ("commercial-name", "legal-name", "logo", "webpage", "socials", "location")
#let _allowed-edition-keys = ("year", "month", "day", "publisher", "name")
#let _allowed-location-keys = ("country", "city", "address")

// Canonicalize a polymorphic author value.
// - string → (name: string)
// - dict   → validated dict (panics on unknown keys)
// - array  → each element normalized recursively
// - none   → none
#let normalize-author(value) = {
  if value == none { return none }
  if type(value) == str { return (name: value) }
  if type(value) == dictionary {
    for k in value.keys() {
      if not _allowed-author-keys.contains(k) {
        panic("bookily: unknown author key: " + k + ". Allowed: " + _allowed-author-keys.join(", "))
      }
    }
    return value
  }
  if type(value) == array {
    return value.map(normalize-author)
  }
  panic("bookily: author must be string, dict, or array, got: " + type(value))
}

// Canonicalize a polymorphic publisher value.
// - string → (commercial-name: string)
// - dict   → validated dict (panics on unknown top-level keys)
// - none   → none
#let normalize-publisher(value) = {
  if value == none { return none }
  if type(value) == str { return (commercial-name: value) }
  if type(value) == dictionary {
    for k in value.keys() {
      if not _allowed-publisher-keys.contains(k) {
        panic("bookily: unknown publisher key: " + k + ". Allowed: " + _allowed-publisher-keys.join(", "))
      }
    }
    // Validate location sub-dict if present
    if "location" in value and type(value.location) == dictionary {
      for k in value.location.keys() {
        if not _allowed-location-keys.contains(k) {
          panic("bookily: unknown publisher.location key: " + k + ". Allowed: " + _allowed-location-keys.join(", "))
        }
      }
    }
    return value
  }
  panic("bookily: publisher must be string or dict, got: " + type(value))
}

// Sort helper: compare two edition dicts by (year, month, day).
#let _edition-sort-key(ed) = {
  let y = ed.at("year", default: 0)
  let m = ed.at("month", default: 0)
  let d = ed.at("day", default: 0)
  // Pack into a single integer for comparison: YYYYMMDD
  y * 10000 + m * 100 + d
}

// Canonicalize and sort an editions array.
// - none or () → ()
// - array      → each element validated and sorted ascending by date
// year is required; month and day are optional.
#let normalize-editions(value) = {
  if value == none or value == () { return () }
  if type(value) != array {
    panic("bookily: editions must be an array, got: " + type(value))
  }
  let normalized = value.map(ed => {
    if type(ed) != dictionary {
      panic("bookily: each edition must be a dict, got: " + type(ed))
    }
    for k in ed.keys() {
      if not _allowed-edition-keys.contains(k) {
        panic("bookily: unknown edition key: " + k + ". Allowed: " + _allowed-edition-keys.join(", "))
      }
    }
    if not ("year" in ed) {
      panic("bookily: edition missing required key 'year'. Each edition dict must have a year.")
    }
    // Normalize embedded publisher if present
    if "publisher" in ed {
      ed + (publisher: normalize-publisher(ed.publisher))
    } else {
      ed
    }
  })
  // Sort ascending by (year, month, day)
  normalized.sorted(key: _edition-sort-key)
}

// Locale-aware edition date rendering.
// Uses Typst's built-in datetime.display() for month names.
// Falls back to English for months if locale support is insufficient.
#let format-edition-date(edition, lang) = {
  let y = edition.at("year", default: none)
  let m = edition.at("month", default: none)
  let d = edition.at("day", default: none)
  if y == none { return str(0) }
  if m == none { return str(y) }
  // Build a datetime for month name rendering
  let dt = datetime(year: y, month: m, day: if d != none { d } else { 1 })
  let month-name = dt.display("[month repr:long]")
  if d != none {
    str(d) + " " + month-name + " " + str(y)
  } else {
    month-name + " " + str(y)
  }
}

// Private: coerce any author value to a display string.
// Used by: bookily.typ (set document), default-title-page, book-title-page,
// thesis-title-page, back-cover.
// - none   → ""
// - string → as-is
// - dict   → dict.name
// - array  → comma-joined names
#let _display-author(value) = {
  if value == none { return "" }
  if type(value) == str { return value }
  if type(value) == dictionary {
    return value.at("name", default: "")
  }
  if type(value) == array {
    return value.map(a => {
      if type(a) == str { a }
      else if type(a) == dictionary { a.at("name", default: "") }
      else { "" }
    }).join(", ")
  }
  return ""
}
