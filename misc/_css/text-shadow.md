---
vim: textwidth=79
title: Text Shadow
description: 'TLDR `text-shadow: 0.05em 0.05em black, -0.05em -0.05em black`'
layout: post
date: 2024-07-18 16:00:50 +0000
time_to_live: 1800
author: S0AndS0
tags: [ CSS, UI, UX, WebDesign, WebDev ]
image: assets/images/css/text-shadow/first-code-block.png
social_comment:
  links:
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_css-ui-ux-activity-7219837946911170560-EnHb
      title: Link to LinkedIn thread for this post

    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/112809968095504900
      title: Link to Toot thread for this post

    - text: Twitter
      href: https://x.com/S0_And_S0/status/1814072280948871437
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: MDN -- CSS `text-shadow`
      href: https://developer.mozilla.org/en-US/docs/Web/CSS/text-shadow
      title: CSS `text-shadow` documentation provided by Mozilla Developer Network
---


Web-UI/UX tip; using `text-shadow` CSS property can help improve readability of
text that overlays images or video, for example if text is white/light then set
a dark shadow;

```css
.overlay-text {
  text-shadow: 0.05em 0.05em black, -0.05em -0.05em black;
}
```


______


## Live examples
[heading__live_examples]: #live-examples


### Bad example 1
[heading__bad_example_1]: #bad-example-1

```html
<style>
.container-bad-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
}
</style>

<div class="container-bad-example-1">
  <h3>Bad example heading</h3>
  <span>Bad example text</span>
</div>
```

{% raw %}
<style>
.container-bad-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
}
</style>

<div class="container-bad-example-1">
  <h3>Bad example heading</h3>
  <span>Bad example text</span>
</div>
{% endraw %}

Though above may seem a bit extreme to illustrate how illegible text can be
when contrast is not considered, there are plenty of sites with image
background which in part do dip into this level of un-readability.

### Improved example 1
[heading__improved_example_1]: #improved-example-1

```html
<style>
.container-improved-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
  text-shadow: 0.05em 0.05em black, -0.05em -0.05em black;
}
</style>

<div class="container-improved-example-1">
  <h3>Improved example heading</h3>
  <span>Improved example text</span>
</div>
```

{% raw %}
<style>
.container-improved-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
  text-shadow: 0.05em 0.05em black, -0.05em -0.05em black;
}
</style>

<div class="container-improved-example-1">
  <h3>Improved example heading</h3>
  <span>Improved example text</span>
</div>
{% endraw %}

The above is significantly improved for the heading (`h3`) element, however,
the `span` text though visible is still a source of suffering.  And adding a
blur-radius value can help address this issue!

### Better example 1
[heading__better_example_1]: #better-example-1

The syntax for adding `blur-radius` is either;

>     offset-x | offset-y | blur-radius | color
>     color    | offset-x | offset-y    | blur-radius

... As we've already defined the color last, we'll use the first option.

```html
<style>
.container-better-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
  text-shadow: 0.05em 0.05em 0.5em black, -0.05em -0.05em 0.5em black;
}
</style>

<div class="container-better-example-1">
  <h3>Better example heading</h3>
  <span>Better example text</span>
</div>
```

{% raw %}
<style>
.container-better-example-1 {
  padding: 3em;
  background-color: azure;
  color: white;
  text-shadow: 0.05em 0.05em 0.95em black, -0.05em -0.05em 0.95em black;
}
</style>

<div class="container-better-example-1">
  <h3>Better example heading</h3>
  <span>Better example text</span>
</div>
{% endraw %}

Not quite perfect, but getting there!...  What counts as perfect is a judgment
call made case-by-case, and also a mater of taste, but with one line of CSS it
be possible to achieve _good enough_ status and ship it.

