#import "@preview/mantys:1.0.2": *
#import "@preview/showybox:2.0.4": *
#import "@preview/swank-tex:0.1.0": LaTeX
#import "@preview/cheq:0.2.2": *
#import "../src/bookily.typ": *

#show: checklist.with(fill: eastern.lighten(95%), stroke: eastern, radius: .2em)

#let typst-color = rgb(35,157,173)
#let Typst = text("Typst", fill: typst-color)

#let abstract = [This Typst package is a proposed template for writing thesis dissertations, French habilitations, or scientific books.]

#show: mantys(
  name: "bookily.typ",
  version: "0.2.0",
  authors: ("cesasol", "Mathieu Aucejo"),

  license: "MIT",
  description: "Typst template for traditional book publishing (fork of bookily)",
  repository: "https://github.com/cesasol/bookily",

  title: "Book Template",
  date: datetime.today(),

  abstract: abstract,
  show-index: false
)


= Usage

== Using `bookily`

To use the #package[bookily] template, you need to include the following line at the beginning of your `typ` file:
#codesnippet[```typ
#import "@preview/bookily:0.2.0": *
```
]

#warning-alert[
In `bookily`, the supplement of the `ref` function is set to "none" by default to avoid unexpected behavior when referencing more than one item. However, you can revert this setting by using the following syntax after the template definition:
#codesnippet[
  ```typ
  #set ref(supplement: auto)
  ```
]]

== Initializing the template

After importing #package[bookily], you have to initialize the template by a show rule with the #cmd[bookily] command. This function takes an optional argument to specify the title of the document.
#codesnippet[```typ
#show: bookily.with(
  ...
)
```
]

#command("bookily", ..args(
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
	theme: "fancy",
	tufte: false,
	lang: "fr",
	fonts: "default-fonts",
	colors: "default-colors",
	title-page: "default-title-page",
	config-options: "default-config-options",
	[body]))[
		#argument("title", default: "Title", types: ("string", "content"))[Title of the book. Rendered prominently on the cover.]

		#argument("subtitle", default: none, types: ("string", "content"))[Optional subtitle. Rendered below the title in small caps.]

		#argument("subsubtitle", default: none, types: ("string", "content"))[Optional second-level subtitle. Rendered below the subtitle in italics. Useful when one subtitle isn't enough.]

		#argument("subsubsubtitle", default: none, types: ("string", "content"))[Optional third-level subtitle. Rendered in a smaller italic. Supports forced linebreaks (`\`) for multi-line tag-lines.]

		#argument("epigraph", default: none, types: "content")[Optional epigraph rendered between two horizontal rules near the bottom of the cover. Pass a `quote(...)` for proper attribution rendering, e.g.

		```typ
		epigraph: quote(attribution: [Jonathan Bingus])[
		  This is a tremendously inspirational quote.
		]
		```
		]

		#argument("author", default: "Author Name", types: ("string", "dict", "array"))[Author of the book. A string is treated as a display name; a dictionary or array follows the author data model described in @ss:publishing-data-models.]

		#argument("translators", default: none, types: ("string", "dict", "array"))[Translator credit(s). Uses the same author-shaped data model as `author`.]

		#argument("editors", default: none, types: ("string", "dict", "array"))[Editor credit(s). Uses the same author-shaped data model as `author`.]

		#argument("illustrators", default: none, types: ("string", "dict", "array"))[Illustrator credit(s). Uses the same author-shaped data model as `author`.]

		#argument("cover-artist", default: none, types: ("string", "dict", "array"))[Cover artist credit(s). Uses the same author-shaped data model as `author`.]

		#argument("publisher", default: none, types: ("string", "dict"))[Publisher imprint or publishing house. A string maps to `(commercial-name: "...")`; dictionaries follow the publisher data model described in @ss:publishing-data-models.]

		#argument("editions", default: none, types: "array")[Array of edition dictionaries used by `copyright-page()`. Edition entries are validated and sorted by date; see @ss:publishing-data-models.]

		#argument("isbn", default: none, types: "string")[ISBN printed by `copyright-page()` when present.]

		#argument("copyright-notice", default: none, types: "content")[Content override for the copyright notice used by `copyright-page()`.]

		#argument("cover-defaults", default: none, types: "dict")[Defaults consumed by `#cover()` before it falls back to the template states. Supported keys are `title`, `subtitle`, `subsubtitle`, `subsubsubtitle`, and `epigraph`. Explicit `cover()` arguments still win.]

		#argument("theme", default: "fancy", types: "function")[Theme of the document. Possible values are:
			- `fancy` (default)
			- `modern`
			- `classic`
			- `obook` (deprecated legacy theme in v0.2.0)
			- `orly` (O'Reilly inspired)
			- `pretty` (deprecated legacy theme in v0.2.0)
		]

		#argument("tufte", default: false, types: "bool")[If `true`, the layout of the document is inspired by the works of Edward Tufte (wide margins, sidenotes, etc.). Useful for commentary editions of historical works and other annotation-heavy publications.
		]

		#argument("lang", default: "en", types: "string")[Language of the document.

		Supported languages:
		- English -- `"en"` (default)
		- Chinese -- `"zh"`
		- French -- `"fr"`
		- German -- `"de"`
		- Italian -- `"it"`
		- Portuguese -- `"pt"`
		- Spanish -- `"es"`
		]

		#argument("fonts", default: "default-fonts", types: "dict")[Fonts used in the document. It contains the following keys:
			- `body` #dtype(str) -- Font used for the body text (default: `"New Computer Modern"`)
			- `math` #dtype(str) -- Font used for mathematical equations (default: `"New Computer Modern Math"`)
			- `raw` #dtype(str) -- Font used for raw text (default: `"DejaVu Sans Mono"`)
		]

		#argument("colors", default: "default-colors", types: "dict")[Colors used in the document. It contains the following keys:
			- `primary` #dtype(color) -- Primary color (default: `rgb("#c1002a")`)
			- `secondary` #dtype(color) -- Secondary color (default: `rgb("#dddddd").darken(15%)`)
			- `boxeq` #dtype(color) -- Color of equation boxes (default: `rgb("#dddddd")`)
			- `header` #dtype(color) -- Color used for adapting the color of the document headers (default: `black`)
		]

		#argument("title-page", default: "default-title-page", types: ("content", "function", "none"))[Content or function used by the legacy title-page slot — auto-renders `default-title-page` or a user-supplied function. Pass `[]` or `none` only when you plan to build front matter manually with `#cover()` and `#copyright-page()`.]

		#argument("config-options", default: "default-config-options", types: "dict")[Configuration options of the document. It allows a more fine-grained control of some aspects of the template. It contains the following keys:
			- `part-numbering` #dtype(str) -- Numbering pattern (default: "1")
			- `open-right` #dtype(bool) -- If `true`, parts start on a right-hand page (default: `true`)
			- `alt-margins` #dtype(bool) -- If `true`, margins are alternated for odd and even pages when `tufte` is enabled (default: `false`)
			- `hyphenate-titles` #dtype(bool) -- If `true`, hyphenation is allowed inside the cover title hierarchy (`title`, `subtitle`, `subsubtitle`, `subsubsubtitle`), chapter (level-1) headings, and part titles. If `false`, those display elements wrap whole words instead. Trade-publishing convention is to never hyphenate display type, so the default is `false`. The epigraph and body text are unaffected (they follow the document language's normal hyphenation).
		]
]

