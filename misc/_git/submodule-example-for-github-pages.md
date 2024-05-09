---
title: Submodule example for GitHub Pages
description: How to _borrow_ code from other repositories without a dedicated package manager
layout: post
date: 2019-08-12 07:03:06 +0000
author: S0AndS0
tags: [ git, GitHub, Jekyll ]
image: assets/images/git/submodule-example-for-github-pages/first-code-block.png

social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1160808914138435584
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: GitHub -- `liquid-utilities/collection-home`
      href: https://github.com/liquid-utilities/collection-home
      title: Link source code for Collection Home submodule from Liquid Utilities GitHub Organization
---

Git submodules are supported on GitHub pages when building with Jekyll...

```bash
mkdir -vp _layouts/modules

git submodule add \
  -b master --name collection-home \
  https://github.com/liquid-utilities/collection-home \
  _layouts/modules/collection-home
```

... no loss of version control and allows for code reuse.
