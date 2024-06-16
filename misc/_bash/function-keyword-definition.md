---
title: Function keyword definition
description: TLDR `man --pager='less -p "Shell Function Definitions"' bash`
layout: post
date: 2019-08-16 19:11:53 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash ]
image: assets/images/bash/function-keyword-definition/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1162441868803624960
      title: Link to Tweet thread for this post
---



Quick documentation excerpt for #bash; according to...

```bash
man --pager='less -p "Shell Function Definitions"' bash
```

... "If the function reserved word is supplied, the parentheses are optional."
eg...

```bash
function spam { <command>; }
# verses...
ham(){ <command>; }
```

... declarations.
