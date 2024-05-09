---
title: Paranoid Linux Adaptive IPTables Announcement
description: Announcement of new project which links `iptables` modification to SystemD service state
layout: post
date: 2019-08-13 05:48:27 +0000
time_to_live: 1800
author: S0AndS0
tags: [ linux, bash, forkfriendly, github ]
image: assets/images/projects/paranoid-linux-adaptive-iptables-announcement/first-code-block.png

social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1161152517129904128
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: GitHub -- `paranoid-linux/adaptive-iptables`
      href: https://github.com/paranoid-linux/adaptive-iptables
      title: Link to source code for Adaptive IPTables project from the Paranoid Linux GitHub Organization
---



Linux firewall automation triggered by service and/or interface changes....

[GitHub -- Paranoid Linux -- Adaptive IPTables](https://github.com/paranoid-linux/adaptive-iptables)

... Still a work-in-progress (no IPv6 support, yet), but the current design
should provide enough Bash examples to extend further.

> Hint, _fork friendly_ on GitHub

For the brave readers, here be how to quickly install via Git;

```bash
sudo su -
cd /usr/local/etc

git clone --recurse-submodules git@github.com:paranoid-linux/adaptive-iptables.git
```