=== Initialization example
#codesnippet[
```typ
#show: bookily.with(
	author: "Author Name",
	fonts: (
		body: "Lato",
		math: "Lete Sans Math"
	),
	theme: modern,
	lang: "en",
	logo: image("path_to_image/image.png")
)
```
]

=== Themes gallery <sss:themes>

#warning-alert[In v0.2.0, `obook` and `pretty` are deprecated legacy themes. They remain available for existing documents, but no further updates are planned. For new books, prefer `classic`, `fancy`, `modern`, or `orly`.]

==== Fancy

#subfigure(
	columns: 2,
	figure(image("manual-images/part-fancy.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-fancy.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-fancy.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-fancy.png", width: 80%), caption: "Section"),
)

==== Modern

#subfigure(
	columns: 2,
	figure(image("manual-images/part-modern.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-modern.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-modern.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-modern.png", width: 80%), caption: "Section"),
)

==== Classic

#subfigure(
	columns: 2,
	figure(image("manual-images/part-classic.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-classic.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-classic.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-classic.png", width: 80%), caption: "Section"),
)

==== Obook

#subfigure(
	columns: 2,
	figure(image("manual-images/part-obook.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-obook.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-obook.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-obook.png", width: 80%), caption: "Section"),
)

==== Orly

#subfigure(
	columns: 2,
	figure(image("manual-images/part-orly.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-orly.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-orly.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-orly.png", width: 80%), caption: "Section"),
)

==== Pretty

#subfigure(
	columns: 2,
	figure(image("manual-images/part-pretty.png", width: 80%), caption: "Part"),
	figure(image("manual-images/chapter-pretty.png", width: 80%), caption: "Chapter"),
	figure(image("manual-images/chapter-nonum-pretty.png", width: 80%), caption: "Unnumbered chapter"),
	figure(image("manual-images/sections-pretty.png", width: 80%), caption: "Section"),
)

=== Layout

The template currently supports two layouts: `standard` and `tufte`.

The `standard` layout is the default layout, with symmetric margins. It is the most common layout for books and theses. Some examples of the standard layout are presented in @sss:themes "Themes gallery".

The `tufte` layout is inspired by the works of Edward Tufte, which emphasizes simplicity and clarity, often using wide margins for notes and figures. It is particularly suitable for books or theses that require extensive annotations or side comments. To implement the `tufte` layout, the template comes with several helper functions, based on the `marginalia` package, implementing side notes, side figures, full width blocks, etc. (see @ss:tufte for details). Some examples of the `tufte` layout are presented below.

#subfigure(
	columns: 3,
	figure(image("manual-images/tufte-figures.png"), caption: [Figures and side figures]),
	figure(image("manual-images/tufte-citations.png"), caption: [Citations]),
	figure(image("manual-images/tufte-wide.png"), caption: [Full width elements]),
)

= Book content

The content of the book should be written in the main `typ` file or in additional files. The template provides a basic structure for writing a book.

In general, the section of the main file corresponding to the book content is structured as follows:
#codesnippet[
	```typ
	#show: front-matter

	#include "front-content.typ"

	#show: main-matter

	#tableofcontents

	#listoffigures

	#listoftables

	#part("Main body")

	#include "chapter.typ"

	#bibliography("bibliography.bib")

	#show: appendix

	#part("Document appendices")

	#include "appendix.typ"
	```
]

The content of the thesis is divided into three main sections: `front-matter`, `main-matter`, and `appendix`. These elements are accompanied by additional functions to facilitate writing.

== Environments

The template provides three environments to structure the thesis content:

1. *front-matter*: environment for preliminary content (cover page, abstract, acknowledgments, etc.). Pages are numbered with Roman numerals and chapters are not numbered. To activate this environment, insert the following command in the main `typ` file at the desired location:
	#codesnippet[
		```typ
		#show: front-matter
		```
	]

2. *main-matter*: environment for the main content (introduction, tables of contents, chapters, conclusion, bibliography, etc.). Pages and chapters are numbered with Arabic numerals. To activate this environment, insert the following command in the main `typ` file at the desired location:
	#codesnippet[
	```typ
	#show: main-matter
	```
]

3. *appendix*: environment for the appendices. Pages are numbered with Roman numerals and chapters are numbered with letters. To activate this environment, insert the following command in the main `typ` file at the desired location:
	#codesnippet[
		```typ
		#show: appendix
		```
	]

