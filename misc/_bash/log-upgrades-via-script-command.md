---
title: Log upgrades via `script` command
description: TLDR `script -ac "sudo apt-get upgrade" "$(date +'%Y-%m-%d')_sudo_apt-get_upgrade.script"`
layout: post
date: 2019-08-12 06:00:56 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, linux ]
image: assets/images/bash/log-upgrades-via-script-command/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1160793269166473216
      title: Link to Tweet thread for this post
---



Quick Bash tip for Linux administrators; the `script` and `date` commands...

```bash
_today="$(date +'%Y-%m-%d')"
_command='apt-get upgrade'

script -ac "${_command}" "${_today}_${_command// /_}.script"
```

... can be a blessing to a future self when questions are asked of server
changes.
