---
vim: spell nowrap textwidth=79

title: Proompt engineer challange Nix `attrsOf`
description: An open invite to AI minimalists to show-off proompting prowess
categories: [ ai, proompt, linux, llm, ml, nix, nixos ]
author: S0AndS0
layout: post

time_to_live: 1800
date: 2025-08-18 17:39 -0700
# date_updated: 

social_comment:
  links:
    - text: Blue Sky
      href: https://mastodon.social/@S0AndS0/115053163185979107
      title: Link to Post thread for this post
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_proompt-engineer-challange-nix-attrsof-activity-7363402424809644032-ihPE
      title: Link to comment thread for this post
    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/115053163185979107
      title: Link to Toot thread for this post
    - text: Twitter
      href: https://x.com/S0_And_S0/status/1957636755206623712
      title: Link to Tweet thread for this post
---



Recently while learning the ways of Nix the language, NixOS the operating
system, and Nix module types I ran into some oddness related to documented
behavior vs run-time behavior;

```nix
opt = lib.mkOption { type = lib.types.bool; default = false; }

modType = lib.types.submodule { options.enable = opt; }

targetType = lib.types.attrsOf modType

targetType.check ""
#> false (this is good)

targetType.check {}
#> true (but expected false, this is not good)

targetType.check { options.enable = "wat"; }
#> true (but expected false, this is very naughty)
```

...  So proompt engineers here's your challenge; take the following proompt,
make it good, make it work, make it make LLM make no mistakes!

````markdown
I'm trying to understand types for NixOS/Home-Manager modules, found the
[`nix.dev` -- Module System -- Deep Dive][1], and am trying to apply it with
`lib.types.attrsOf`

End goal is something like;

- `{}` → `false`
- `{ options.enable = "wat"; }` → `false`
- `{ options.enable = bool; }`  → `true`

...  however, everything I've tried doesn't seem to cause `.check` to limit
attribute sets that only contain given _shape_

Here's a distilled REPL example which I think demonstrates my skill-issues;

```nix
opt = lib.mkOption { type = lib.types.bool; default = false; }

modType = lib.types.submodule { options.enable = opt; }

targetType = lib.types.attrsOf modType

targetType.check ""
#> false (this is good)

targetType.check {}
#> true (but expected false, this is not good)

targetType.check { options.enable = "wat"; }
#> true (but expected false, this is very naughty)
```

... happen to know how I can declare an attribute set type with a given shape?

[1]: https://github.com/NixOS/nix.dev/blob/master/source/tutorials/module-system/deep-dive.md#nested-submodules
````

To be considered a winner, the prize for which is bragging rights and nothing
more, you must provide the proompt you used that produces correct and accurate
output.

Submit your proompt via one of the various social media links for consideration
to be reviewed.

