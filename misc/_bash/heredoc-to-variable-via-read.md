---
title: Heredoc to variable via `read`
description: TLDR `read -r -d '' _var <<EOF`
layout: post
date: 2019-08-13 06:15:53 +0000
time_to_live: 1800
author: S0AndS0
tags: [ linux, bash ]
image: assets/images/bash/heredoc-to-variable-via-read/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1161159417934438405
      title: Link to Tweet thread for this post
---



Quick Linux Bash scripting tip; `read` can save multi-line variables...

```bash
read -r -d '' _var <<EOF
${HOME} is where your directories are
There's no connections like those happening on
$(ip addr show lo)
EOF
```

... though beware some error traps may be tripped by this trick.
