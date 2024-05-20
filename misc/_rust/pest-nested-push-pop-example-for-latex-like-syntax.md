---
title: Nested PUSH/POP example for LaTeX (like) syntax
licence: AGPL-3.0
author: S0AndS0
layout: post
date: 2024-05-19 19:56:21 -0800
time_to_live: 1800
tags: [ rust, pest, parsing, latex ]
image: assets/images/rust/pest-nested-push-pop-example-for-latex-like-syntax/first-code-block.png

social_comment:
  links:
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_nested-pushpop-example-for-latex-like-activity-7198469051004645376-CUge
      title: Link to Post thread for this post

    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/112476077715689897
      title: Link to Toot thread for this post

    - text: Twitter
      href: https://x.com/S0_And_S0/status/1792703310908334248
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: Pest Book -- Syntax of pest grammars -- The stack (WIP)
      href: https://pest.rs/book/grammars/syntax.html?highlight=rust%20string#the-stack-wip
      title: Example of parsing Rust string literal blocks of text

    - text: Pest Discussions -- `778` -- Matching inner blocks with PUSH and POP
      href: https://github.com/pest-parser/pest/discussions/778
      title: The question that inspired this blog post exploring the Pest stack
---



## TLDR


Here's a minimalistic/naive set of pest configurations that _should_ allow for
nested blocks of code begin/end tags that may, or may not, contain raw text
too.

```pest
//! title: Nested PUSH/POP minimal example for LaTeX (like) syntax
//! licence: AGPL-3.0
//! author: [S0AndS0](https://github.com/S0AndS0)

document = { SOI ~ node* ~ EOI }

node    = _{ latex | content }
content =  { ( !(end | begin | latex) ~ ANY )+ }
latex   =  { begin ~ (!end ~ node)* ~ end }

name  =  { (!"}" ~ ASCII_ALPHA)+ }
begin = ${ "\\begin{" ~ PUSH(name) ~ "}" }
end   = @{ "\\end{" ~ POP ~ "}" }
```

### Example input

```latex
outer before
\begin{foo}
foo before
\begin{bar}
inner bar
\end{bar}
foo after
\end{foo}
outer after
```

### Parser result

```
- document
  - content: "outer before\n"
  - latex
    - begin > name: "foo"
    - content: "\nfoo before\n"
    - latex
      - begin > name: "bar"
      - content: "\ninner bar\n"
      - end: "\\end{bar}"
    - content: "\nfoo after\n"
    - end: "\\end{foo}"
  - content: "\nouter after"
```


______


## Stack example one (the happy path)


With the following input, we can explore line by line

```latex
outer before
\begin{foo}
foo before
\begin{bar}
inner bar
\end{bar}
foo after
\end{foo}
outer after
```

- Input `outer before\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`o` != `\`)
  - passes `content` which consumes `outer before\n`
- Input "`\begin{foo}`" passes up-to → `document` → `node` → `latex` → "`\\begin`" → `name`
  - `PUSH(name)` if `name` rule succeeds, which it does, puts `bar` onto the stack
- Input `\nfoo before\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`\n` != `\`)
  - passes `content` which consumes `\nfoo before\n`
- Input "`\begin{bar}`" passes up-to → `document` → `node` → `latex` → "`\\begin`" → `name`
  - `PUSH(name)` if `name` rule succeeds, which it does, puts `bar` onto the stack
- Input `\ninner bar\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`\n` != `\`)
  - passes `content` which consumes `\ninner bar\n`

Now we get to the _fun_ stuff, our stack currently has a shape similar to the following table;

| index | value |
|-------|-------|
|     0 | `bar` |
|     1 | `foo` |

- Input "`\end{bar}`": passes up-to → `document` → `node` → `latex`
  - Rule: `end   = ${ "\\end{" ~ POP ~ "}" }`
  - when `POP` _pops_ expands to `end   = ${ "\\end{" ~ "bar" ~ "}" }` (AKA `"\\end{bar}"`)
  - which passes the `end` constraint and our stack now looks like the following;

| index | value |
|-------|-------|
|     0 | `foo` |

- Input `\nfoo after\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`\n` != `\`)
  - passes `content` which consumes `\nfoo after\n`
- Input "`\end{foo}`": passes up-to → `document` → `node` → `latex` → `end`
  - Rule: `end   = ${ "\\end{" ~ POP ~ "}" }`
  - Expands to `end   = ${ "\\end{" ~ "bar" ~ "}" }` (AKA `"\\end{foo}"`)
  - which passes the `end` constraint and our stack is now empty
- Input `\nouter after\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`\n` != `\`)
  - passes `content` which consumes `\nouter after\n`


______


## Stack example two (an unhappy path)


With the next input we can expose some gotchas;

```latex
\begin{first}
sad
\end{nope}
```

... Above _should_ produce the following error;

```
 --> 3:11
  |