== Parts and chapters

To structure the book content, you can define parts using the #cmd("part") function. To insert a new part, use the following command:
#codesnippet[
	```typ
	#part("Part title")
	```
]

Chapters can also be defined using the standard #Typst markup language. This template defines a function #cmd("chapter") that helps you to avoid boilerplate code, such as the manual inclusion of standard elements like title, abstract, and minitoc.

#command("chapter", arg[title],
..args(
	abstract: none,
	toc: true,
	numbered: true,
	label: none,
	[body],
)
)[
	#argument("title", types: "string")[Chapter title.]

	#argument("abstract", default: none, types: "content")[Summary displayed below the chapter title.]

	#argument("toc", default: true, types: "boolean")[Indicates whether a mini table of contents should be displayed at the beginning of the chapter.]

	#argument("numbered", default: true, types: "boolean")[Indicates whether the chapter should be numbered.]

	#argument("label", default: none, types: "label")[Label for the chapter.]
]

#codesnippet[
```typ
	#chapter(
		"First chapter",
		abstract: lorem(20),
		label: <ch:1>
	)[
		// Content of the chapter
	]
```
]
#info-alert[If you use a #sym.ast\.typ file for each chapter, you can type at the top of the file the following code.

	#codesnippet[
		```typ
		#show: chapter.with("First chapter", abstract: lorem(20), toc: true, label: <ch:1>)

		// Content of the chapter
		== First section
		```
	]
]

For unnumbered chapters, you can simply use the #cmd("chapter-nonum") function. This function assumes that you have a #sym.ast\.typ file per chapter.
#codesnippet[
	```typ
	#show: chapter-nonum

	// Content of the chapter
	= Chapter title
	```
]

`bookily` also provides the #dtype("label") `<nonum-sec>` to create unnumbered sections. To use it, simply add the label `<nonum-sec>` after the title of the considered section.
#codesnippet[
```typ
== Section title <nonum-sec>
```
]
#warning-alert[The `<nonum-sec>` label only works for sections and not for chapters. When applied to chapters, it breakes the global numbering of the document. For unnumbered chapters, use the #cmd("chapter-nonum") function. instead]

== Tables of contents

The template defines several commands to facilitate the creation of tables of contents:
- #cmd("tableofcontents") : Table of contents
- #cmd("listoffigures") : List of figures
- #cmd("listoftables") : List of tables

A mini table of contents is automatically generated by using the command #cmd("minitoc") in a chapter. This function is a wraper of the #cmd("suboutline") function provided by the `suboutline` package.

= Helper functions

== Figure captions

The package include the command #cmd("ls-caption") to manage long and short captions for figures and tables. Short caption are displayed in the list of figures or tables, while long captions are used in the main text and in the table of contents.

#codesnippet[
	```typ
	#figure(
  	rect(),
  	caption: ls-caption("Long caption", "Short caption")
	)
	```
]

#info-alert[The code of the command #cmd("ls-caption") comes from the #link("https://sitandr.github.io/typst-examples-book/book/snippets/chapters/outlines.html?highlight=long#long-and-short-captions-for-the-outline", "Typst book") by Sitandr.]

== Subfigures

In general, figures are inserted into the document using the #cmd("figure") function from #Typst. However, #Typst currently does not provide mechanisms for handling subfigures (numbering and referencing). To address this limitation, the template includes a #cmd("subfigure") function that manages subfigures appropriately. This function wraps the #cmd("subpar.grid") function from the `subpar` package.

#codesnippet[
	```typ
	#subfigure(
		figure(image("image1.png"), caption: []),
		figure(image("image2.png"), caption: []), <b>,
		columns: (1fr, 1fr),
		caption: [Figure title],
		label: <fig:subfig>,
	)
	```
]

#info-alert[The example above shows a figure composed of two subfigures. The first subfigure has a caption, while the second has a #dtype("label") but no title. The second subfigure can be referenced in the text using the command #text(`@b`, fill: typst-color.darken(15%)).]

== Equations

To highlight an important equation, use the #cmd("boxeq") function.

#codesnippet[
	```typ
	$
		#boxeq[$p(A|B) prop p(B|A) space p(A)$]
	$
	```
]

To create an equation without numbering, use the #cmd("nonumeq") function.

#codesnippet[
	```typ
	#nonumeq[$integral_0^1 f(x) dif x = F(1) - F(0)$]
	```
]

`bookily` also provides the #dtype("label") `<nonum-eq>` to create unnumbered equations. To use it, simply add the label `<nonum-eq>` after the equation.
#codesnippet[
```typ
$
	integral_0^1 f(x) dif x = F(1) - F(0)
$ <nonum-eq>
```
]

#info-alert[The command #cmd("nonumeq") will be deprecated in a future version in favor of the label `<nonum-eq>`.]

== Information boxes

The template provides several types of boxes to highlight different kinds of content:

- #cmd("info-box") for remarks;
- #cmd("tip-box") for tips;
- #cmd("warning-box") for warnings;
- #cmd("important-box") for important information;
- #cmd("proof-box") for proofs;
- #cmd("question-box") for questions.

#codesnippet[
	#show math.equation: set text(font: "New Computer Modern Math")
	```typ
	#info-box[#lorem(10)]
	#tip-box[#lorem(10)]
	#warning-box[#lorem(10)]
	#important-box[#lorem(10)]
	#proof-box[#lorem(10)]
	#question-box[#lorem(10)]
	```
]

#info-alert[The appearance of the boxes depends on the selected theme (see the "Themes gallery" section).]

