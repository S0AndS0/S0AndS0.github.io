---
vim: nowrap textwidth=79
title: Date Time conversions
description: Quick tips/tricks for converting date/time stamps between timezones
author: S0AndS0
date: 2025-04-26 09:48:00 -0700
categories: linux
layout: post
time_to_live: 1800
tags: [ linux, bash ]
image: assets/images/linux/date-time-conversions/first-code-block.png

# social_comment:
#   links:
#     - text: BlueSky
#       href: 
#       title: Link to BS thread for this post
# 
#     - text: LinkedIn
#       href: 
#       title: Link to LinkedIn thread for this post
# 
#     - text: Mastodon
#       href: 
#       title: Link to Toot thread for this post
# 
#     - text: Twitter
#       href: 
#       title: Link to Tweet thread for this post

attribution:
  links:
    - text: 'Bash: get date and time from another time zone'
      href: https://stackoverflow.com/questions/26802201/bash-get-date-and-time-from-another-time-zone
      title: 'Stack Overflow -- Bash: get date and time from another time zone'
---


## TLDR


```bash
## Convert foreign timezone to local date/time syntax
# date --date='<DATE> <TIME> UTC<SIGN><OFFSET>' +<FORMAT>
## ...  Example
date --date="2025-03-26 08:30 UTC+0800" +"%F %H:%M UTC%z"

## Convert local date/time to foreign timezone syntax
# TZ='UTC<SIGN><OFFSET>' date +<FORMAT>
## ...  Example
TZ="UTC+0800" date +"%F %H:%M UTC+0800"
```

______


## Story time


Over the last _few_ years, perhaps couple of decades, I've had the pleasure to
service clients, and coordinate with teams, operating in nearly every timezone
available.  And through these experiences we've had plenty of _opportunities_
for off-by-one errors when setting meeting times.

So out of necessity, and curiosity...  and maybe a touch of
anal-retentiveness... I've collected a few tricks to mitigate making mistakes
on my end.  One of which is to almost always use sane date/time ordering, where
precision is ordered in the same direction as the intended reader reads, left
to right in most cases;

> - Syntax: `<YEAR>-<MONTH>-<DAY> <HOUR>:<MINUTE> <TIMEZONE>`
> - Date format string: `+'%F %T %z'`
> - Example: `2025-03-26 08:30 UTC+0800` ... Note; I drop the seconds, as I
>   don't service control freaks ;-)

...  I use this order first because, and yes I'm calling out the 'mericans
here, who really tells time in `<HOUR>:<SECONDS>:<MINUTEs>`?...  Seriously who
should be blamed for the `<MONTH> <DAY>, <YEAR>` ordering they use?  And second
because it makes file sorting easier, and faster to search, when date/time-s
are ordered with progressive precision.  And third, and probably most
important, I don't like joining a meeting only to find I'm an hour late!

Some may say Calendly® _solves_ most of this, but I value off-line solutions
and prefer options that don't data-mine; plus Calendly® in particular fails
to load over Tor.  And all other options I've tried so far seem to ignore the
fact that [CalDAV](https://en.wikipedia.org/wiki/CalDAV) spec, and friends,
often do **not** require anything more than a list of email addresses to send
event details to!...  Simply put; I don't assume my clients are okay with me
opting them into ToS of some company who's sharing data among 41968 _close_
partners 🤮


______


## Bonus -- Create discord time-stamp


For those of ya that got to the end, here be your reward!  A simple Bash script
to create time-stamps, formatted to something that Discord will automatically
format for all clients' timezone/formatting preferences ;-)

```bash
#!/usr/bin/env bash
## Author: S0AndS0
## License: AGPL-3
## Usage:
##   <SCRIPT>
##   <SCRIPT> <DATE>
## Example: discord-time next Tuesday 2pm

date --date="${*:-$(date)}" +'<t:%s>'
```

