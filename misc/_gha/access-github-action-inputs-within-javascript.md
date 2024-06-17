---
title: Access GitHub Action inputs within JavaScript
description: TLDR `process.env.INPUT_<NAME>`
layout: post
date: 2019-08-23 00:27:52 +0000
time_to_live: 1800
author: S0AndS0
tags: [ github, javascript ]
image: assets/images/gha/access-github-action-inputs-within-javascript/first-code-block.png
social_comment:
  links:
    - text: Twitter OP
      href: https://x.com/i/web/status/1164695715085352961
      title: Link to Tweet thread for this post
    - text: Twitter Corrections
      href: https://x.com/i/web/status/1164695715085352961
      title: Link to Tweet thread for this post
---



Quick note for GitHub Actions...

```yaml
inputs:
  test_string:
    description: 'String Tests'
    default: 'Spam'
    required: false
```

... `inputs` are JavaScript accessible via...

```javascript
console.log(`test_string -> ${process.env.INPUT_TEST_STRING}`);
//> test_string -> Spam
```

...Bonus note, if `default:` is assigned then `required: true` is **ignored**
when a workflow doesn't assign a `with:` value.

