---
title: Running shell commands with variable assigned parameters
description: Awk can take control of pipes instead of piping from a shell process to Awk
layout: post
date: 2019-11-01 01:44:13 +0000
time_to_live: 1800
author: S0AndS0
tags: [ awk, bash ]
image: assets/images/awk/running-shell-commands-with-variable-assigned-parameters/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1190082083357515777
      title: Link to Tweet thread for this post
---

Quick Awk example for running shell commands with variable assigned
parameters...

```bash
awk -v _dir="~/tmp" -v _name="*.log" 'BEGIN {
  cmd = "find " _dir " -name " _name " 2>/dev/null";
  while ((cmd | getline _line) > 0) {
    print "Found ->", _line;
  }
  close(cmd);
}'
```

> Relevant manual page sections;
>
> - `man --pager='less --pattern="^\s+getline"' gawk`
> - `man --pager='less --pattern="^\s+close\("' gawk`

The above code is nearly equivalent to piping from Bash into Awk;

```bash
find ~/tmp -name "*.log" 2>/dev/null |
  awk '{ print "Found ->", $0; }'
```

...  which for this contrived example, it'd probably be better to go with the
Awk/Bash combo.  However, in such cases where the `awk` side of execution is
more considerably intense, such as running some operations on a set of paths,
it can be beneficial for future maintenance to keep more logic under Awk's
control.

