---
name: Template literals now supported in Node JS
layout: post
date: 2019-08-12 17:21:34 +0000
time_to_live: 1800
author: S0AndS0
tags: [ javascript, node, linux ]
image: assets/images/javascript/template-literals-now-supported-in-node-js/first-code-block.png
social_comment:
  links:
    - text: Twitter
      href: https://twitter.com/i/web/status/1160964554425131008
      title: Link to Tweet thread for this post
---



Quick JavaScript tip; template literals/strings support is growing...

```javascript
var d = {one: 'Spam', two: 'Ham'};
var a = [1, 2.2, 'IV'];

console.log(`${a[2]} more ${d.two.toLowerCase()} please`);
//> IV more ham please
```

... Compatibility includes Node JS on Linux, not just web-browsers!
