---
title: Searching `man` via pager
description: TLDR `man --pager='less --pattern=" -P pager"' man`
layout: post
date: 2019-08-11 22:34:50 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, linux, man ]
image: assets/images/bash/searching-man-via-pager/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1160681002328420352
      title: Link to Tweet thread for this post
---



Quick Bash shell tip on searching the Linux manual...

```bash
man --pager='less --pattern=" -P pager"' man
```

... Example for `sshd_config`...

```bash
man --pager='less -p "ChrootDirectory"' sshd_config
```

... love your `man` pages because one day ya might be developing on an
air-gaped device.

