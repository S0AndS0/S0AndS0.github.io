---
vim: spell nowrap textwidth=79

title: Git Worktree Sanity
description: How I manage multiple long-lived feature branches
categories: [ git, linux ]
author: S0AndS0
layout: post

scripts:
  - src: assets/javascript/asciinema-player/asciinema-player.min.js

stylesheets:
  - href: assets/css/asciinema-player/asciinema-player.css

time_to_live: 1800
# date_updated: 
date: 2025-10-09 13:31:00 -0700

image: assets/images/git/worktree-sanity/first-code-block.png
social_comment:
  links:
    - text: Blue Sky
      href: https://bsky.app/profile/did:plc:rxh54z4q44ahcswnale26pn2/post/3m2s4vgr4ns2p
      title: Link to Post thread for this post
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_git-worktree-sanity-activity-7382169189467377665-Efn7/
      title: Link to comment thread for this post
    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/115346394348595917
      title: Link to Toot thread for this post
    - text: Odysee
      href: https://odysee.com/@S0AndS0:0/tech-tips_Git-Worktree-Sanity:8
      title: Link to video in which I talk you through it
    - text: Twitter
      href: https://x.com/S0_And_S0/status/1976403523341516884
      title: Link to Tweet thread for this post

# attribution:
#   links:
#     - text: 
#       href: 
#       title: 
---


## TLDW

```bash
## Create a new branch
git worktree add --track -b <new-branch> <path> <remote>/<ref>

## Checkout existing branch
git worktree add <path> <remote>/<branch>
```

<div id="demo"></div>
<script> AsciinemaPlayer.create('{{- "/assets/asciinema/git/worktree-sanity/long-lived-feature-branches.cast" | relative_url -}}', document.getElementById('demo')); </script>

______


## Setup


Choose one of the following options, generally only needs done once per
repository.  Though is good to know about adding remotes when one gets around
to managing forks.

### Clone as bare repository

```bash
git clone --bare git@github.com:nix-community/nix-on-droid.git

cd nix-on-droid.git

git fetch origin
```

### Initialize as bare repository and add remote

```bash
git init --bare nix-on-droid

cd nix-on-droid

git remote add origin git@github.com:nix-community/nix-on-droid.git

git fetch origin
```


______


## Examples


### Create a new branch

```bash
git worktree add --track -b add-termux-services wt/add-termux-services origin/master
```

> Above creates a new branch named `add-termux-services` based on
> `origin/master` and populates directory/file structure under
> `wt/add-termux-services` path with files.

---

### Checkout existing branch

```bash
git worktree add wt/add-radio-active fork/add-radio-active
```

> Above will attempt to checkout existing branch named `add-radio-active` from
> `fork` and populates directory/file structure under `wt/add-radio-active`
> path.

