---
title: Combining `capture` with `strip` example
description: TLDR `{% capture workspace %} <!-- some content --> {% endcapture %} {% workspace | strip %}`
layout: post
date: 2019-08-16 01:10:46 +0000
time_to_live: 1800
author: S0AndS0
tags: [ liquid ]
image: assets/images/liquid/combining-capture-with-strip-example/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1162169798056243200
      title: Link to Tweet thread for this post
---



Quick #Liquid tip; combining `capture` with `strip`...

{% raw %}
```liquid
{% capture workspace %}
  <!-- some content -->
{% endcapture %}
{% workspace | strip %}
```
{% endraw %}

... will remove newlines and extra spaces prior to output. Resulting in a
little less _fluff_ being sent over the wire.