3 | \end{nope}
  |           ^---
  |
  = expected begin, content, or end
```

This behavior took me a bit, about an hour of fiddling, to fully wrap my by
brain around so to hopefully save others some pain I'll go line by line.

- Input `\begin{first}`: passes `document` → `node` → `latex` → `begin`, and the stack looks something like;

| index | value   |
|-------|---------|
|    0  | `first` |

- Input `\nsad\n`: passes up to → `document` → `node`
  - fails `latex` → `begin` at the first character/comparison (`\n` != `\`)
  - passes `content` which consumes `\nsad\n`
- Input `\end{nope}`: passes `document` → `node` → `latex`
  - but fails within `end` once the `POP`-ed value attempts to match
  - Rule: `end   = ${ "\\end{" ~ POP ~ "}" }`
  - Expands to `end   = ${ "\\end{" ~ "first" ~ "}" }` (AKA `"\\end{first}"`)
  - Bubbling-up `latex` fails
  - Then `node` fails, after checking `content` rules
  - Finally we're at the _root_ `document` rule, which wants a start of input (`SOI`) some number of `node`-s, and an end of input (`EOI`)

⚠ Note without the `EOI` rule in particular, `document` would be happy to
silently say _"nothing to parse"_, and we'd never get an error popping!  This
little bit is what took most of my time figuring out; I.E. one must constrain
the topmost rule to the minimum correct input, or errors may never get reported
🤦


______


## Stack example three (panicky path)


Consider the next input and, perhaps prior to reading future, hazard a guess as
to what we can expect...

```latex
\end{empty}
```

... Which produces the following partial parser result;

```
- document
  - content: "\\end"
  - EOI: ""
```

- Input `\end{` is attempted to be read by both `latex` and `content` rules but;
  - fails `document` → `node` → `latex` → `start` at the second character (`e` != `b`)
  - fails `document` → `node` → `content` → `end` at `POP`, and in such a way we don't get `{empty}` as part of the `content` too!

Result is, at least via the [Pest Playground][], we are blessed with the
following error message within the web-browser's console...

```
Uncaught RuntimeError: unreachable executed
```

... This ain't good, and may be a bug in the web-site or worse the crate,
because adjusting rules to make use of `PEEK` has the same effect, eg.

```pest
//! title: Nested PUSH/POP minimal example for LaTeX (like) syntax
//! licence: AGPL-3.0
//! author: [S0AndS0](https://github.com/S0AndS0)

document = { SOI ~ node* ~ EOI }

node = _{ latex | content }

latex       =  { begin ~ (!end ~ node)* ~ end }
name        =  { (!"}" ~ ASCII_ALPHA)+ }
begin       = ${ "\\begin{" ~ PUSH(name) ~ "}" }
end         = ${ "\\end{" ~ POP ~ "}" }
end__test   = ${ "\\end{" ~ PEEK ~ "}" }

content = { ( !(end__test | begin | latex) ~ ANY )+ }
```

Or I could totally be wrong in expectations and/or implementation 🤷



[Pest Playground]: https://pest.rs/#editor

