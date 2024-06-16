---
title: Parse object accessors recursively
description: Concise example of utilizing Pest grammars to recursively parse object accessors
licence: AGPL-3.0
author: S0AndS0
layout: post
date: 2024-05-22 11:52:05:21 -0800
time_to_live: 1800
tags: [ rust, pest, parsing ]
image: assets/images/rust/pest-parse-object-accessors-recursively/first-code-block.png

social_comment:
  links:
    - text: Twitter
      href: https://x.com/S0_And_S0/status/1802140358719017193
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: Pest Book -- Syntax of pest grammars -- The stack (WIP)
      href: https://pest.rs/book/grammars/syntax.html?highlight=rust%20string#the-stack-wip
      title: Example of parsing Rust string literal blocks of text
---



## Pest grammar


```pest
object = { word ~ accessor* }

word = { ASCII_ALPHANUMERIC+ }

accessor = { (prop | key) ~ accessor* }

prop = { "." ~ word }
key = { "[" ~ object ~ "]" }
```


### Example input

```
name.prop[key]
```

### Example result

```
- object
  - word: "name"
  - accessor
    - prop > word: "prop"
    - accessor > key > object > word: "key"
```