The information boxes described above are built using the #cmd("custom-box") function, which allows you to create custom boxes. This generic function takes the following parameters:
#command("custom-box",
..args(
	title: none,
	icon: "info",
	color: rgb(29, 144, 208),
	[body],
)
)[
	#argument("title", default: none, types: "string")[Name of the box.]

	#argument("icon", default: "info", types: "string")[Name of the icon to display in the box.

	Available icons are:
	- #box-title(image("../src/resources/images/icons/alert.svg", width: 1em), [: `"alert"`])
	- #box-title(image("../src/resources/images/icons/info.svg", width: 1em), [: `"info"`])
	- #box-title(image("../src/resources/images/icons/question.svg", width: 1em), [: `"question"`])
	- #box-title(image("../src/resources/images/icons/report.svg", width: 1em), [: `"report"`])
	- #box-title(image("../src/resources/images/icons/stop.svg", width: 1em), [: `"stop"`])
	- #box-title(image("../src/resources/images/icons/tip.svg", width: 1em), [: `"tip"`])
	]

	#argument("color", default: rgb(29, 144, 208), types: "color")[Box color.]
]

== Cover system

`bookily` v0.2.0 adds an opt-in standalone #cmd("cover") function for trade-publishing front matter. It coexists with the legacy `title-page:` slot: initialize document metadata with `bookily(...)`, suppress the automatic title page when needed, then call `#cover(...)` explicitly inside `front-matter`.

#command("cover", ..args(
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
))[
	#argument("style", default: "simple", types: "string")[Cover style. Available values are `"simple"`, `"full"`, `"image-center"`, `"image-bg"`, and `"image-only"`.]

	#argument("image", default: none, types: ("string", "image", "content"))[Cover image. Required by `"image-center"`, `"image-bg"`, and `"image-only"`. A string is treated as a path and passed to `image(...)`.]

	#argument("header", default: auto, types: (auto, "content", "none"))[Optional header content for text-based cover styles. `auto` lets the style decide; `none` suppresses it.]

	#argument("footer", default: auto, types: (auto, "content", "none"))[Optional footer content for text-based cover styles. `auto` lets the style decide; `none` suppresses it.]

	#argument("title", default: auto, types: (auto, "string", "content", "none"))[Title override. `auto` reads `cover-defaults.title` first, then `states.title`.]

	#argument("subtitle", default: auto, types: (auto, "string", "content", "none"))[Subtitle override. `auto` reads `cover-defaults.subtitle` first, then `states.subtitle`.]

	#argument("subsubtitle", default: auto, types: (auto, "string", "content", "none"))[Second-level subtitle override. `auto` reads `cover-defaults.subsubtitle` first, then `states.subsubtitle`.]

	#argument("subsubsubtitle", default: auto, types: (auto, "string", "content", "none"))[Third-level subtitle override. `auto` reads `cover-defaults.subsubsubtitle` first, then `states.subsubsubtitle`.]

	#argument("epigraph", default: auto, types: (auto, "content", "none"))[Epigraph override. `auto` reads `cover-defaults.epigraph` first, then `states.epigraph`. Pass a `quote(attribution: ...)` element for attribution rendering.]

	#argument("author", default: auto, types: (auto, "string", "content", "none"))[Author display override. `auto` renders the normalized `author` state.]

	#argument("logo", default: none, types: ("string", "image", "content", "none"))[Logo content or image path.]
]

The five built-in cover styles are:
#v(0.5em)
- `"simple"`: centered text cover with title hierarchy, author, publisher, and optional logo.
- `"full"`: richer text cover with dividers, the full title hierarchy, epigraph, author, publisher, and optional logo.
- `"image-center"`: title and metadata with a centered cover image.
- `"image-bg"`: full-bleed image background with a translucent title block.
- `"image-only"`: full-bleed image with no generated typography.

#codesnippet[
```typ
#show: bookily.with(
  title: [A long and beautiful title],
  subtitle: [Introduction to writing great subtitles],
  author: (name: "Author Name"),
  publisher: (commercial-name: "The Publisher"),
  title-page: [],
)

#show: front-matter

#cover(style: "full")
```
]

== Copyright page

The #cmd("copyright-page") function renders a compact, canonical copyright page for front matter. It is opt-in and intended to be called after a cover. In Tufte mode it automatically uses a wide block so the legal metadata spans the full page width.

#command("copyright-page", ..args(
	misc-credits: none,
	notice: auto,
))[
	#argument("misc-credits", default: none, types: "dict")[Additional role-to-name credits to print after the ISBN, for example `(translator: "A. Translator", cover: "B. Artist")`. Role labels are localized when a matching i18n key exists.]

	#argument("notice", default: auto, types: (auto, "content", "none"))[Copyright notice override for this page. `auto` uses `copyright-notice:` from `bookily(...)` when present, otherwise builds `© <current year> <author>. All rights reserved.`]
]

`copyright-page()` pulls the following data from template states initialized by `bookily(...)`: `publisher`, `editions`, `isbn`, `author`, `copyright-notice`, `localization`, `config-options.font-size-small`, and `tufte`.

#codesnippet[
```typ
#show: bookily.with(
  author: (name: "Author Name"),
  publisher: (
    commercial-name: "The Publisher",
    legal-name: "The Publisher Ltd.",
    webpage: "https://publisher.example",
    location: (city: "Paris", country: "France"),
  ),
  editions: ((year: 2026, month: 5, name: "First edition"),),
  isbn: "978-0-00-000000-0",
  title-page: [],
)

#show: front-matter
#copyright-page(
  misc-credits: (
    translator: "A. Translator",
    "cover-artist": "B. Artist",
  ),
)
```
]

== Publishing data models <ss:publishing-data-models>

The publishing metadata accepted by `bookily(...)` is intentionally small and validated. Unknown keys cause an error, which helps catch typos before the manual, cover, or copyright page is rendered.

=== Author-shaped values

The `author`, `translators`, `editors`, `illustrators`, and `cover-artist` arguments accept a string, a dictionary, or an array of strings/dictionaries.

