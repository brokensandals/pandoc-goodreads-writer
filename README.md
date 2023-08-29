# Overview

This is a [custom Pandoc writer](https://pandoc.org/custom-writers.html) that outputs the [syntax used for writing reviews on Goodreads](https://help.goodreads.com/s/article/How-do-I-format-text-into-html-1553870934599). This syntax is similar to HTML, but does not ignore line breaks, and supports some extra stuff like a `spoiler` tag.

# Usage

Download the [pandoc-goodreads-writer.lua](pandoc-goodreads-writer.lua) file and use `-t path/to/pandoc-goodreads-writer.lua` when invoking pandoc.

# Features and flaws

Currently supported:

- Bold and italic text
- Hyperlinks
- Blockquotes
- Ordered and unordered lists
- Spoiler tags (see below)

Not supported yet:

- Images
- Book/author links
- Underlined and strikethrough text
- Footnotes (something will get rendered, but it won't look right)

Partially supported:

- Citations - it works with [at least the one particular CSL style that I currently use](https://github.com/citation-style-language/styles/blob/master/chicago-fullnote-bibliography-with-ibid.csl), but not others

## Spoiler tags

Use the `spoiler` class to denote spoilers. In Pandoc markdown, that means either:

```
doing [this]{.spoiler} for an inline spoiler
```

Or:

```
::: {.spoiler}
Doing this to mark a whole block as a spoiler.
:::
```

# Testing

Some test pandoc markdown files are in [test/in](test/in) and the corresponding outputs are in [test/expected](test/expected).

There is a script that will run pandoc on all the test files and diff the outputs against the expected outputs. To ensure you're using the intended version of pandoc, I suggest running them in Docker. If you have Docker installed and are on Mac/Linux, just run `./test/docker-test.sh` to build the image and run the tests.

# License

See the [LICENSE](LICENSE) file for the license applicable to most of this project.

The tests include one or more CSL styles, which were copied from the [citation-style-language/styles repository](https://github.com/citation-style-language/styles) and are licensed under the [Creative Commons Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0) license](https://creativecommons.org/licenses/by-sa/3.0/). Information about CSL is available at [https://citationstyles.org/](https://citationstyles.org/).
