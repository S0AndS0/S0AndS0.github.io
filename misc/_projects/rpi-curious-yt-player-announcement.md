---
title: RaspberryPi Curious YouTube Player Announcement
description: Announcement of new project which enables easy playback of YouTube videos via CLI
layout: post
date: 2019-08-14 07:14:19 +0000
time_to_live: 1800
author: S0AndS0
tags: [ bash, RaspberryPi ]
social_comment:
  links:
    - text: Twitter
      href: https://x.com/i/web/status/1161536513060065281
      title: Link to Tweet thread for this post

---


Simple Bash wrapper script of `youtube-dl` and `omxplayer` for playback of
YouTube links on RaspberryPi.

Features include setting audio output and volume, as well as accepting a space
separated list of links to stream.

[GitHub -- RaspberryPi Curious -- YouTube Player](https://github.com/rpi-curious/yt-player)


## Quick install instructions


```Bash
mkdir -vp "${HOME}/git/hub/rpi-curious"

cd "${HOME}/git/hub/rpi-curious"

git clone --recurse-submodules git@github.com:rpi-curious/yt-player.git

mkdir "${HOME}/bin"

ln -s "${HOME}/git/hub/rpi-curious/yt-player/yt-player.sh" "${HOME}/bin/"
```

