// =====================================================================
//  lecture-template.typ — slide template for org lectures & workshops
//  Pure Typst, no external packages.
//
//  Quick start (see lecture.typ for a full example):
//
//    #import "lecture-template.typ": *
//    #show: lecture.with(
//      title: [My Lecture],
//      org: [Your Org Name],
//      logo: image("assets/logo.png"),
//    )
//
//    #slide(title: [Hello])[
//      - First point
//    ]
// =====================================================================

#let _theme = state("lecture-theme", (:))
#let _meta = state("lecture-meta", (:))
#let _section = state("lecture-section", none)
#let _section-num = counter("lecture-section")

#let _muted = rgb("#6b7280")
#let _code-bg = rgb("#f4f6f9")
#let _code-border = rgb("#e1e6ed")

// ---------------------------------------------------------------------
//  Logo
// ---------------------------------------------------------------------

// Fits the logo into a fixed box. With no logo, draws a dashed
// placeholder so the reserved space is visible.
#let _logo-box(logo, width, height, ink: white) = {
  if logo == none {
    box(
      width: width,
      height: height,
      radius: 12pt,
      stroke: (paint: ink.transparentize(45%), thickness: 1.5pt, dash: "dashed"),
      align(center + horizon, text(
        size: 14pt,
        weight: "bold",
        tracking: 2pt,
        fill: ink.transparentize(30%),
      )[ORG LOGO]),
    )
  } else {
    box(width: width, height: height, {
      set image(width: 100%, height: 100%, fit: "contain")
      align(center + horizon, logo)
    })
  }
}

// ---------------------------------------------------------------------
//  Page chrome (header, footer, progress bar)
// ---------------------------------------------------------------------

#let _header() = context {
  let s = _section.get()
  if s != none {
    set text(size: 12pt, fill: _muted, weight: "medium")
    s
  }
}

#let _footer() = context {
  let m = _meta.get()
  set text(size: 11pt, fill: _muted)
  grid(
    columns: (1fr, auto, 1fr),
    align: (left + horizon, center + horizon, right + horizon),
    {
      if m.logo != none {
        box(baseline: 25%, {
          set image(width: auto, height: 0.6cm)
          m.logo
        })
        h(0.4em)
      }
      m.org
    },
    m.short-title,
    [#counter(page).display() / #counter(page).final().first()],
  )
}

#let _progress() = context {
  let t = _theme.get()
  let n = counter(page).get().first()
  let total = counter(page).final().first()
  place(bottom + left, rect(width: 100% * n / total, height: 5pt, fill: t.accent))
}

#let _fill-page(key) = context rect(width: 100%, height: 100%, fill: _theme.get().at(key))

// ---------------------------------------------------------------------
//  Main template
// ---------------------------------------------------------------------