Allowed author dictionary keys:
#v(0.5em)
- `name` #dtype(str) -- Display name used in the document metadata, covers, title pages, and back-cover helpers.
- `dob` #dtype(str) -- Date or year of birth.
- `pob` #dtype(str) -- Place of birth.
- `dod` #dtype(str) -- Date or year of death.
- `pod` #dtype(str) -- Place of death.
- `website` #dtype(str) -- Author website URL.
- `socials` #dtype(dictionary) -- Social links keyed by platform name.
- `wikipedia` #dtype(str) -- Wikipedia URL or page identifier.
- `viaf` #dtype(str) -- VIAF identifier or URL.

#codesnippet[
```typ
// String form
author: "Author Name"

// Dictionary form
author: (
  name: "Author Name",
  dob: "1970",
  pob: "Lyon, France",
  website: "https://author.example",
  socials: (mastodon: "@author@example.social"),
  wikipedia: "https://en.wikipedia.org/wiki/Author",
  viaf: "123456789",
)

// Array form
author: (
  (name: "First Author"),
  (name: "Second Author"),
)
```
]

=== Publisher values

The `publisher` argument accepts a string or a dictionary. A string is normalized to `(commercial-name: "...")`.

Allowed publisher dictionary keys:
#v(0.5em)
- `commercial-name` #dtype(str) -- Public imprint name used on covers and copyright pages.
- `legal-name` #dtype(str) -- Legal entity name, printed on the copyright page when different from `commercial-name`.
- `logo` #dtype(content) -- Publisher logo rendered by `copyright-page()`.
- `webpage` #dtype(str) -- Publisher URL rendered as a link on the copyright page.
- `socials` #dtype(dictionary) -- Social links keyed by platform name. Stored for downstream use.
- `location` #dtype("str or dictionary") -- Publisher location. As a dictionary, allowed keys are `country`, `city`, and `address`.

#codesnippet[
```typ
// String form
publisher: "The Publisher"

// Dictionary form
publisher: (
  commercial-name: "The Publisher",
  legal-name: "The Publisher Ltd.",
  logo: image("images/publisher-logo.svg", width: 20%),
  webpage: "https://publisher.example",
  socials: (mastodon: "@publisher@example.social"),
  location: (
    address: "1 Publisher Street",
    city: "Paris",
    country: "France",
  ),
)
```
]

=== Edition values

The `editions` argument accepts an array of dictionaries. Each dictionary must include `year`; entries are sorted ascending by `(year, month, day)` before rendering.

Allowed edition dictionary keys:
#v(0.5em)
- `year` #dtype(int) -- Required edition year.
- `month` #dtype(int) -- Optional month number.
- `day` #dtype(int) -- Optional day of month.
- `publisher` #dtype("str or dictionary") -- Optional edition-specific publisher; falls back to the top-level `publisher` when omitted.
- `name` #dtype(str) -- Optional edition label such as `"First edition"`, `"Revised edition"`, or `"Paperback edition"`.

#codesnippet[
```typ
editions: (
  (year: 2026, month: 5, name: "First edition"),
  (
    year: 2027,
    month: 2,
    day: 14,
    name: "Second printing",
    publisher: (commercial-name: "The Publisher"),
  ),
)
```
]

== Title pages

The template still provides two legacy functions to create title pages: one for a book and one for a thesis. They are preserved for existing documents. For new trade-publishing projects, prefer the explicit `#cover()` and `#copyright-page()` front-matter path.

=== book-title-page (legacy — recommended path is `#cover()` for new documents)

#command("book-title-page",
..args(
	subtitle: none,
	subsubtitle: none,
	subsubsubtitle: none,
	epigraph: none,
  edition: "First edition",
  institution: "Institution",
  publishing-house: auto,
  series: "Discipline",
  collection: auto,
  year: "2026",
  cover: none,
  logo: none,
)
)[
	#argument("subtitle", default: none, types: ("string", "content", "none"))[Subtitle override. If omitted, the value from `bookily(subtitle: ...)` is used.]

	#argument("subsubtitle", default: none, types: ("string", "content", "none"))[Second-level subtitle override. If omitted, the value from `bookily(subsubtitle: ...)` is used.]

	#argument("subsubsubtitle", default: none, types: ("string", "content", "none"))[Third-level subtitle override. If omitted, the value from `bookily(subsubsubtitle: ...)` is used.]

	#argument("epigraph", default: none, types: ("content", "none"))[Epigraph override. If omitted, the value from `bookily(epigraph: ...)` is used.]

	#argument("edition", default: "First edition", types: "string")[Edition of the book.]

	#argument("institution", default: "Institution", types: "string")[Legacy alias for `publishing-house`. Preserved for compatibility.]

	#argument("publishing-house", default: auto, types: (auto, "string", "content"))[Preferred v0.2.0 name for the publishing house or publisher imprint displayed in the footer. When set, it overrides `institution`.]

	#argument("series", default: "Discipline", types: "string")[Legacy alias for `collection`. Preserved for compatibility.]

	#argument("collection", default: auto, types: (auto, "string", "content"))[Preferred v0.2.0 name for the collection, series, or imprint line displayed in the header. When set, it overrides `series`.]

	#argument("year", default: "2026", types: ("int", "string"))[Year of publication.]

	#argument("cover", default: none, types: "image")[Cover image of the book.]

	#argument("logo", default: none, types: "image")[Logo of the book.]
]

#codesnippet[
```typ
#show: bookily.with(
	title-page: book-title-page(
		publishing-house: "The Publisher",
		collection: "Collection Name",
		logo: image("path_to_logo/logo.png"),
		cover: image("path_to_image/book-cover.jpg")
	)
)
```
]

=== thesis-title-page (legacy academic helper)

