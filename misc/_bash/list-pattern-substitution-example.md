---
title: List pattern substitution example
description: TLDR use `/<pattern>/<substitution>` or `//<pattern>/<substitution>` to find/replace first or all occurrences in a list
layout: post
date: 2019-08-14 22:01:32 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, linux ]
image: assets/images/bash/list-pattern-substitution-example/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1161759789044518913
      title: Link to Tweet thread for this post
---


Quick Bash scripting tip; substitution built-ins are generally faster than
pipes...

```bash
_list=( lamb spam food )

printf '%s ' "${_list[@]/[^am]/*}" && echo
#> *amb *amb *ood

printf '%s ' "${_list[@]//[am]/*}" && echo
#> l**b l**b food
```

... especially on certain non-Linux implementations.
