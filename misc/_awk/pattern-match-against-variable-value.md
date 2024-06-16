---
title: Pattern match against variable value
description: TLDR `$0 ~ _variable_name { print }`
layout: post
date: 2019-08-16 19:48:00 +0000
time_to_live: 1800
author: S0AndS0
tags: [ awk, bash ]
image: assets/images/awk/pattern-match-against-variable-value/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1162450960049774592
      title: Link to Tweet thread for this post
---



Quick Bash examples with `awk`...

```bash
_s="Spam"
awk -v _s="${_s}" '$0 ~ _s { print $1 }' <<'EOF'
lamb
ham Spam
EOF
#> ham

awk '$2 == "jam" { print $0 }' <<'EOF'
jam Spam
Spam jam
EOF
#> Spam jam
```

... the `~` vs. `==` and `$<n>` syntax, are powerful for searching file-like
inputs.