#command("thesis-title-page",
..args(
	type: "phd",
  school: "School name",
  doctoral-school: "Name of the doctoral school",
  supervisor: ("Supervisor name",),
  cosupervisor: none,
  laboratory: "Laboratory name",
  defense-date: "01 January 1970",
  discipline: "Discipline",
  specialty: "Speciality",
  committee: (:),
  logo: none,
	[body]
)
)[
	#argument("type", default: "phd", types: "string")[
		Type of thesis. Two values are possible:
		- `"phd"` for a doctoral thesis
		- `"hablitation"` for a French habilitation
	]

	#argument("school", default: "School name", types: "string")[Name of the institution where the thesis was prepared.]

	#argument("doctoral-school", default: "Name of the doctoral school", types: "string")[Name of the doctoral school.]

	#argument("supervisor", default: ("Supervisor name",), types: "array")[Name of the thesis supervisor(s) or the guarantor of the habilitation.]

	#argument("cosupervisor", default: none, types: "array")[Name of the thesis co-supervisor(s).]

	#argument("laboratory", default: "Laboratory name", types: "string")[Name of the research laboratory.]

	#argument("defense-date", default: "01 January 1970", types: "string")[Date of the thesis defense.]

	#argument("discipline", default: "Discipline", types: "string")[Name of the discipline.]

	#argument("specialty", default: "Speciality", types: "string")[Name of the specialty.]

	#argument("committee", default: (:), types: "array")[

		Name of the thesis committee members. Each element of the array is a #dtype(dictionary) with the following keys:
		- `name`: Name of the committee member.
		- `position`: Position of the committee member (e.g., "Associate Professor", "Professor", etc.).
		- `affiliation`: Affiliation of the committee member (e.g., "University Name").
		- `role`: Role of the committee member (e.g., "Chair", "Member", "Reviewer").

	]

	#argument("logo", default: none, types: "image")[Logo of the institution.]
]

#codesnippet(
```typ
#let committee = (
	(
		name: "Hari Seldon",
		position: "Full Professor",
		affiliation: "Streeling university",
		role: "President",
	),
	(
		name: "Gal Dornick",
		position: "Associate Professor",
		affiliation: "Synnax University",
		role: "Reviewer"
	),
)

#show: bookily.with(
	title-page: thesis-title-page(
		supervisor: ("Supervisor A", "Supervisor B"),
		cosupervisor: ("Co-supervisor A", "Co-supervisor B"),
		committee: committee
	)
)
```
)

#info-alert[For both legacy title pages, the title of the document and its author are automatically generated based on the information given when initializing the template.]

== Back cover

The legacy #cmd("back-cover") helper is preserved for existing thesis-style and academic documents. It displays information about the document (title and author), as well as summaries in one or more languages.

#command("back-cover", ..args(
	resume: none,
	abstract: none,
	abstracts: (),
	logo: none
))[
	#argument("abstracts", types: "dictionary")[Title and summary of the document.
		#codesnippet[
			```typ
			#let abstracts-en-fr-de = (
				(
					title: [#set text(lang: "en", region: "gb"); Abstract:],
					text: [#set text(lang: "en", region: "gb")
						This paper presents the objectives, methodology, and main results of the work.
					]
				),
				(
					title: [#set text(lang: "fr"); Résumé :],
					text: [#set text(lang: "fr")
						Cet article présente les objectifs, la méthodologie et les principaux résultats du travail.
					]
				),
				(
					title: [#set text(lang: "de"); Zusammenfassung],
					text: [#set text(lang: "de")
						Diese Arbeit beschreibt die Ziele, die Methodik und die wichtigsten Ergebnisse.
					]
				)
			)

			#back-cover(abstracts: abstracts-en-fr-de, logo: box[logo])
			```
		]
	]

	#argument("logo", types: array)[Logo of the back cover.
		#codesnippet[
			```typ
			#let logos = (
				align(left)[#image("images/devise_cnam.svg", width: 45%)],
				align(right)[#image("images/logo_cnam.png", width: 50%)]
			)

			#back-cover(resume: lorem(10), abstract: lorem(10), logo: logos)
			```
		]
	]
]

== Tufte layout <ss:tufte>

When the `tufte` layout is selected, several customizations are applied to adapt the appearance of various elements (figures, tables, equations, etc.) to the Tufte style.

#command("note", ..args(
	"..note-args",
	[body]
	)
)[
	#argument("..note-args",  types: "arguments")[Arguments of the #cmd("note") function provided by the `marginalia` package.

	#info-alert[`bookily` introduces some customization of the `marginalia` #cmd("note") as follows:

	#codesnippet[
			```typ
			#let note = note.with(
				counter: ...,
				numbering: ...,
				keep-order: true
			)
 			```
 		]
	]
	]
]

#command("notefigure", ..args(
	"..notefigure-args",
	[body]
))[
	#argument("..notefigure-args", types: "arguments")[Arguments of the #cmd("notefigure") function provided by the `marginalia` package.

	#info-alert[`bookily` introduces a slight customization of the `marginalia` #cmd("notefigure") as follows:
		#codesnippet[
				```typ
				#let notefigure = notefigure.with(keep-order: true)
				```
		]
	]
	]
]

#command("notecite", ..args(
	"key",
	dy: -1.5em,
	alignment: "baseline",
	supplement: none,
))[
	#argument("key", types: "label")[Key of the reference to cite.]

	#argument("dy", default: -1.5em, types: "length")[Vertical adjustment of the notecite position.]

	#argument("alignment", default: "baseline", types: "string")[Alignment of the notecite. Possible values are:
	- `"top"`: Align the top of the notecite with the reference.
	- `"caption-top"`: Align the top of the notecite with the main text baseline.
	- `"bottom"`: Align the bottom of the notecite with the reference.
	- `"baseline"` (default): Align the baseline of the notecite with the main text baseline.
	]

	#argument("supplement", default: none, types: "string")[Supplementary text to add before the citation (e.g., "see", "e.g.", etc.).]
]

