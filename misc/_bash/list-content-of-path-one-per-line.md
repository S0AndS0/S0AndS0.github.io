<!-- --- -->
title: List content of path one per line
description: TLDR `ls -1` ensures output is one directory or file per line
layout: post
date: 2019-08-24 01:28:33 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash ]
image: assets/images/bash/list-content-of-path-one-per-line/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1165073376014004224
      title: Link to Tweet thread for this post
---



Quick Bash scripting tip; the `-1` ('one' not 'L') option with `ls` makes
output more predictable...

```bash
while read -r -d '' _name; do
  printf '%s\n' "${_name}"
done < <(ls -1 "${HOME}/logs" | awk -v _p="logged" '$0 ~ _p {print $0}')
```

... and combined with `awk` parsing is peppy.

