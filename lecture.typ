#import "lecture-template.typ": *

#show: lecture.with(
  title: [Typesetting with Typst],
  subtitle: [From zero to beautiful documents],
  short-title: [Intro to Typst],
  author: [JD, Edgar, AJ],
  org: [UP ACM],
  event: [Typst Workshop · Session 1],
  date: [October 2026],
  // Put your logo in assets/ and swap the line below:
  // logo: image("assets/logo.png"),
  logo: none,
  // primary: rgb("#1f3a5f"),
  // accent: rgb("#f2a541"),
)

#agenda-slide()

// ---------------------------------------------------------------------
#section-slide([Why Typst?], subtitle: [A modern take on typesetting])

#slide(title: [What is Typst?])[
  - A *markup-based typesetting system*, like LaTeX but modern
  - Compiles in *milliseconds*, with instant preview
  - One language for both content _and_ logic
  - Free, open source, written in Rust

  #v(0.5em)
  #tip[Try it in the browser at #link("https://typst.app")[typst.app]. No install needed.]
]

#slide(title: [Typst vs. LaTeX])[
  #table(
    columns: (1fr, 1.4fr, 1fr),
    [], [LaTeX], [Typst],
    [Bold text], `\textbf{hi}`, `*hi*`,
    [Heading], `\section{Intro}`, `= Intro`,
    [Compile time], [seconds], [milliseconds],
    [Error messages], [cryptic], [readable],
  )
]

// ---------------------------------------------------------------------
#section-slide([The Basics])

#slide(title: [Markup])[
  #demo(```
  = Heading
  Some *bold* and _italic_ text,
  plus `inline code`.

  - A bullet list
  + A numbered list
  ```)
]

#slide(title: [Math])[
  #demo(```
  Inline: $a^2 + b^2 = c^2$

  Display:
  $ sum_(k=1)^n k = (n(n+1)) / 2 $
  ```)
]

#slide(title: [Two columns])[
  #cols[
    *Markup mode* is the default:
    text, lists, headings.

    - `*bold*`
    - `_italic_`
  ][
    *Code mode* starts with `#`:
    variables, functions, loops.

    - `#let x = 1`
    - `#for i in range(3) [..]`
  ]

  #v(0.5em)
  #note[Everything in Typst is either markup, code, or math.]
]

// ---------------------------------------------------------------------
#section-slide([Scripting])

#slide(title: [Functions and loops])[
  #demo(```
  #let greet(name) = [
    Hello, *#name*!
  ]
  #greet("CS Org")

  #for i in range(1, 4) [
    #i squared is #(i * i). \
  ]
  ```)
]

#slide(title: [Set and show rules])[
  #demo(```
  #set text(fill: navy)
  #show "Typst": set text(
    fill: red, weight: "bold")

  Typst lets you restyle
  everything with rules.
  ```)

  #warning[A `set` rule applies to everything _after_ it in the same scope.]
]

#focus-slide[Your turn!]

#slide(title: [Exercise])[
  #exercise[
    Make a one-page résumé in Typst with:
    + Your name as a heading
    + A bulleted list of skills
    + A `#let` function for job entries
  ]
]

// ---------------------------------------------------------------------
#end-slide(title: [Questions?])[
  Slides: #link("https://github.com/your-org/typst-workshop")[github.com/your-org/typst-workshop] \
  Docs: #link("https://typst.app/docs")[typst.app/docs]
]