#let lecture(
  title: [Lecture Title],
  subtitle: none,
  short-title: none, // shown in the footer; defaults to `title`
  author: none,
  org: [Your Org Name],
  event: none, // e.g. [Typst Workshop · Session 1]
  date: datetime.today().display("[month repr:long] [day], [year]"),
  logo: none, // e.g. image("assets/logo.png") — pass it without a size
  primary: rgb("#1f3a5f"),
  accent: rgb("#f2a541"),
  font: ("Helvetica Neue", "Arial"), // any installed font works
  mono-font: "DejaVu Sans Mono", // bundled with Typst
  text-size: 20pt,
  title-slide: true,
  body,
) = {
  set document(title: title)
  set page(
    paper: "presentation-16-9",
    margin: (x: 1.8cm, top: 2cm, bottom: 1.8cm),
  )
  set text(font: font, size: text-size, fill: rgb("#1d232b"))
  set par(leading: 0.65em)

  // Lists and emphasis
  set list(marker: text(fill: accent)[•], spacing: 0.8em, indent: 0.3em)
  set enum(spacing: 0.8em, numbering: n => text(fill: primary, weight: "bold")[#n.])
  show strong: set text(fill: primary)
  show link: set text(fill: primary)
  show link: underline

  // Headings inside slides (for sub-headings)
  show heading: set text(fill: primary)
  show heading: set block(above: 0.9em, below: 0.6em)
  show heading.where(level: 1): set text(size: 28pt)
  show heading.where(level: 2): set text(size: 24pt)

  // Code
  show raw: set text(font: mono-font)
  show raw.where(block: true): it => block(
    width: 100%,
    fill: _code-bg,
    stroke: 1pt + _code-border,
    radius: 6pt,
    inset: (x: 14pt, y: 12pt),
    text(size: 17pt, it),
  )
  show raw.where(block: false): box.with(
    fill: _code-bg,
    inset: (x: 4pt),
    outset: (y: 3pt),
    radius: 3pt,
  )

  // Tables
  set table(
    stroke: none,
    inset: (x: 12pt, y: 9pt),
    fill: (_, y) => if y == 0 { primary } else if calc.even(y) { rgb("#f3f5f8") },
  )
  show table.cell.where(y: 0): set text(fill: white, weight: "bold")

  _theme.update((primary: primary, accent: accent))
  _meta.update((
    title: title,
    subtitle: subtitle,
    short-title: if short-title == none { title } else { short-title },
    author: author,
    org: org,
    event: event,
    date: date,
    logo: logo,
  ))

  if title-slide {
    page(margin: 0pt, header: none, footer: none, context {
      let t = _theme.get()
      let m = _meta.get()
      grid(
        columns: (36%, 1fr),
        rows: 100%,

        // Left panel — reserved space for the org logo
        block(
          width: 100%,
          height: 100%,
          fill: t.primary,
          inset: 1.4cm,
          align(center + horizon, _logo-box(m.logo, 100%, 8cm)),
        ),

        // Right panel — title block
        block(width: 100%, height: 100%, inset: (x: 1.8cm, y: 1.5cm), grid(
          rows: (auto, 1fr, auto),
          text(size: 14pt, weight: "bold", tracking: 1.5pt, fill: t.accent, upper(m.org)),
          align(horizon, stack(
            spacing: 0.6cm,
            if m.event != none { text(size: 15pt, fill: _muted, m.event) },
            text(size: 40pt, weight: "bold", fill: t.primary, m.title),
            rect(width: 3cm, height: 5pt, fill: t.accent, radius: 2pt),
            if m.subtitle != none { text(size: 22pt, fill: _muted, m.subtitle) },
          )),
          stack(
            spacing: 0.35cm,
            if m.author != none { text(size: 17pt, weight: "bold", m.author) },
            if m.date != none { text(size: 14pt, fill: _muted, m.date) },
          ),
        )),
      )
    })
  }

  body
}

// ---------------------------------------------------------------------
//  Slides
// ---------------------------------------------------------------------

// A regular content slide.
#let slide(title: none, body) = page(
  header: _header(),
  footer: _footer(),
  background: _progress(),
  {
    if title != none {
      context {
        let t = _theme.get()
        block(below: 0.9em, stack(
          spacing: 10pt,
          text(size: 30pt, weight: "bold", fill: t.primary, title),
          rect(width: 2.5cm, height: 4pt, fill: t.accent, radius: 2pt),
        ))
      }
    }
    body
  },
)

// Starts a new part of the lecture. Also feeds `agenda-slide` and
// the section name shown in the header of later slides.
#let section-slide(title, subtitle: none) = page(
  header: none,
  footer: none,
  background: _fill-page("primary"),
  {
    _section.update(title)
    _section-num.step()
    [#metadata(title) <lecture-section>]
    set text(fill: white)
    context {
      let t = _theme.get()
      let num = _section-num.get().first()
      place(right + horizon, dx: 0.6cm, text(
        size: 260pt,
        weight: "bold",
        fill: white.transparentize(90%),
        str(num),
      ))
      align(horizon, stack(
        spacing: 0.6cm,
        text(size: 16pt, weight: "bold", tracking: 2pt, fill: t.accent)[PART #num],
        text(size: 46pt, weight: "bold", title),
        if subtitle != none { text(size: 22pt, fill: white.transparentize(25%), subtitle) },
      ))
    }
  },
)

// Lists every `section-slide` in the lecture.
#let agenda-slide(title: [Agenda]) = slide(title: title, context {
  let t = _theme.get()
  let secs = query(<lecture-section>)
  set text(size: 24pt)
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.8em,
    row-gutter: 0.75em,
    align: horizon,
    ..secs
      .enumerate()
      .map(((i, s)) => (
        box(width: 1.5em, height: 1.5em, radius: 50%, fill: t.primary, align(
          center + horizon,
          text(fill: white, size: 0.7em, weight: "bold", str(i + 1)),
        )),
        s.value,
      ))
      .flatten(),
  )
})

