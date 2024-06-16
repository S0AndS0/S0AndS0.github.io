---
title: Floating point math
description: TLDR `awk "BEGIN {print 10 * 4.2}"`
layout: post
date: 2019-08-11 23:26:30 +0000
time_to_live: 1800
author: S0AndS0
tags: [ awk, bash, linux ]
image: assets/images/awk/floating-point-math/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1160694008542191616
      title: Link to Tweet thread for this post
---



Quick Bash scripting tip, the `awk` command-line utility understands floats on
Linux...

```bash
awk "BEGIN {print 10 * 4.2}"
#> 42
```

... Example usage;

```bash
awk -v x=4 -v y=2.5 "BEGIN {print x + y}"
#> 6.5
```

Useful when developing on devices limited to a BusyBox environment and/or no
package manager.
