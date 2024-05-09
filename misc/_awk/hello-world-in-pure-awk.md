---
title: Hello World in pure Awk
description: TLDR use shebang with `-f` to make file an Awk script, eg. `#!/usr/bin/awk -f`
layout: post
date: 2019-08-13 17:05:46 +0000
time_to_live: 1800
author: S0AndS0
tags: [ awk, bash, linux ]
image: assets/images/awk/hello-world-in-pure-awk/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1161322965947973632
      title: Link to Tweet thread for this post
---



Quick Linux scripting tip; `awk` command-line utility is a full featured
language...

```awk
#!/usr/bin/awk -f
BEGIN {
  _first_arg=ARGV[1]
  print "Hello " _first_arg
}
```
... Example input/output;

```bash
chmod u+x awk-hello-world

./awk-hello-world Bill
#> Hello Bill
```

Tip, using `awk` instead of Bash pipes generally speeds up file parsing.
