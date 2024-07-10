---
vim: textwidth=79 nowrap
title: Resume Builder
description: 
layout: post
date: 2024-06-14 15:53:28 -0700
time_to_live: 1800
author: S0AndS0
tags: [ cicd, docker, github, resume  ]
image: assets/images/projects/resume-builder/first-code-block.png

social_comment:
  links:
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_s0ands0s-r%C3%A9sum%C3%A9-activity-7207531525037293568-K2Yj
      title: Link to LinkedIn thread for this post

    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/112617680499241676
      title: Link to Toot thread for this post

    - text: Twitter
      href: https://x.com/S0_And_S0/status/1801765908139901429
      title: Link to Tweet thread for this post

# attribution:
#   links:
#     - text: 
#       href: 
#       title: 
---


Today I've published, and partially open sourced, a project I've been privately
building off-and-on over a few years for generating customized Résumés!

- Site → https://s0ands0.github.io/resume-builder/
- PDF → https://s0ands0.github.io/resume-builder/resume.pdf
- Source → https://github.com/S0AndS0/resume-builder

... feedback as always be welcomed!


## Quick start
[heading__quick_start]: #quick-start


- Download and start local web-server

```bash
## Clone and change current working directory
git clone https://github.com/S0AndS0/resume-builder
cd "${_##*/}"

## Install development dependencies
npm install

## Start local development web-server
npm run serve
```

- Check if one has applied to a company

```bash
npm run --silent has-applied-to -- Company Name
```

- Generate a PDF after customizing files in `assets/json/` directory

```bash
npm run --silent chromium-print-to-pdf -- \
  --preview \
  --alias 'example.com' \
  --company 'Company Name' \
  --job 'Open Position' \
```