// One big statement on a bold background — "Your turn!", key takeaways.
#let focus-slide(body) = page(
  header: none,
  footer: none,
  background: _fill-page("accent"),
  context align(center + horizon, text(
    size: 44pt,
    weight: "bold",
    fill: _theme.get().primary,
    body,
  )),
)

// Closing slide. Optional body for contact info, links, resources.
#let end-slide(title: [Thank you!], ..body) = page(
  header: none,
  footer: none,
  background: _fill-page("primary"),
  context {
    let m = _meta.get()
    set text(fill: white)
    show link: set text(fill: white)
    align(center + horizon, stack(
      spacing: 0.8cm,
      if m.logo != none { _logo-box(m.logo, 6cm, 3cm) },
      text(size: 48pt, weight: "bold", title),
      ..body.pos().map(b => text(size: 18pt, fill: white.transparentize(15%), b)),
    ))
  },
)

// ---------------------------------------------------------------------
//  Building blocks for slide content
// ---------------------------------------------------------------------

// Side-by-side columns: #cols[left][right] or #cols(columns: (2fr, 1fr))[..][..]
#let cols(columns: none, gutter: 1.2cm, ..bodies) = {
  let bodies = bodies.pos()
  grid(
    columns: if columns == none { (1fr,) * bodies.len() } else { columns },
    column-gutter: gutter,
    ..bodies,
  )
}

#let callout(title: none, color: rgb("#2563eb"), body) = block(
  width: 100%,
  inset: (x: 14pt, y: 11pt),
  radius: (right: 6pt),
  fill: color.lighten(90%),
  stroke: (left: 4pt + color),
  {
    if title != none {
      block(below: 0.5em, text(weight: "bold", fill: color.darken(15%), title))
    }
    body
  },
)

#let note(title: [Note], body) = callout(title: title, color: rgb("#2563eb"), body)
#let tip(title: [Tip], body) = callout(title: title, color: rgb("#16a34a"), body)
#let warning(title: [Watch out], body) = callout(title: title, color: rgb("#dc2626"), body)
#let exercise(title: [Exercise], body) = callout(title: title, color: rgb("#9333ea"), body)

// Shows Typst source next to its rendered output — made for teaching Typst.
//   #demo(```
//   Some *bold* text
//   ```)
#let demo(source, scope: (:), columns: (1fr, 1fr)) = {
  let code = if type(source) == str { source } else { source.text }
  let tag(name) = text(size: 11pt, weight: "bold", tracking: 1.5pt, fill: _muted, name)
  grid(
    columns: columns,
    column-gutter: 0.8cm,
    row-gutter: 0.5em,
    tag[SOURCE], tag[OUTPUT],
    raw(code, lang: "typ", block: true),
    block(width: 100%, inset: (x: 14pt, y: 12pt), radius: 6pt, stroke: 1pt + _code-border, {
      set text(size: 17pt)
      show heading: set text(size: 1.15em)
      show heading: set block(above: 0.4em)
      eval(code, mode: "markup", scope: scope)
    }),
  )
}
