---
title: Redirect local standard-in to remote over SSH
description: TLDR utilize here-doc or here-string
layout: post
date: 2019-08-25 04:01:32 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, ssh ]
image: assets/images/bash/redirect-local-standard-in-to-remote-over-ssh/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1165474261827371010
      title: Link to Tweet thread for this post
---



Quick SSH Bash redirection example...

```bash
push_key(){
  _host="${1:?}"
  _key="${2:?}"
  ssh "${_host}" <<EOF
mkdir ~/.ssh
tee -a ~/.ssh/authorized_keys 1>/dev/null <<<"$(<"${_key}")"
chmod 644 ~/.ssh/authorized_keys
EOF
}

push_key raspberrypi ~/.ssh/pi.pub
#> Adds key to server
```
