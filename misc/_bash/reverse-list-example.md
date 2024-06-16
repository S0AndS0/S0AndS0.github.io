---
title: Reverse list example
description: TLDR use a `for` loop over indices 
layout: post
date: 2019-08-18 08:09:37 +0000
time_to_live: 1800
author: S0AndS0
tags: [ awk, bash ]
image: assets/images/bash/reverse-list-example/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1162999980799320065
      title: Link to Tweet thread for this post
---



Quick Bash tip on reversing arrays...

```bash
_old_array=(spam ham space)
_new_array=()

_indices=(${!_old_array[@]})
for ((i=${#_indices[@]}-1; i>=0; i--)); do
  _new_array+=("${_old_array[${_indices[$i]}]}")
done

printf '%s\n' "${_new_array[@]}"
#> space
#> ham
#> spam
```

