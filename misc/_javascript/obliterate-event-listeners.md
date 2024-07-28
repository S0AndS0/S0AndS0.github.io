---
vim: textwidth=79 nowrap
title: Obliterate event listeners
description: Remove all event listeners from a HTML element in Chromium or Firefox based web-browsers
layout: post
date: 2024-07-28 07:50:30 -0700
time_to_live: 1800
author: S0AndS0
tags: [ javascript, typescript ]
image: assets/images/javascript/obliterate-event-listeners/first-code-block.png

# social_comment:
#   links:
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
    - text: MDN -- Navigator Clipboard API
      href: https://developer.mozilla.org/en-US/docs/Web/API/Clipboard
      title: Navigator Clipboard API

    - text: 'MDN -- CSS `display` property'
      href: https://developer.mozilla.org/en-US/docs/Web/CSS/display
      title: 'Mozilla Developer Network -- CSS `display` property'

    - text: 'MDN -- CSS `outline` property'
      href: https://developer.mozilla.org/en-US/docs/Web/CSS/outline
      title: 'Mozilla Developer Network -- CSS `outline` property'

    - text: 'MDN -- HTML `form` element'
      href: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form
      title: 'Mozilla Developer Network -- HTML `form` element'

    - text: 'MDN -- HTML `input` element'
      href: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
      title: 'Mozilla Developer Network -- HTML `input` element'

    - text: 'MDN -- JavaScript sending `form` data'
      href: https://developer.mozilla.org/en-US/docs/Learn/Forms/Sending_forms_through_JavaScript
      title: 'Mozilla Developer Network -- JavaScript sending `form` data'

    - text: 'MDN -- JavaScript `setCustomValidity`'
      href: https://developer.mozilla.org/en-US/docs/Web/API/HTMLObjectElement/setCustomValidity
      title: 'Mozilla Developer Network -- JavaScript `setCustomValidity`'
---



Recently happened across, another, site that thought disabling paste was a good
idea for password-like inputs.  Super annoying!  So here's a JavaScript snippet
I wrote that removes all listeners for an element with a given ID;

```javascript
function obliterateEventListeners(id) {
  if (!id?.length) {
    throw new Error('No element ID provided');
  }

  const element = document.getElementById(id);
  if (!element) {
    throw new Error(`No element with ID -> ${id}`);
  }

  const clone = element.cloneNode(true);
  element.parentNode.replaceChild(clone, element);
}
```

...  I'm open to having my opinions changed by web-devs that actively disable
paste, and have good reasons for it.  Because at time of writing I believe such
practices do **not** improve security, not for the client and certainly not for
any server; and worse, these sorts of anti-features encourage less secure
pass-phrases to be picked by clients.


______


## Recommendations
[heading__recommendations]: #recommendations


Instead I'd recommend utilizing the front-end as it was intended by _hinting_
to clients what data should be submitted, then have the back-end do what it
must to validate a given action.  For example here's a _basic_ `form` HTML
element populated with `label` and `input` elements for creating a new account;

{% capture obliterate_event_listeners__example_html %}
<form name="create-new-account" action="/account/create/" method="post">
  <label for="user-name">Name:</label>
  <input id="user-name" type="text" minlength="1" required />

  <label for="user-email">Email:</label>
  <input id="user-email" type="email" required />

  <label for="password-new">New password:</label>
  <input id="password-new" type="password" minlength="8" required />

  <label for="password-confirm">Confirm password:</label>
  <input id="password-confirm" type="password" minlength="8" required />

  <input type="submit" value="Create accout" />
</form>
{% endcapture %}

```html
{{- obliterate_event_listeners__example_html -}}
```

... The above _should_ work even when a client has disabled JavaScript!  But
form input validation and error handling then must be handled by server-side
code, and the `/account/create/` route must display success/failure states
correctly.

This does not mean one cannot use the front-end, and it should be used, though
again for _hinting_ to a client what is valid.  Here's some CSS to get readers
started with UI/UX;

{% capture obliterate_event_listeners__example_css %}
<style>
form[name="create-new-account"] > label,
form[name="create-new-account"] > input {
  display: block;
}

form[name="create-new-account"] > label:valid,
form[name="create-new-account"] > input:valid {
  outline: solid green 0.2em;
}

form[name="create-new-account"] > label:not(:placeholder-shown):invalid,
form[name="create-new-account"] > input:not(:placeholder-shown):invalid {
  outline: solid red 0.1em;
}
</style>
{% endcapture %}

```html
{{- obliterate_event_listeners__example_css -}}
```

...  And a framework free example of leveraging JavaScript to validate input
password values before allowing the `form` element to do its thing;

{% capture obliterate_event_listeners__example_javascript %}
<script>
function validateNewAccountPasswords(event) {
  const password_new = document.getElementById('password-new');
  const password_confirm = document.getElementById('password-confirm');

  if (password_new.value !== password_confirm.value) {
    event.preventDefault();

    const message = 'Passowrds need to match';
    password_confirm.setCustomValidity(message);
    console.error(message);

    setTimeout(() => {
      password_confirm.setCustomValidity('');
    }, 1000);
  }
  // Otherwise let the form do what the form do
}

window.addEventListener('load', (loaded_event) => {
  const form = document.querySelector('[name="create-new-account"]');
  form.addEventListener('submit', validateNewAccountPasswords);
});
</script>
{% endcapture %}

```html
{{- obliterate_event_listeners__example_javascript -}}
```

> Note; the use of `setTimeout` allows the client to re-click the submit input
> after correcting any typos.  If we didn't clear the state after a second or
> two then clients would need to refresh the whole page between attempts.


______


## Live-ish example
[heading__liveish_example]: #liveish-example


{{- obliterate_event_listeners__example_css -}}
{{- obliterate_event_listeners__example_html -}}
{{- obliterate_event_listeners__example_javascript -}}

