---
title: Show and copy file between branches
description: TLDR `git show <REMOTE>/<BRANCH>:<FILE>`
layout: post
date: 2019-08-17 21:11:51 +0000
time_to_live: 1800
author: S0AndS0
tags: [ git ]
image: assets/images/git/show-and-copy-files-between-brances/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1162834449207136256
      title: Link to Tweet thread for this post
---



Quick Git tip; the `git show` command may _show_ files from a specific branch
or revision...

```bash
git show origin/gh-pages:index.html
```

... And with redirection may be used to copy individual files between
branches...

```bash
tee "./index.html" <<<"$(git show gh-pages:index.html)"
```