#command("wideblock", ..args(
	"side",
	[body]
))[
	#argument("side", types: (auto, str))[
		Side of the wide block. Possible values are:
		- `auto`: Same as `"outer"`
		- `"outer"`: The wide block is displayed on the outer side of the page.
		- `"inner"`: The wide block is displayed on the inner side of the page.
		- `"left"`: The wide block is displayed on the left side of the page.
		- `"right"`: The wide block is displayed on the right side of the page
	]
]

#info-alert[To define a full-width figure in the `tufte` layout, you can use the `wideblock` function with the `side` argument set to `auto` or `outer`. For example:

	#codesnippet[
		```typ
		#wideblock[
			#figure(image("path_to_image/figure.png"), caption: [Full width figure])
		]
		```
	]
]

= Theming

The theming system is designed to be flexible and customizable, allowing users to define their own themes.

== Custom theme definition

To implement a custom theme, you have to define a function that includes the `show` and `set` rules defining the style of the document (headings, footnotes, references, #sym.dots). Basically, a theme should be structured as follows:
#codesnippet[
```typ
// my-theme.typ
#import "@preview/bookily:0.1.0": *

#let my-theme(colors: default-colors, it) = {
	// Update the theme state
	states.theme.update("custom")

	// Heading Level 1 style
	show heading.where(level: 1): it => {
		// Page break before each part
		if not states.open-right.get() {pagebreak(weak: true)}
		...
	}

  // Heading Level 2 style
	show heading.where(level: 2): it => {...}

	// Heading Level 3 style
	show heading.where(level: 3): it => {...

	// Outline entry style
	show outline.entry: it => {...}

	// Other show and set rules
	...

	it
}
```
]

You can also define your own functions such as #cmd("part"), #cmd("minitoc") and other elements of the document.

#info-alert[Examples of theming are available in the #link("https://github.com/cesasol/bookily")[Github repository] of the template.]

Then, you can initialize the template with your custom theme as follows:
#codesnippet[
	```typ
	#import "path_to_file/my-theme.typ": *

	#show: bookily.with(
		theme: my-theme,
		...
	)
	```
]

#info-alert[If you use a multiple files structure with a #sym.ast\.typ file for each chapter, you can type at the top of each file the following code to access the functions like #cmd("part") or #cmd("minitoc") defined in the theme file.

	#codesnippet[
		```typ
		#import "path_to_file/my-theme.typ": *
		```
	]
]

== Template states

`bookily` provides some states that can be useful when designing a custom theme. The states are used to store information about the current state of the document. They are collected in a #dtype(dictionary). The following states are available:

#v(1em)
- `states.alt-margins` -- #dtype(bool): Indicates whether the margins are alternated for odd and even pages when `tufte` layout is enabled.

- `states.author` -- #dtype("str/dict/array"): Normalized author metadata for the document.

- `states.colors` -- #dtype(dictionary): Color scheme for the document.

- `states.copyright-notice` -- #dtype(content): Optional copyright notice override used by `copyright-page()`.

- `states.counter-part` -- #dtype(str): Counter for parts.

- `states.cover-artist` -- #dtype("str/dict/array"): Normalized cover artist credit metadata.

- `states.cover-defaults` -- #dtype(dictionary): Default title hierarchy values consumed by `#cover()`.

- `states.editions` -- #dtype(array): Normalized and date-sorted edition history.

- `states.editors` -- #dtype("str/dict/array"): Normalized editor credit metadata.

- `states.epigraph` -- #dtype(content): Optional epigraph rendered on the cover, between two horizontal rules.

- `states.hyphenate-titles` -- #dtype(bool): Indicates whether the cover title hierarchy, chapter (level-1) headings, and part titles are allowed to hyphenate.

- `states.in-outline` -- #dtype(bool): Indicates whether the current section is in the outline.

- `states.isappendix` -- #dtype(bool): Indicates whether the current section is an appendix.

- `states.isfrontmatter` -- #dtype(bool): Indicates whether the current section is front matter.

- `states.illustrators` -- #dtype("str/dict/array"): Normalized illustrator credit metadata.

- `states.isbn` -- #dtype(str): ISBN rendered by `copyright-page()` when present.

- `states.localization` -- #dtype(dictionary): Dictionary of terms used in the document (e.g., "chapter", etc.) in the selected language.

#info-alert[If you need to use a language that is not supported by default, you can modify the `states.localization` dictionary when initializing the template.

For example, to add support for Dutch, you can do the following `#states.localization.update(json("path_to_file/dutch.json"))`. The JSON file should contain the translations of the terms used in the document. For the english version, the JSON  file is as follows:
```json
{
    "and": " and ",
    "appendix": "Appendix",
    "authored": "authored by",
    "chapter": "Chapter",
    "committee": "Defense committee",
    "cosupervisor": "Co-supervisor:",
    "cosupervisors": "Co-supervisors:",
    "defended": "defended on",
    "discipline": "Discipline:",
    "doctoral-school": "DOCTORAL SCHOOL",
    "habilitation": "French Habilitation to supervise research",
    "lof": "List of figures",
    "lot": "List of tables",
    "note": "Note",
    "part": "Part",
    "phd": "Doctoral thesis",
    "proof": "Proof",
    "specialty": "Specialty:",
    "sponsor": "Sponsor:",
    "sponsors": "Sponsors:",
    "supervisor": "Supervisor:",
    "supervisors": "Supervisors:",
    "tip": "Tip",
    "toc": "Table of contents",
    "version-usage": "This version of  can be viewed and downloaded free of charge for personal use only. It must not be redistributed, sold, or used in derivative works.",
    "warning": "Warning"
}
```
]

- `states.num-heading` -- #dtype(str): Numbering pattern for headings.

- `states.num-pattern` -- #dtype(str): Numbering pattern for sections.

- `states.num-pattern-eq` -- #dtype(str): Numbering pattern for equations.

- `states.num-pattern-fig` -- #dtype(str): Numbering pattern for figures.

- `states.num-pattern-subfig` -- #dtype(str): Numbering pattern for subfigures.

