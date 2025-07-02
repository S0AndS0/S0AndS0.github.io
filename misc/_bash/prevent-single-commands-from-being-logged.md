---
title: Prevent single commands from being logged to Bash History
description: TLDR `<COMMAND>; history -d $((HISTCMD-1))`
layout: post
date: 2019-11-02 04:37:30 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, sed ]
image: assets/images/bash/prevent-single-commands-from-being-logged/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1190488076960690177
      title: Link to Tweet thread for this post
---


Bash interactive shell tip when using server API tokens; prevent single
commands from being logged to `.bash_history` via...

```bash
GITHUB_TOKEN=123456 node index.js; history -d $((HISTCMD-1))
```

Or clean-up after with...

```bash
sed -e '/TOKEN/d' -i .bash_history; history -d $((HISTCMD-1))
```

