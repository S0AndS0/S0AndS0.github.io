---
vim: spell nowrap textwidth=79

title: Firejail wrap binaries automatically
description: My first love letter written to the Nix programming language
categories: [ nix, nixos, linux ]
author: S0AndS0
layout: post

time_to_live: 1800
date_updated: 2025-07-16 15:35:00 -0700
date: 2025-07-15 14:30:00 -0700

image: assets/images/nix/firejail-wrap-binaries-automatically/first-code-block.png
# social_comment:
#   links:
#     - text: Blue Sky
#       href: 
#       title: Link to Post thread for this post
#     - text: GitHub Issue
#       href: 
#       title: Link to Post thread for this post
#     - text: LinkedIn
#       href: 
#       title: Link to comment thread for this post
#     - text: Mastodon
#       href: 
#       title: Link to Toot thread for this post
#     - text: Twitter
#       href: 
#       title: Link to Tweet thread for this post

attribution:
  links:
    - text: Reddit -- How to the entire configuration.nix into `nix repl` for inspection?
      href: https://www.reddit.com/r/NixOS/comments/u6fl8j/how_to_the_entire_configurationnix_into_nix_repl/
      title: How to interactively inspect NixOS configuration

    - text: GitHub -- Nix Comunity -- nixdoc
      href: https://github.com/nix-community/nixdoc
      title: The recomended way of formatting doc-comments in Nix files

    - text: NixOS Wiki -- Firejail
      href: https://wiki.nixos.org/wiki/Firejail
      title: Official tips/tricks for configuring `firejail` on NixOS

    - text: NixOS Wiki -- Error handling
      href: https://wiki.nixos.org/wiki/Error_handling
      title: Current state of the art for Nix error handling

    - text: Nix Manual -- `builtins.intersectAttrs`
      href: https://nix.dev/manual/nix/2.23/language/builtins#builtins-intersectAttrs
      title: Nix Manual -- `builtins.intersectAttrs`

    # - text: 
    #   href: 
    #   title: 

---



Recently I've been experimenting with NixOS which, in addition to helping
reclaim my virginity, has caused me to get deep into learning the Nix language!

For the most part things mostly work...  _mostly_...  but one of my favorite
security software packages, `firejail` and it's friend `firecfg`, requires a
bit more manual attention than I'd prefer.

The `firecfg` package on other Linux flavored distributions is charged with
setting-up executable links/overrides for applications known to work okay with
`firejail`; conveniently listed in the `/etc/firejail/firecfg.config` file.
However on NixOS, for reasons of read-only filesystem/target, it fails to bring
the joy of easy setup.

...  Not all is lost though!

