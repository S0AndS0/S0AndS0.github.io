---
title: Mount remote file-system over SSH
description: TLDR use `sshfs` and `fusermount` commands
layout: post
date: 2019-08-24 04:57:00 +0000
time_to_live: 1800
author: S0AndS0
tags: [ linux ]
image: assets/images/linux/mount-remote-file-system-over-ssh/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1165125832286724096
      title: Link to Tweet thread for this post
---



Quick Linux tip; `sshfs` enables remote file-system mounting...

```bash
sudo mkdir /media/pi
sudo chown ${USER}:${GROUPS} /media/pi

sshfs raspberrypi:/home/pi /media/pi
ls -ahl /media/pi

fusermount -u /media/pi
```

... and usually no server side setup, just ssh authorization.

