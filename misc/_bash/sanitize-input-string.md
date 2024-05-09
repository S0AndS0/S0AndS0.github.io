---
title: Sanitize input string
description: TLDR `printf '%q\n' 'some th!ng n@$ty'`
layout: post
date: 2019-08-12 00:06:38 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, linux ]
image: assets/images/bash/sanitize-input-string/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1160704106861715458
      title: Link to Tweet thread for this post
---



Quick Bash scripting tip; the Linux `printf` command can auto-escape strings...

```bash
_unclean_input='some th!ng n@$ty'
printf '%q\n' "${_unclean_input}"
#> some\ th\!ng\ n@\$ty
```

... this is generally easier to grok than other things that I'd like to unsee.