- `states.open-right` -- #dtype(bool): Indicates whether parts and chapters start on a right-hand page.

- `states.page-numbering` -- #dtype(str): Numbering pattern for pages.

- `states.part-numbering` -- #dtype(str): Numbering pattern for parts.

- `states.publisher` -- #dtype("str/dict"): Normalized publisher or publishing house metadata.

- `states.sidenotecounter` -- #dtype(int): Counter for sidenotes.

- `states.subsubsubtitle` -- #dtype(content): Optional third-level subtitle rendered on the cover.

- `states.subsubtitle` -- #dtype(content): Optional second-level subtitle rendered on the cover.

- `states.subtitle` -- #dtype(content): Optional subtitle rendered on the cover.

- `states.theme` -- #dtype(str): Current theme of the document.

- `states.title` -- #dtype(str): Title of the document.

- `states.translators` -- #dtype("str/dict/array"): Normalized translator credit metadata.

- `states.tufte` -- #dtype(bool): Indicates whether the current layout is Tufte style.

#info-alert[
	`bookily` also comes with a function #cmd("reset-counters") to reset the counters for equations, figures, tables, sidenotes, and footnotes.
]

= Dependencies

The `bookily` template relies on several #Typst packages to provide additional functionalities:
#v(0.5em)
- `marginalia:0.3.1`: for tufte layout.
- `hydra:0.6.2` : for bibliography management.
- `equate:0.3.2` : for advanced equation numbering.
- `itemize:0.2.0"`: for lists and enumerations customization.
- `showybox:2.0.4` : for custom boxes.
- `suboutline:0.3.0` : for mini tables of contents in chapters.
- `subpar:0.2.2` : for subfigures.

= Change logs

This section provides a summary of the changes made in each version of the template.

#text(size: 1.5em)[*v0.2.0 -- May 2026*]

This additive release extends the trade-publishing surface of `bookily`:
#v(0.5em)
- Adds the standalone `cover()` system with five cover styles and `cover-defaults` metadata.

- Adds `copyright-page()` for publisher, edition history, ISBN, misc credits, and copyright notices.

- Adds structured author-shaped credits (`translators`, `editors`, `illustrators`, `cover-artist`), `publisher`, and `editions` data models.

- Keeps legacy `book-title-page`, `thesis-title-page`, and `back-cover` helpers while recommending `#cover()` for new trade books.

- Deprecates the legacy `obook` and `pretty` themes; prefer `classic`, `fancy`, `modern`, or `orly` for new documents.

#v(1em)
#text(size: 1.5em)[*v3.1.1 -- April 2026*]

This minor release fixes minor bugs in `obook` theme and numbering problems.

#text(size: 1.5em)[*v3.1.0 -- April 2026*]

This release fixes several theming issues in `modern` and `pretty` themes.

This release also adds a new theme, `obook`, which is an adaptation of the Legrand orange book template.

#text(size: 1.5em)[*v3.0.0 -- April 2026*]

This release introduces a major refactoring of the code to improve the implementation of the `tufte` layout and make its maintenance easier. This refactoring was necessary to solve some issues related to the `tufte` layout, particularly when the `alt-margins` option was enabled.

With this release, the API of the functions related to the `tufte` layout has been updated to take advantage of the features provided by the `marginalia` package. In particular :
#v(0.5em)
- #cmd("sidenote") function has been removed in favor of the #cmd("note") function provided by the `marginalia` package.

- #cmd("sidefigure") function has been removed in favor of the #cmd("notefigure") function provided by the `marginalia` package.

- #cmd("sidecite") function has been renamed to #cmd("notecite") to be consistent with the function naming used in the `marginalia` package.

- #cmd("fullwidth") function has been removed in favor of the #cmd("wideblock") function provided by the `marginalia` package.

- #cmd("fullfigure") function has been removed.

#v(1em)
#text(size: 1.5em)[*v2.1.1 & v2.1.2 -- April 2026*]

These two patch releases fix theming issues due to `tufte` layout and `alt-margins` options and some typographical issues in the themes.

#v(1em)
#text(size: 1.5em)[*v2.1.0 -- March 2026*]

This release introduces a new boolean argument `alt-margins` to the `config-options` dictionary. This argument allows using alternating margins when `tufte` layout is enabled.

#v(1em)
#text(size: 1.5em)[*v2.0.0 -- March 2026*]

This new release introduces a breaking change in the API of the sidenote function.
This change aims at making the sidenote referenceable.

#v(1em)
#text(size: 1.5em)[*v1.2.0 -- February 2026*]

This release introduces several new features and improvements:
#v(0.5em)
- Chinese is now officially supported as "zh".

- Introduction of open-right option in config-options to allow user choosing between continuous layout and insertion of blank pages between chapters and parts.

- Refactor back-cover function to take any abstract in any language.

#v(1em)
#text(size: 1.5em)[*v1.1.2 -- December 2025*]

This update fixes some minor bugs in the `tufte` layout implementation.

#v(1em)
#text(size: 1.5em)[*v1.1.0 -- October 2025*]

This release adds the new theme `pretty` as well as new supported languages (`"de"`, `"es"`, `"pt"`).

#v(1em)
#text(size: 1.5em)[*v1.0.0 -- October 2025*]

This new release marks the point at which `bookily` is considered feature-complete, hence the version number.

This release introduces a number of new features, the most important of which are:
#v(0.5em)
- Theming refactoring, which enables custom themes to be defined in a user-friendly manner.

- 'tufte' layout: Inspired by the works of Edward Tufte, this layout is characterised by wide margins that can be used for side notes, figures and other elements. It comes with several functions: `sidenote`, `sidefigure`, `sidecite`, `fullfigure` and `fullwidth`.

- A new theme, 'orly', which mimics the style of O'Reilly books.
#v(1em)
#text(size: 1.5em)[*v0.1.0 -- September 2025*]

Initial release of the `bookily` template.
