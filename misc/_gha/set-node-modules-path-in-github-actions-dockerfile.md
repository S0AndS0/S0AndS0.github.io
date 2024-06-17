---
title: Set Node Modules path in Github Actions Dockerfile
description: TLDR `ENV NODE_PATH=/usr/local/lib/node_modules`
layout: post
date: 2019-10-04 23:15:40 +0000
time_to_live: 1800
author: S0AndS0
tags: [ github, javascript ]
image: assets/images/gha/set-node-modules-path-in-github-actions-dockerfile/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1180260223832846336
      title: Link to Tweet thread for this post
---



Quick [@GitHub](https://twitter.com/github) Actions tip, if `npm install -g
sass` and `const sass = require('sass');` is failing it's likely because
`NODE_PATH` is not defined as an environment variable.

Adding...

```dockerfile
ENV NODE_PATH=/usr/local/lib/node_modules
```

... to the Docker file may resolve such issues.
