---
title: Pass multiple lists to function by reference
description: TLDR `local -n list_name`
layout: post
date: 2019-08-18 23:24:35 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, linux ]
image: assets/images/bash/pass-multiple-lists-to-function-by-reference/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1163230237380898816
      title: Link to Tweet thread for this post
---



Quick Linux Bash scripting tip; how to pass multiple arrays by reference with
`local -n`...

```bash
nth(){
  _i="$1"
  local -n _ref1="$2"
  local -n _ref2="$3"
  printf '%s | %s\n' "${_ref1[$_i]}" "${_ref2[$_i]}"
}

_a0=(spam space ham)
_a1=(1 2 3)

nth '0' '_a0' '_a1'
#> spam | 1
```

