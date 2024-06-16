---
title: Define custom functions instead of using `eval`
description: TLDR use `now(){ date +'%Y-%m-%d %H:%M:%S'; }`
layout: post
date: 2019-08-16 00:09:07 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash ]
image: assets/images/bash/define-custom-functions-instead-of-using-eval/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1162154283258662913
      title: Link to Tweet thread for this post
---



Quick Bash tip; using custom functions instead of `eval`...

```bash
now(){ date +'%Y-%m-%d %H:%M:%S'; }
_moment="$(now)"

printf '%s\n' "${_moment// /_}"
#> 2019-08-15_17:02:54
printf '%s\n' "$(now)"
#> 2019-08-15 17:03:28
```

... to differ execution is more explicit and predictable.
