---
title: Example `console.table` usage
description: "TLDR `console.table({one: 'spam', two: 'Spam'})`"
layout: post
date: 2019-08-12 16:58:59 +0000
time_to_live: 1800
author: S0AndS0
tags: [ javascript ]
image: assets/images/javascript/console-table-example/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1160958871910752258
      title: Link to Tweet thread for this post
---



Quick JavaScript tip; `console` has more than a `.log()` method...

```javascript
console.table({one: 'spam', two: 'Spam'});

//> (index) │  Values
//>   one   │ 'spam'
//>   two   │ 'Spam'
```

... Aside from custom _wrappers_; what's your favorite alternatives to the
usual `console.log()`?
