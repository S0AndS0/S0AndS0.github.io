---
vim: filetype=markdown.liquid
title: RegExp match programming case conventions
description: "TLDR `echo matchstrlist(['userId'], '\\v(\\u+\\l*)|(\\l+)|(\\d+)|(\\D|\\A)')`"
layout: post
date: 2024-09-09 12:22:38 -0700
time_to_live: 1800
author: S0AndS0
tags: [ regexp, vim ]
image: assets/images/vim/regexp-match-programming-case-conventions/first-code-block.png

# social_comment:
#   links:
#     - text: LinkedIn
#       href: 
#       title: Link to LinkedIn thread for this post
# 
#     - text: Mastodon
#       href: 
#       title: Link to Mastodon Toots for this post
# 
#     - text: Twitter
#       href: 
#       title: Link to Tweet thread for this post
---

## TLDR

Use either `<cWORD>` or `<cword>` to capture the big/small word under the
cursor with the following Regular Expression;

```vim
:echo matchstrlist(
    \   [ expand('<cWORD>') ],
    \   '\v(\u+\l*)|(\l+)|(\d+)|(\D|\A)'
    \ )
```

...  This will create a list of data structures which split common programming
case patterns, as well as symbols, for further parsing.

<details><summary>Regular Expression details</summary>
{% capture details_summary_content %}
**Character codes**

- `\u` → Uppercase character
- `\l` → lowercase character
- `\d` → digit
- `\D` → non-digit
- `\A` → non-alphabetic character
- `|` → OR, either right or left side of vertical bar may match
- `()` → capture group of expression(s)

**Explanation of capture groups**

- `\v` → Enable _very magic_ mode, so we need not escape parentheses 
- `(\u+\l*)` → Match at least one uppercase followed by zero or more lowercase
  characters
- `(\l+)` → Match at least one lowercase character
- `(\d)` → Match at least one numerical character
- `(\D|\A)` → Match one non-digit or non-alphabetic character
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>

<details><summary>Example input / output results</summary>
{% capture details_summary_content %}
- `flatcase`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'flatcase'}
   ]
   ```
- `camelCase`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'camel'},
     {'byteidx': 5, 'idx': 0, 'text': 'Case'}
   ]
   ```
- `PascalCase`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'Pascal'},
     {'byteidx': 6, 'idx': 0, 'text': 'Case'}
   ]
   ```
- `snake_case`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'snake'},
     {'byteidx': 5, 'idx': 0, 'text': '_'},
     {'byteidx': 6, 'idx': 0, 'text': 'case'}
   ]
   ```
- `SCREEMING_SNAKE_CASE`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'SCREEMING'},
     {'byteidx': 9, 'idx': 0, 'text': '_'},
     {'byteidx': 10, 'idx': 0, 'text': 'SNAKE'},
     {'byteidx': 15, 'idx': 0, 'text': '_'},
     {'byteidx': 16, 'idx': 0, 'text': 'CASE'}
   ]
   ```
- `kabab-case`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'kabab'},
     {'byteidx': 5, 'idx': 0, 'text': '-'},
     {'byteidx': 6, 'idx': 0, 'text': 'case'}
   ]
   ```
- `TRAIN-CASE`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'TRAIN'},
     {'byteidx': 5, 'idx': 0, 'text': '-'},
     {'byteidx': 6, 'idx': 0, 'text': 'CASE'}
   ]
   ```
- `instanceName.methodCall`
   ```vim
   [
     {'byteidx': 0, 'idx': 0, 'text': 'instance'},
     {'byteidx': 8, 'idx': 0, 'text': 'Name'},
     {'byteidx': 12, 'idx': 0, 'text': '.'},
     {'byteidx': 13, 'idx': 0, 'text': 'method'},
     {'byteidx': 19, 'idx': 0, 'text': 'Call'}
   ]
   ```
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


______


## Story time


I use spell-check, a lot!  But naming conventions like `camelCase` for
languages, such as JavaScript, either creates issues of false positives
littering my buffer or I'm forced to disable spellcheck...  which when combined
with tab-completion plugins leads to me consistently misspelling things.

So after many moons of frustration tracking down past mistakes I figured it
time to add a feature or two to my
[`vim-utilities/spelling-shortcuts`](https://github.com/vim-utilities/spelling-shortcuts)
plugin.  But after fiddling about with RegExp, and then checking Vim's built-in
documentation, I found the `spelloptions` setting;

```vim
set spelloptions+=camel
```

...  With that one word added may spellcheck now triggers on "badSplling",
and specifically only the `Splling` portion, but not at all for strings like
"goodSpelling".  Best of all I didn't need to modify my plugin and, for now,
the above RegExp stuff is not necessary!

That all stated, I hope it helps a few of you readers out there ;-D


______


## Documentation
[heading__documentation]: #documentation


- `help whitespace`
- `help matchstrlist()`
- `help spelloptions`

