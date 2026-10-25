# Typst Lecture Template

16:9 slide template for org lectures. Pure Typst, no packages needed.

| File | What it is |
| --- | --- |
| `lecture-template.typ` | The template (theme, slide types, helpers) |
| `lecture.typ` | Sample "Intro to Typst" lecture that uses every slide type |
| `new-lecture.typ` | Blank starter to copy for each new lecture |
| `assets/` | Put your org logo here |

## Build

Compile once to PDF:

```bash
typst compile lecture.typ
```

Or upload the folder to [typst.app](https://typst.app).

## Live preview while you edit

### VS Code (recommended)

1. Install the **Tinymist Typst** extension:

   ```bash
   code --install-extension myriad-dreamin.tinymist
   ```

2. Open `lecture.typ` and click the preview icon in the top-right of the editor (or press `Cmd+K` then `V`, or run **Typst Preview: Preview Opened File** from the Command Palette).

The slides open next to your code and update on every keystroke, without saving. Click something in the preview to jump to its line in the code, and the reverse.

The preview doesn't write a PDF. To keep `lecture.pdf` up to date as well, add this to your VS Code settings JSON:

```json
"tinymist.exportPdf": "onSave"
```

Use `"onType"` to rewrite it on every keystroke. Tinymist comes with its own Typst compiler, so its version can differ slightly from the `typst` installed on your system.

### Terminal (any editor)

Rebuild the PDF every time you save and open it in your PDF viewer:

```bash
typst watch lecture.typ --open
```

## Adding the org logo

Put the file in `assets/`, then in your lecture:

```typ
logo: image("assets/logo.png"),
```

Pass the image without a size, because the template scales it. The logo shows on the title slide, in the footer, and on the end slide. Without a logo, the title slide shows a dashed "ORG LOGO" placeholder.

## Options for `lecture.with(...)`

`title`, `subtitle`, `short-title` (footer), `author`, `org`, `event`, `date`, `logo`,
`primary` / `accent` (theme colors), `font`, `mono-font`, `text-size`, `title-slide`.

## Slide types

| Function | Use |
| --- | --- |
| `#slide(title: [..])[..]` | Regular content slide |
| `#section-slide([..], subtitle: [..])` | New part; feeds the agenda and the header |
| `#agenda-slide()` | Lists all section slides automatically |
| `#focus-slide[..]` | One big statement ("Your turn!") |
| `#end-slide(title: [..])[..]` | Closing slide with contact info and links |

## Content helpers

| Function | Use |
| --- | --- |
| `#demo(```..```)` | Typst source next to its rendered output |
| `#cols[..][..]` | Side-by-side columns (`columns: (2fr, 1fr)` to adjust) |
| `#note[..]`, `#tip[..]`, `#warning[..]`, `#exercise[..]` | Colored callout boxes |
| `#callout(title: [..], color: ..)[..]` | Custom callout |

To reveal bullet points one at a time, use the [Touying](https://typst.app/universe/package/touying) package.
