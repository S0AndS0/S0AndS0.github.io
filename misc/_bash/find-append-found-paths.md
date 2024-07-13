---
title: Find append found paths
description: TLDR `find <DIRECTORY> -type f -exec <COMMAND> {} '+'`
layout: post
date: 2024-07-13 11:17:53 +0700
time_to_live: 1800
author: S0AndS0
tags: [ bash, find, linux ]
image: assets/images/bash/find-append-found-paths/first-code-block.png

# social_comment:
#   links:
#     - text: Twitter
#       href: https://x.com/i/web/status/<ID>
#       title: Link to Tweet thread for this post

# attribution:
#   links:
#     - text: 
#       href: 
#       title: 
---


On systems with limited resources and/or slower execution/interpretation speed
it can be desirable to reduce the number of pipes and process forking, for
example Android/Linux dual-boot, Raspberry Pi, Cygwin, and the Linux Subsystem
for Windows historically have had less-than stellar performance.

In this quick tech tip an alternative `find` invocation will be explored which
for _some_ use-cases will remove the need for piping results to `xargs`, or
similar executables, and instead invoke an executable with a list of found
results.


______


## Examples
[heading__examples]: #examples


```bash
## Check yourself
find ./posts -type f -exec printf 'Found: %s\n' "{}" '+'

## Before you wreck yourself by substituting a value in-place everywhere
find ./posts -type f -exec sed -i 's/publish: false/publish: true' "{}" '+'
```


______


## Manual entry
[heading__manual_entry]: #manual-entry


```bash
man -P 'less -p "^\s+-exec command {} \+"' find
```

> This variant of the -exec action runs the specified command on the selected
> files, but the command line is built by appending each selected file name at
> the end; the total number of invocations of the command will be much less
> than the number of matched files.  The command line is built in much the same
> way that `xargs` builds its command lines.  Only one instance of `{}` is
> allowed within the command, and it must appear at the end, immediately before
> the `+`; it needs to be escaped (with a `\`) or quoted to protect it from
> interpretation by the shell.  The command is executed in the starting
> directory.  If any invocation with the `+` form returns a non-zero value as
> exit status, then find returns a non-zero exit status.  If find encounters an
> error, this can sometimes cause an immediate exit, so some pending commands
> may not be run at all.  For this reason
> `-exec my-command ...  {} + -quit`
> may not result in my-command actually being run.  This variant of `-exec`
> always returns true.


______


## Explanations and considerations
[heading__explanations_and_considerations]: #explanations-and-considerations


_Under the hood_ what `find` is doing when the `-exec <COMMAND> {} '+'` variant
is detected is;

- buildup a list/array of found paths, roughly the max number of arguments
- then pass that list to the `<COMMAND>` as a list of argument, all at once

> Tip; check `getconf ARG_MAX` on your system for the max number of arguments

Without `-exec <COMMAND> {} '+'`, I.E. the variant of `-exec <COMMAND>`,
execution happens once per-path!  For an apples-to-apples example, my RPi4 has
a `ARG_MAX` of 2,097,152 so were I to have that many paths found in the
`./posts` directory the `-exec <COMMAND>` variant would run `sed` over two
million times, where as `-exec <COMMAND> {} '+'` would execute `sed` about
twice.

**Warning** this method ain't going to be the blazingly-fastest on multi-core
and bare-metal systems!  For such environments piping to either `parallel`, or
`xargs -P0`, will remain the swiftest choice for handling `find` results...
Though that may be a topic best explored in another post ;-D