Because the [NixOS Wiki -- Firejail](https://wiki.nixos.org/wiki/Firejail)
article shows there be a `programs.firejail.wrappedBinaries` attribute set that
can be configured, and with the power of Nix programming it _should_ be
possible to link profiles on every build...  _"should"_ what a loaded word.

Tragically the combo of also liking KDE along with deprecation errors,
currently related to the `ark` package but there probably be more, has
transformed what was thought _should_ be a relatively easy introduction to Nix
programming into a set of features that be creeping!


______


## REPL cheat sheet

```nix
# pushd /etc/nixos && nix repl

:lf /etc/nixos

pkgs = import <nixpkgs> {}

config = nixosConfigurations.nixos.config

testWrapper = import ./packages/firejail.nix { config = config; pkgs = pkgs; }
```


______


## Questionable coding choices


Some notes worthy of noting before diving into code; yes, I'm new to Nix; no, I
don't know any better; yes, I'd like help from expert(s)...  also I'm trying to
avoid _experimental_ features, such as pipe operator `|>` because I'd
eventually like to submit something to the Nix community!

`````nix
# /etc/nixos/packages/firejail.nix
{ config, pkgs, ... }:
let
  /**
    Strip commented and empty lines from `firecfg.config` and return list of
    package names that _should_ be compatible for automatic `firejail` wrapping
  */
  listFirejailPackages = path:
  let
    _text = builtins.readFile path;
    _lines = builtins.filter (x: builtins.isString x) (builtins.split "\n" _text);
    _filter_comments = (x: (builtins.match "^(( *#)( )*(.*)|$)" x) == null);
  in
  builtins.filter _filter_comments _lines;

  /**
    Hunt through `systemPackages` list and return first one with `x.name` or
    `x.pname` matching provided `name` or return `null` otherwise
  */
  findPackage = { name, systemPackages }:
  let
    _p = builtins.filter (x:
      (builtins.hasAttr "pname" x && x.pname == name)
      || (builtins.hasAttr "name" x && x.name == name)
    ) systemPackages;
  in
  if builtins.length _p > 0 then
    (builtins.head _p)
  else
    null;

  /**
    Create attribute set compatible with `programs.firejail.wrappedBinaries`
  */
  wrapBins = { systemPackages, path }:
  let
    _firejailPackages = listFirejailPackages path;
    _wrappable = builtins.filter (name:
      (findPackage { name = name; systemPackages = systemPackages; } != null)
      && (builtins.tryEval "${pkgs.${name}}/bin/${name}").success
    ) _firejailPackages;
  in
  builtins.listToAttrs (builtins.map (
    name: {
      name = name;
      value = {
        executable = "${pkgs.${name}}/bin/${name}";
        profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
        desktop = pkgs.lib.mkIf (
          builtins.pathExists "${pkgs.${name}}/share/applications/${name}"
        ) "${pkgs.${name}}/share/applications/${name}";
      };
    }
  ) _wrappable);
in
{
  programs.firejail = {
    enable = true;

    wrappedBinaries = wrapBins {
      systemPackages = config.environment.systemPackages;
      path = "${pkgs.firejail.outPath}/etc/firejail/firecfg.config";
    };
  };
}
`````

The above, as nasty as it may look, acktually works!...  _mostly_

`firejail --list` will expose things like `librewolf` are wrapped with the
appropriate profile, and that is happy news.

The thing that is gnawing at my brain though is removing the `builtins.tryEval`
portion of `_wrappable` filter;

```diff
   let
     _firejailPackages = listFirejailPackages path;
     _wrappable = builtins.filter (name:
       (findPackage { name = name; systemPackages = systemPackages; } != null)
-      && (builtins.tryEval "${pkgs.${name}}/bin/${name}").success
+      # && (builtins.tryEval "${pkgs.${name}}/bin/${name}").success
     ) _firejailPackages;
   in
   builtins.listToAttrs (builtins.map (
```

...  creates an error when `programs.firejail.wrappedBinaries.ark.executable`,
and others, are evaluated.  For example;

> error: The top-level ark alias has been removed.
>
> Please explicitly use kdePackages.ark for the latest Qt 6-based version, or libsForQt5.ark for the deprecated Qt 5 version.
>
> Note that Qt 5 versions of most KDE software will be removed in NixOS 25.11.


______


## Things currently being considered


There seems to be a `builtins.warn` which could be useful for exposing which
packages that may need a human touch, ex;

```diff
   let
     _firejailPackages = listFirejailPackages path;
     _wrappable = builtins.filter (name:
       (findPackage { name = name; systemPackages = systemPackages; } != null)
-      && (builtins.tryEval "${pkgs.${name}}/bin/${name}").success
+      && (
+        (builtins.tryEval "${pkgs.${name}}/bin/${name}").success
+        || (builtins.warn "firejail -- No joy auto-wrapping ${name}" false)
+      )
     ) _firejailPackages;
   in
   builtins.listToAttrs (builtins.map (
```

...  and this too works!  I.E. rebuilds rebuild without errors, only warnings,
but due to `builtins.tryEval` gobbling error messages I ain't happy with saying
this be _solved_ sufficiently.

Sure doing a bit of `{ a = "a"; } // { b = "b" }` set updating could work, for
now.  And sure there only be four packages, `ark`, `gwenview`, `kdenlive`, and
`okular` popping warnings on my device...  for now.  But it really feels like
manually fiddling with this runs counter to reliably reproducible builds.

Also it wouldn't surprise me to find other window managers might have similar
deprecation errors.

Either way, at time of writing, tests have hosed the memory or thrashed the
file-system so hard that shutting-down, hard, be necessary...  So this'll have
to plague my dreams for now.


______


## Sleeping with the problem sometimes helps


For you dear reader(s) it may have been a split-second's scroll but, for me, it
was hours between the previous sub-section and what's to follow!

Hard shut-downs and running `e2fsck` on an encrypted partition's filesystem, no
matter how resilient `ext4` be, is kinda scary.  More on that maybe in a
different post though...

Because it's time to expose some Nix code that satisfies my desires for
automated wrapping of executables known to work okay with `firejail`!

```nix
# /etc/nixos/packages/firejail.nix
{ config, pkgs, ... }:
let
  _firejailText = builtins.readFile "${pkgs.firejail.outPath}/etc/firejail/firecfg.config";

  ## [ "ark" "librewolf" ... ]
  _firejailNames = builtins.filter (x:
    builtins.isString x
    && ((builtins.match "^(( *#)( )*(.*)|$)" x) == null)
  ) (builtins.split "\n" _firejailText);

  ## { ark = null; librewolf = null; ... }
  _firejailAttrs = builtins.listToAttrs (builtins.map (
    (name: { name = name; value = null; })
  ) _firejailNames);

  ## [ { pname = "ark"; ...} {...} ] ==> { ark = {...}; librewolf = {...}; ... }
  _installedAttrs = builtins.listToAttrs (
    builtins.map (x: { name = x.pname; value = x; }) (
      builtins.filter (x:
        builtins.hasAttr "pname" x
        && builtins.hasAttr "outPath" x
      ) config.environment.systemPackages
    )
  );

  ## { ark = {...}; librewolf = {...}; ... }
  _firejailWrappables = builtins.intersectAttrs _firejailAttrs _installedAttrs;

  _wrappedBins = builtins.mapAttrs (name: value: {
    executable = "${value.outPath}/bin/${name}";
    profile = "${pkgs.firejail}/etc/firejail/${name}.profile";
    desktop = pkgs.lib.mkIf (
      builtins.pathExists "${value.outPath}/share/applications/${name}"
    ) "${value.outPath}/share/applications/${name}";
  }) _firejailWrappables;
in
{
  programs.firejail = {
    enable = true;

    wrappedBinaries = _wrappedBins;
  };
}
```

About twenty fewer lines, no more nesting of `let`/`in` scopes, no more
`tryEval`, and the resulting expression is simpler to reason about.  Plus, not
that it matters for my small system, by replacing `findPackage` with
`builtins.intersectAttrs` it _should_ run a little faster too.

Over all I'm reasonably happy with results, problem is solved.  And I don't
have too much to complain about, considering this is my first serious attempt
at writing Nix code after a few days of reading.

But readers are free to tell me, via the usual methods, where and how I'm wrong
;-)

