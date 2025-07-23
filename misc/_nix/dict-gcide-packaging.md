---
vim: spell nowrap textwidth=79

title: Dict GCIDE packaging
description: Learned NixOS packages good by doing wrong things with the GNU flavored Dict
categories: [ nix, nixos, linux ]
author: S0AndS0
layout: post

time_to_live: 1800
date: 2025-07-18 12:58:00 -0700
# date_updated: 2025-07-21 14:30:00 -0700

image: assets/images/nix/dict-gcide-packaging/first-code-block.png
social_comment:
  links:
    - text: Blue Sky
      href: https://bsky.app/profile/s0-and-s0.bsky.social/post/3lulrlz5zms2s
      title: Link to Post thread for this post
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_dict-gcide-packaging-activity-7353583716725678082-dCIT/
      title: Link to comment thread for this post
    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/114899743346352855
      title: Link to Toot thread for this post
    - text: Twitter
      href: https://x.com/S0_And_S0/status/1947817871268057283
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: AUR -- `dict-gcide`
      href: https://aur.archlinux.org/packages/dict-gcide
      title: Arch User Repository package for `dict-gcide`

    - text: 'GitHub -- NixOS nixpkgs -- Issue 248974 -- Package request: dict-gcide'
      href: https://github.com/NixOS/nixpkgs/issues/248974
      title: '`NixOS/nixpkgs` -- Package request: dict-gcide'

    - text: GCIDE -- GNU Collaborative International Dictionary of English
      href: https://gcide.gnu.org.ua/
      title: GCIDE -- GNU Collaborative International Dictionary of English 

    - text: Jade -- Building Nix derivations manually in nix-shell
      href: https://jade.fyi/blog/building-nix-derivations-manually/
      title: Jade -- Building Nix derivations manually in nix-shell

    - text: MyNixOS -- Services `dictd`
      href: https://mynixos.com/options/services.dictd
      title: MyNixOS -- Services `dictd`

    - text: NixOS Wiki -- Dict
      href: https://nixos.wiki/wiki/Dict
      title: NixOS Wiki -- Dict

    - text: NixOS Wiki -- Nixpkgs/Create and debug packages
      href: https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages
      title: NixOS Wiki -- Nixpkgs/Create and debug packages

    - text: 'NixOS Discourse -- Dict: offline version?'
      href: https://discourse.nixos.org/t/dict-offline-version/33004
      title: 'NixOS Discourse -- Dict: offline version?'

    - text: Unix Stack Exchange -- How to get path of installed package in the nix store?
      href: https://unix.stackexchange.com/questions/790954/how-to-get-the-path-of-installed-package-in-the-nix-store
      title: How to get path of installed package in the nix store?

    # - text: 
    #   href: 
    #   title: 

---



Not to get too personal with ya, dear reader, but I've long struggled with
spelling things good.  English spelling in particular, especially instances of
homonyms, homophones, and their friends.  So there be certain tools I use to
reduce the likelihood that my spell-checker reliance causes an accidental
_embracing_ situation (-;

Vim's thesaurus combo-ed spell-checker features, I use Vim BTW™, be fantastic
for reducing phobias of unintentional faux pas.  But every now and again I need
a good dictionary to ensure I'm making sense, since being understood is kinda
a big part of communication.

Generally I like offline solutions especially for things that could, and use to
be, done with books.  Ya know the things made of dead trees.  So after finding
the AUR's package of GCIDE I've been pretty happy on Arch, I use Arch BTW™, and
even made a [Vim plugin](https://github.com/vim-utilities/dict/) for
speeding-up my workflow while writing too.

Tragically GCIDE, as far as I could find, ain't available in NixOS's packages.
At least on the unstable branch some-when 'round 2025-07-01, but fortunately
for you and I this also presents an _opportunity_...

An opportunity to explore doing lots of wrong things with Nix packages in order
to get GNU flavored Dict happily integrated!


______


## Small package example


Feel free to follow along by creating a simple Nix package;

```bash
pushd "$(mktemp -d)";

touch default.nix;
```

...  Then populating that `default.nix` file that was `touch`-ed into existence
with something like;

> `/tmp/tmp.<ID>/default.nix`

```nix
{
  pkgs ? import <nixpkgs> { },
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "my-pretty-package";
  version = "0.68.419";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = false;
  doCheck = false;

  src = ./.;

  installPhase = ''
    install -m 0755 -d "$out";
    echo "wasssup?!" > "$out/test.txt";
  '';
}
```

...  The `pname`, `version`, `src`, and `installPhase` attributes above are
required.  And the `dontUnpack`, `dontConfigure`, `dontBuild`,
`doInstallCheck`, and `doCheck` are there to skip things that are not
necessary.

The `pkgs ? import <nixpkgs> { }` bit ensures `pkgs` is defined.  And that
special key word `rec` stands for recursive, which'll allow for re-using
attributes within the same set; something that'll be useful in the future.

Building should succeed with the following command;

```bash
nix-build default.nix;
```

...  And doing an `ls result/` _should_ show a newly created `test.txt` file;
good so far!


______


## Packaging GNU flavored Dict


Fortunately the folks maintaining GCIDE on the AUR have done much in the ways
of making reproducible builds, and better still is the `PKGBUILD` file are
acktually Bash scripts, so it shouldn't be too difficult to translate things...
Right?

It _should_ not be difficult at all...

---

### Yoink hard-work done by AUR team

```bash
mkdir ~/git/aur.archlinux.org;
pushd ~/git/aur.archlinux.org;
git clone ssh://aur@aur.archlinux.org/dict-gcide.git;
popd;
```

> **Warning from the future** the cloned Git repository will _not_, I repeat
> **not**, have tagged versions!  And the `sed` scripts seem very much targeted
> to specific versions of GCIDE, meaning readers following along at home will
> either need to pay attention to differences, or run;
>
> `git checkout 8cca07ed8d6b6da68e0bcbbda6d5ede6ee3faabc`
>
> ...  to ensure reasonably reproducible builds.


______


## Translate `PKGBUILD:source` to `default.nix:src`

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
# ...
_major_debver=0.48
_debver="${_major_debver}.5+nmu4"
pkgver=0.53
# ...
source=('fixes.sed'
        'post_webfilter.sed'
        'check.sed'
        "https://deb.debian.org/debian/pool/main/d/${pkgname}/${pkgname}_${_debver}.tar.xz"
        "https://ftp.gnu.org/gnu/gcide/gcide-${pkgver}.tar.xz"{,.sig})
# ...
```

The above `.sed` scripts can be copied easy enough;

```bash
sudo mkdir -p /etc/nixos/packages/dict-gcide/sed-scripts;

sudo cp ~/git/aur.archlinux.org/dict-gcide/{check,fixes,post_webfilter}.sed /etc/nixos/packages/dict-gcide/sed-scripts/;

sudo touch /etc/nixos/packages/dict-gcide/default.nix
```

And the first URL pointing at Debian dot Org can be handled by Nix's
`pkgs.fetchurl` function;

> `/etc/nixos/packages/dict-gcide/default.nix`

```nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation rec {
  pname = "dict-gcide";
  version = "0.54";

  _major_debver="0.48";
  _debver="${_major_debver}.5+nmu4";

  src = pkgs.fetchurl {
    url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
    hash = "";
  };
}
```

...  Notice the `hash` is internally defined as an empty string, that's so the
following build failure will expose expected hash;

```bash
nix-build default.nix
# ...
#> error: hash mismatch in fixed-output derivation '/nix/store/<id>-dict-gcide_<_debver>.tar.xz.drv'
#>          specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#>                got: sha256-45ITB4SnyRycjchdseFP5J+XhZfp6J2Dm5q+DJ/N4A4=
# ...
```

By placing the `got` value into the `hash` string it be possible to move on to
popping more errors!

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   src = pkgs.fetchurl {
     url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
-    hash = "";
+    hash = "sha256-45ITB4SnyRycjchdseFP5J+XhZfp6J2Dm5q+DJ/N4A4=";
   };
 }
```

Now running `nix-build` should result in new errors;

```bash
nix-build default.nix
# ...
#> install cannot create regular file '/usr/lib/dict': No such file or directory
#> error: builder for '/nix/store/<ID>-dict-gcide.drv' failed with exit code 2
```

...  And new errors is what I can call progress x-)

______


## Translate `PKGBUILD:prepare` to `default.nix:patchPhase`


For the most part the previous errors can be ignored, mostly because the
default behaviors of `pkgs.stdenv.mkDerivation` must be modified.

This part was reasonably easy to translate from AUR's `prepare` Bash function
into something that'll satisfy Nix;

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
prepare()
{
    cd "${pkgname}"

    sed -Ei \
        "s/\"(The Collaborative International Dictionary of English) v.${_major_debver}\"/\"\\1 v.${pkgver}\"/" \
        scan.l

    # Remove autogenerated autotools files.
    rm config.guess config.h.in config.sub configure install-sh
}
```

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   src = pkgs.fetchurl {
     url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
     hash = "sha256-45ITB4SnyRycjchdseFP5J+XhZfp6J2Dm5q+DJ/N4A4=";
   };
+
+  patchPhase = ''
+    printf >&2 '## Update version in scan.l\n';
+    sed -Ei "/The Collaborative International Dictionary of English v.${_major_debver}/ {
+      s/${_major_debver}/${version}/ ;
+    }" scan.l;
+
+    printf >&2 '## Remove autogenerated autotools files.\n'
+    rm config.guess config.h.in config.sub configure install-sh
+  '';
 }
```

...  Interactive testing exposed changes to `sed` command didn't break
anything, and better still resulted in the same results!  But feeling,
apprehensively, good about it is likely to lead to over confidence.


______


## First few bits of `PKGBUILD:build` to `default.nix:configurePhase`


Next up is pouncing on translating two whole lines from AUR's package to Nix!
Specifically the following two lines;

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
build()
{
    # ...
    autoreconf -fis
    ./configure
    # ...
}
```

...  seems simple enough x-)

---

### Satisfy `autoreconf`

As a refresher, because there has and will be much diff/changes, here be the
current state of the `default.nix` file;

> `/etc/nixos/packages/dict-gcide/default.nix`

```nix
# /etc/nixos/packages/dict-gcide/default.nix
let
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation rec {
  pname = "dict-gcide";
  version = "0.54";

  _major_debver="0.48";
  _debver="${_major_debver}.5+nmu4";

  src = pkgs.fetchurl {
    url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
    hash = "sha256-45ITB4SnyRycjchdseFP5J+XhZfp6J2Dm5q+DJ/N4A4=";
  };

  patchPhase = ''
    printf >&2 '## Update version in scan.l\n';
    sed -Ei "/The Collaborative International Dictionary of English v.${_major_debver}/ {
      s/${_major_debver}/${version}/ ;
    }" scan.l;

    printf >&2 '## Remove autogenerated autotools files.\n'
    rm config.guess config.h.in config.sub configure install-sh
  '';

  configurePhase = ''
    autoreconf -fis;
  '';
}
```

That `autoreconf -fis` line doesn't take nicely to Nix's advances;
```bash
nix-build default.nix;
# ...
#> /nix/store/<id>-stdenv-linux/setup: line 1763: autoreconf: command not found
#> error: builder for '/nix/store/<ID>-dict-gcide.drv' failed with exit code 2
```

...  and demands satisfaction of certain dependencies!

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   };
+
+  buildInputs = with pkgs; [
+    autoconf
+    automake
+  ];
+
   patchPhase = ''
```

Re-running the `nix-build` command now doesn't pop any new hard errors, and no
errors is good errors :-)

---

### Try to move on with configuring

Next line is the deceptively simple `./configure` and surely it won't be surly,
right?...  Right?!

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   configurePhase = ''
     autoreconf -fis;
+    ./configure;
   '';
 }
```

But of course it needs something called `libmaa`, "what's LibMaa for?", some
may ask...

```bash
nix-build default.nix;
# ...
#> configure: error: ./configure failed for libmaa
```

...  To which I may shrug in reply and say, "for satisfying GNU's `dict` of
course!"

---

### Wherefore art `libmaa`

Hunting for packages on Nix takes many forms, some use the web, I however like
the CLI;

```bash
nix search nixpkgs 'libmaa'
#> error: no results for given search item(s)!
```

...  but no joy!  Hmm, time to hunt with Vim, I use Vim BTW™;

```vim
:vimgrep /libmaa/ ~/git/hub/NixOS/nixpkgs/**/*.nix
```

And this brings much joy!  For someone did package `libmaa`, but it seems
hidden behind the `dict` package that uses web databases;

- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/default.nix` **(snip)**
   ```nix
   { /*...*/ }:
   stdenv.mkDerivation rec {
     # ...
     buildInputs = [
       libmaa
       zlib
     ];
     # ...
   }
   ```
- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/libmaa.nix`, nothing exciting here
- `~/git/hub/NixOS/nixpkgs/pkgs/top-level/all-packages.nix` **(snip)**
   ```nix
   { /*...*/ }:
   with pkgs;

   {
     # ...
     dict = callPackage ../servers/dict {
       flex = flex_2_5_35;
       libmaa = callPackage ../servers/dict/libmaa.nix { };
     };
     # ...
   }
   ```

...  Okay.  `libmaa` existence is confirmed as Nix package, but not directly
exposed in the `nixpkgs.pkgs` name-space?

---

### My future self will loath me so much for this

Playing in the REPL showed `libmaa` is accessible via `pkgs.dict.buildInputs`
which'll satisfy GNU's `dict`...  for now...

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
 let
   pkgs = import <nixpkgs> { };
+  libmaa = builtins.head (builtins.filter (x: x.pname == "libmaa") pkgs.dict.buildInputs);
 in
```


> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   buildInputs = with pkgs; [
     autoconf
     automake
-  ];
+  ]
+  ++ [
+    libmaa
+  ];

   patchPhase = ''
```


______


## Translate remaining `PKGBUILD:build` to `default.nix:buildPhase`


Two lines conquered, and just a few more to go!

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
build()
{
    # ...
    make -j1
    # ...
}
```

The `make` command feels like a build step, so I'm gonna put it in the
`buildPhase` for Nix;

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   configurePhase = ''
     autoreconf -fis;
     ./configure;
   '';
+
+  buildPhase = ''
+    printf >&2 '## Run: make -j1\n';
+    make -j1;
+  '';
 }
```

...  And another attempt at building to expose new errors;

```bash
nix-shell --repair default.nix;
#> ...
#> flex -owebfilter.c webfilter.l
#> /bin/sh: line 1: flex: command not found
#> make: *** [Makefile:161: webfilter.c] Error 127
```

Fortunately a little web-searching and `nix search nixpkgs 'flex'` showed there
be packages available to satisfy `make`...

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   buildInputs = with pkgs; [
     autoconf
     automake
+    bison
+    flex
   ]
   ++ [
     libmaa
   ];
```

...  and now new build errors be ah popping;

```bash
nix-shell --repair default.nix;
#> ...
#> Error:
#> 
#> ?:?: syntax error
#> ?:?: <source line not available>
#> webfmt (yyerror): parse error
#> make: (yyerror): parse error
#> make: *** [Makefile:109: gcide.index] Error 1
#> error: builder for '/nix/store/<ID>-dict-gcide.drv' failed with exit code 2
```

But I ain't too concerned, probably should be, because there are `sed` scripts
with names like `fixes.sed` and `post_webfilter.sed`, as well as comments which
may lead one to believe builds _should_ fail without further intervention.

---

### So now how to invite `sed` to play?

AUR's `dict-gcide` package builder has certain `sed` scripts to patch stuff;

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
build() {
    # ...

    # Do the conversion explicitly, instead of `make db', to account for all
    # the differences to the original build process.
    # LANG=C is required so that the index file is properly sorted.
    ../fixes.sed "../gcide-${pkgver}"/CIDE.? \
        | sed -f debian/sedfile \
        | ./webfilter \
        | ../post_webfilter.sed \
        | tee pre_webfmt.data \
        | LANG=C ./webfmt -c
    # ...
}
```

...  Nix, however, seems to need a bit of _encouragement_ to access scripts.
Because an `ls -ahl` shows nothing from the `/etc/nixos/packages/dict-gcide`
directory be in the build environment.

This is understandable from Nix's perspective, a perspective of valuing
reproducible builds.

But, reproducing builds be secondary to the end goal of having GNU flavored
`dict`!  So again yoinking at the `dict` package from Nix for examples the
following bits got shooken out;

> `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/dictd-wordnet.nix` **(snip)**

```nix
{ /*...*/ }:
stdenv.mkDerivation rec {
  # ...
  convert = ./wordnet_structures.py;

  builder = writeScript "builder.sh" ''
    # ...
    faketime -f "$source_date" python ${convert} $DATA
    # ...
  '';
}
```

...  it seems possible to assign file path(s) to attribute set keys, and then
call them via string interpolation!

Though it may not be proper at this point to worry about code cleanliness,
`libmaa` be damned, I don't wanna make too big a mess.  So it seems wise to
stuff `sed` script path definitions into the `let`/`in` scope, so as to not
pollute the resulting `mkDerivation` data structure;

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
 let
+  sed-scripts = {
+    check = ./sed-scripts/check.sed
+    fixes = ./sed-scripts/fixes.sed
+    post_webfilter = ./sed-scripts/post_webfilter.sed
+  };
+
   pkgs = import <nixpkgs> { };
   libmaa = builtins.head (builtins.filter (x: x.pname == "libmaa") pkgs.dict.buildInputs);
 in
```

Now within various Nix phases it be possible to access those scripts via
incantations like, `${sed-scripts.fixes}`, and...  though fragile...  it makes
forward progress possible.

---

### Package for my package to package GCIDE

Okay, that's nice and all, buuuut, poking about in the interactive shell as
well as peeping at the AUR's `PKGBUILD` build file; specifically the `build`
function, exposes assumptions about paths that do not yet exist.

As a refresher, here be the bits to translate from AUR's `dict-gcide` to Nix;

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
build() {
    # ...

    # Do the conversion explicitly, instead of `make db', to account for all
    # the differences to the original build process.
    # LANG=C is required so that the index file is properly sorted.
    ../fixes.sed "../gcide-${pkgver}"/CIDE.? \
        | sed -f debian/sedfile \
        | ./webfilter \
        | ../post_webfilter.sed \
        | tee pre_webfmt.data \
        | LANG=C ./webfmt -c
    # ...
}
```

Hmm, that `"../gcide-${pkgver}"/CIDE.?` bit could be a problem!

But, hunting for `pkgver` though exposes a URL defined in the `source` list!

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
source=('fixes.sed'
        # ...
        "https://ftp.gnu.org/gnu/gcide/gcide-${pkgver}.tar.xz"{,.sig})
```

And so another Nix package needs _manifested_ x-)

> `/etc/nixos/packages/dict-gcide/gcide.nix`

```nix
let 
  pkgs = import <nixpkgs> { };
in
pkgs.stdenv.mkDerivation rec {
  version = "0.54";
  pname = "gcide";

  src = pkgs.fetchurl {
    url = "https://ftp.gnu.org/gnu/gcide/${name}-${version}.tar.xz";
    hash = "";
  };

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp ../${pname}-${version}/* $out/
  '';

  dontFixup = true;
  doInstallCheck = false;
  doCheck = false;
}
```

The same song-and-dance for populating the hash...

```bash
nix-build gcide.nix
# ...
#> error: hash mismatch in fixed-output derivation '/nix/store/<id>-dict-gcide_<_debver>.tar.xz.drv'
#>          specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
#>                got: sha256-06y9mE3hzgItXROZA4h7NiMuQ24w7KLLD7HAWN1/MZ8=
# ...
```

...  and once that is sorted, it can be inserted into the `default.nix` via;

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
 let
   sed-scripts = {
     check = ./sed-scripts/check.sed
     fixes = ./sed-scripts/fixes.sed
     post_webfilter = ./sed-scripts/post_webfilter.sed
   };

   pkgs = import <nixpkgs> { };
   libmaa = builtins.head (builtins.filter (x: x.pname == "libmaa") pkgs.dict.buildInputs);
+  gcide = pkgs.callPackage ./gcide.nixs { };
 in
```

Then added to the `buildInputs` list...

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   };

   buildInputs = with pkgs; [
     autoconf
     automake
     bison
     flex
   ]
   ++ [
+    gcide
     libmaa
   ];

   patchPhase = ''
```

...  This is feeling like progress!  And maybe finishing tonight with GNU's
flavor of `dict` is destined...  could a developer hope for such an outcome?

> "Live in hope die in despair", echos the words of my ancestors.

---

### So can `sed` now come out to play?

To ensure all readers, and my future self, are on the same page...  And because
there's been much `diff` churn...  Here be the state of `default.nix` file;

> `/etc/nixos/packages/dict-gcide/default.nix`

```nix
let
  sed-scripts = {
    check = ./sed-scripts/check.sed
    fixes = ./sed-scripts/fixes.sed
    post_webfilter = ./sed-scripts/post_webfilter.sed
  };

  pkgs = import <nixpkgs> { };
  libmaa = builtins.head (builtins.filter (x: x.pname == "libmaa") pkgs.dict.buildInputs);
  gcide = pkgs.callPackage ./gcide.nixs { };
in
pkgs.stdenv.mkDerivation rec {
  pname = "dict-gcide";
  version = "0.54";

  _major_debver="0.48";
  _debver="${_major_debver}.5+nmu4";

  src = pkgs.fetchurl {
    url = "https://deb.debian.org/debian/pool/main/d/${pname}/${pname}_${_debver}.tar.xz";
    hash = "...";
  };

  buildInputs = with pkgs; [
    ## For: autoconf
    autoconf
    automake
    ## For: make
    bison
    flex
  ]
  ++ [
    gcide
    libmaa
  ];

  patchPhase = ''
    sed -Ei "/The Collaborative International Dictionary of English v.${_major_debver}/ {
      s/${_major_debver}/${version}/ ;
    }" scan.l;

    rm config.guess config.h.in config.sub configure install-sh
  '';

  configurePhase = ''
    autoreconf -fis;
    ./configure;
  '';

  buildPhase = ''
    make -j1;

    printf >&2 '## Run sed fixes and post_webfilter scripts\n';
    sed -Ef "${sed-scripts.fixes}" "${gcide.out}"/CIDE.? |
        sed -f debian/sedfile |
        ./webfilter |
        sed -Ef "${sed-scripts.post_webfilter}" |
        tee pre_webfmt.data |
        LANG=C ./webfmt -c;
  '';
}
```

---

### Who doesn't loath a nebulous `?:?: syntax error`

Getting closer now, but, closer to what is up for debate!  Because running the
build command, after succeeding with `make`, and all that came before, now
fails with an oh so very helpful message;

```
Error:

?:?: syntax error
?:?: <source line not available>
webfmt (yyerror): parse error
```

Wat?!

Running interactively, via `nix-shell --repair default.nix`, and running
through that `sed` pipeline...  bit-by-bit...  also shows the same result.

wAT!

It fails at the end, at the `LANG=C ./webfmt -c` bit, which is fine.  Totally
fine!  And not at all an inconvenience :-|

Running `LANG=C ./webfmt -c -v < pre_webfmt.data` within a `nix-shell`
environment exposes the error be popping around `pre_webfmt.data` content of;

```
A \A\ ([.a]), prep. [Abbreviated form of an (As. on). See {On}.]
   1. In; on; at; by. [Obs.] "A God's name." "Torn a pieces."

Error:

?:?: syntax error
?:?: <source line not available>
webfmt (yyerror): parse error
```

...  which is helpful, as it means the pipe-line building `pre_webfmt.data` is
doing so in a way that `./webfmt` doesn't take kindly to.

> Readers, if so inclined, may now imagine guttural screaming of profanity.

Nighttime nap-time, that is what this problem needs, and it can be future me's
responsibility to sort it out.  Like present.  I can be really good to my
future me x-)

---

### Numbers ain't never hurt no-one

Morning arrives, and with it the sinking feeling that past me was not so smort,
no smort at all.

Because, searching for issues against the AUR's package did not yield any
before bedtime joy, and _ideas_ of spelunking through `webfmt` source code
didn't make this one's heart sing...  Plus if history is any teacher, then this
error state likely be my fault.

Time to check assumptions!

So using Vim splits (I use Vim BTW™) with one split exposing
`/etc/nixos/packages/dict-gcide/default.nix`, the second split viewing
`~/git/aur.archlinux.org/dict-gcide/PKGBUILD`, and ah hunting of differences
was begun.

The hunt did not take long!

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
# ...
pkgname=dict-gcide
_major_debver=0.48
_debver="${_major_debver}.5+nmu4"
pkgver=0.53
pkgrel=4
pkgdesc="GNU version of the Collaborative International Dictionary of English for dictd et al."
# ...
```

> `/etc/nixos/packages/dict-gcide/default.nix` (snip)

```nix
let
  # ...
in
pkgs.stdenv.mkDerivation rec {
  pname = "dict-gcide";
  version = "0.54";

  _major_debver="0.48";
  _debver="${_major_debver}.5+nmu4";
# ...
```

`PKGBUILD` defines `pkgver=0.53` and `default.nix` defines `version = "0.54"`

> Readers, if so inclined, may now imagine the sound of palm meeting forehead.

Down-grading the version in `default.nix` and doing the `hash` comment _dance_
resulted in joy...  <sup>eminence joy</sup>...  because `./webfmt` was finally
satisfied with inputs from `sed` pipeline!

> Readers, if so inclined, may now imagine the whoosh of fists thrust to sky.

---

### Almost done with build just need to access `dictzip`

There now be but two lines left to transfer from AUR's `build` function to
something that Nix will execute within the `buildPhase`, and only one of 'em
really counts as possibly interesting;

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
build() {
    # ...
    # `dictzip -v' neglects to print a final newline.
    dictzip -v gcide.dict
    printf '\n'
}
```

Perhaps lucky I can be, and it'll just require adding a `buildInputs` package?

```bash
nix search nixpkgs 'dictzip'
#> error: no results for given search item(s)!
```

...  Nope.

But `vimgrep` helped last time to expose hidden packages within Nix ecosystem;

```vim
:vimgrep /dictzip/ ~/git/hub/NixOS/nixpkgs/**/*.nix
```

- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/dictd-db-collector.nix` **(snip)**
   ```nix
   { /*...*/ }:
   stdenv.mkDerivation rec {
     nativeBuildInputs = [
       # ...
       dict
       # ...
     ];
     # ...
     installPhase = ''
       # ...
             faketime -f "$source_date" dictzip "$base".dict
       # ...
     '';
     # ...
   }
   ```
- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/wiktionary/default.nix` **(snip)**
   ```nix
   { /*...*/ }:
   stdenv.mkDerivation rec {
     nativeBuildInputs = [
       # ...
       dict
       # ...
     ];
     # ...
     installPhase = ''
       # ...
       faketime -f "$source_date" dictzip wiktionary-en.dict
       # ...
     '';
   }
   ```

...  So `dictzip` is available!  And the interactive REPL shows the `dict`
package is indeed hiding the `dictzip` executable;

```nix
nix-repl> pkgs.dict.outPath
#> "/nix/store/<ID>-dictd-1.13.3"
```

But will yoinking it require more questionable code?

Checking the output path for the existence of `dictzip` results in hope;

```bash
test -f /nix/store/<ID>-dictd-1.13.3/sbin/dictzip && echo woot
#> woot
```

...  It couldn't be as easy as adding the `dict` package, could it?

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   buildInputs = with pkgs; [
     ## For: autoconf
     autoconf
     automake
     ## For: make
     bison
     flex
+    ## For: dictzip
+    dict
   ]
   ++ [
     gcide
     libmaa
   ];
```

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   buildPhase = ''
     make -j1;

     printf >&2 '## Run sed fixes and post_webfilter scripts\n';
     sed -Ef "${sed-scripts.fixes}" "${gcide.out}"/CIDE.? |
         sed -f debian/sedfile |
         ./webfilter |
         sed -Ef "${sed-scripts.post_webfilter}" |
         tee pre_webfmt.data |
         LANG=C ./webfmt -c;
+
+     printf '## Run: dictzip -v gcide.dict\n';
+     dictzip -v gcide.dict;
+     printf '\n';
   '';
+
+  doCheck = true;
+  checkPhase = ''
+    echo woot;
+  '';
 }
```

```bash
nix-build --repair default.nix
#> ...
#> ## Run: dictzip -v gcide.dict
#> chunk 687: 40049997 of 40049997 total
#> Running phase: checkPhase
#> woot
#> Running phase: fixupPhase
#> error: builder for '/nix/store/<ID>-dict-gcide-0.53.drv' failed to produce output...
```

That is success...  Err, well successfully done with the `buildPhase`, and it
is the responsibility of the `checkPhase` to do what the `check` function in
AUR's `PKGBUILD` script do!


______


## Translate `PKGBUILD:check` to `default.nix:checkPhase`

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
check()
{
    errors="$(./check.sed < "${pkgname}/pre_webfmt.data")"

    if test -n "$errors"
    then
        printf 'Errors found:\n'
        printf '%s\n' "$errors"
        return 1
    fi
}
```

The above looks like it _should_ be easy, little copy/pastry, shift shell
arguments from `sed` script's shebang, and pop the `echo woot` into a new
`installPhase`...  and it was easy!

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   doCheck = true;
   checkPhase = ''
-    echo woot;
+    errors="$(sed -nEf "${sed-scripts.check}" < ./pre_webfmt.data)";
+
+    if test -n "$errors"; then
+      printf >&2 'Errors found:\n';
+      printf >&2 '%s\n' "$errors";
+      exit 1;
+    fi
   '';
+
+  installPhase = ''
+    echo woot;
+  '';
 }
```

Another command to Nix build, and another phase _woot-ing_

```bash
nix-build --repair default.nix
#> ...
#> ## Run: dictzip -v gcide.dict
#> chunk 687: 40049997 of 40049997 total
#> Running phase: checkPhase
#> Running phase: installPhase
#> woot
#> Running phase: fixupPhase
#> error: builder for '/nix/store/<ID>-dict-gcide-0.53.drv' failed to produce output...
```


______


## Translate `PKGBUILD:package` to `default.nix:installPhase`


Now to satisfy Nix it seems all that's left to do is, translate the `package`
function from `PKGBUILD` into something the `default.nix` file can execute
within the `installPhase`, which _should_ be relatively easy...

> `~/git/aur.archlinux.org/dict-gcide/PKGBUILD` **(snip)**

```bash
package()
{
    install -m 0755 -d "${pkgdir}/usr/share/dictd"
    install -m 0644 -t "${pkgdir}/usr/share/dictd/" \
        "${pkgname}"/gcide.{dict.dz,index}

    install -m 0755 -d "${pkgdir}/usr/share/doc/dict-gcide"
    install -m 0644 -t "${pkgdir}/usr/share/doc/dict-gcide/" \
        "gcide-${pkgver}"/{README,INFO,pronunc.txt}
}
```

...  Effectively replacing `${pkgdir}` with `$out`, and `${pkgver}` with
`${gcide.out}`, _should_ be all that Nix now needs to be happy;

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   installPhase = ''
-    echo woot;
+    install -m 0755 -d "$out/usr/share/dictd";
+    install -m 0644 -t "$out/usr/share/dictd/" ./gcide.{dict.dx,index};
+
+    install -m 0755 -d "$out/share/doc/dict-gcide";
+    install -m 0644 -t "$out/share/doc/dict-gcide/" "${gcide.out}"/{README,INFO,pronunc.txt};
   '';
 }
```

______


## Taste of first successful GNU flavored `dict` build


```bash
nix-build --repair default.nix;
#> /nix/store/<ID>-dict-gcide

ls result;
#> usr

ls result/usr/share;
#> dictd doc

ls result/usr/share/dictd;
#> gcide.dict.dz gcide.index
```

Woot!

It ain't pretty, nor are certain bits gonna work with a full system build, but
integration with NixOS _should_ be relatively easy, right?

...  Right?

Sorta no, but mostly nope.

Because though the GNU flavored `dict` database is indeed built, NixOS's
`dictd` service knows not of it.  And until `dictd` is informed there ain't
much use in having a GNU flavored `dict` database.


______


## Sharing GNU flavored `dict` with NixOS `dictd` service


First hint of there being an easy `services.dictd.DBs` provided by
[MyNixOS -- `services.dictd`](https://mynixos.com/options/services.dictd),
shows there's a list that can be defined for cluing `dictd` service into
finding other dictionary databases.

And the default defined as `with pkgs.dictdDBs; [ wiktionary wordnet ]`
provides some keywords, keywords that trusty `vimgrep` can be used with!

```vim
:vimgrep /wiktionary/ ~/git/hub/NixOS/nixpkgs/**/*.nix
```

- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/dictd-db.nix` **(snip)**
   ```nix
   { /*...*/ }:

   let
     # ...
   in
   rec {
     # ...
     wiktionary = callPackage ./wiktionary { };
     # ...
   }
   ```
- `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/wiktionary/default.nix` **(snip)**
   ```nix
   { /*...*/ }:
   stdenv.mkDerivation rec {
     # ...
   }
   ```

...  Okay, so essentially the default dictionary databases are built by
`mkDerivation`, the same function that the GCIDE package is using.  Could it
be, after all this struggle, as easy as adding a service configuration block?

Worth a shot!

> `/etc/nixos/configuration.nix` **(snip)**

```nix
{ config, pkgs, ... }:

let
  dict-gcide = pkgs.callPackage ./packages/dict-gcide { inherit pkgs; };
  # ...
in
{
  # ...
  services.dictd = {
    enable = true;
    DBs = [ dict-gcide ];
  };
  # ...
}
```

...  And a little rebuild test to test things;

```bash
nixos.rebuild test --flake .;
#> ...
#> cat: /nix/store/<ID>-dict-gcide-0.53/share/dictd/locale: No such file or directory
#> ...
```

> Readers, if so inclined, may now imagine a pungent scent of dashed dreams.

Should've stopped for the day on a high note.  But nighttime nap of defeat it
is again :-|

---

### A new day to explore NixOS's `dictd` packaging

Re-reading the error message from previous day, is always good idea to re-read
error message(s), shows something desires `$out/share/dictd/locale` to be
readable.  And that it is `cat` doing the reading, so one can presently guess
it must be a file and not a directory.

Time, again to whip-out `vimgrep` and go spelunking through some source code!

```vim
:vimgrep /\v<DBs>/ ~/git/hub/NixOS/nixpkgs/**/*.nix
```

...  The above leads to finding a bit of code, `pkgs.dictDBCollector`, that
makes use of the `DBs` value, and better still it's in a `dictd.nix` file;

> `~/git/hub/NixOS/nixpkgs/nixos/modules/services/misc/dictd.nix` **(snip)**

```nix
# ...
  ###### implementation

  config =
    let
      dictdb = pkgs.dictDBCollector {
        dictlist = map (x: {
          name = x.name;
          filename = x;
        }) cfg.DBs;
      };
    in
    lib.mkIf cfg.enable {
# ...
```

Feeling as though this is a hot trail to pursue maybe `pkgs.dictDBCollector`
will have more juicy hints;

```vim
:vimgrep /\v<dictDBCollector>/ ~/git/hub/NixOS/nixpkgs/**/*.nix
```

...  that leads to finding where the `dictDBCollector` attribute is defined;

> `~/git/hub/NixOS/nixpkgs/pkgs/top-level/all-packages.nix` **(snip)**

```nix
# ...
  dictDBCollector = callPackage ../servers/dict/dictd-db-collector.nix { };
# ...
```

Which exposes where the code really be!
`~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/dictd-db-collector.nix`

...  but that's a whole lotta code..  Fortunately it was the `cat` command that
was failing, and that's only one line too, specifically the following line;

```bash
        locale=$(cat "$(dirname "$i")"/locale)
```

Okay, not yet helpful.  But ignoring everything that isn't associated with a
given state be trick that's pretty useful, which ends up reducing the problem
space to something like;

> `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/dictd-db-collector.nix` **(snip)**

```nix
{ /*...*/ }:
(
  {
    dictlist,
    # ...
  }:

  /*
    dictlist is a list of form
    [ { filename = /path/to/files/basename;
    name = "name"; } ]
    # ...
  */

  let
    link_arguments = map (x: ''"${x.filename}" '') dictlist;
    # ...
    installPhase = ''
      # ...
      cd $out/share/dictd
      for j in ${toString link_arguments}; do
        # ...
        if test -d "$j"; then
          # ...
          i=$(ls "$j""/"*.index)
          i="''${i%.index}";
        else
          i="$j";
        fi
        # ...
        locale=$(cat "$(dirname "$i")"/locale)
        # ...
      done
    '';

  in

  stdenv.mkDerivation {
    # ...
  }
)
```

So a space separated list file paths, that gets parsed to the file's directory
(via `dirname`), and it wants a `locale` file.

As a reminder the `dictlist` is built-up within
`~/git/hub/NixOS/nixpkgs/nixos/modules/services/misc/dictd.nix` via;

```nix
# ...
      dictdb = pkgs.dictDBCollector {
        dictlist = map (x: {
          name = x.name;
          filename = x;
        }) cfg.DBs;
      };
# ...
```

...  And the `services.dictd.DBs = [ dict-gcide ]` is the data that's being
mapped, then looped over via `${toString link_arguments}` so if this tangle is
being followed correctly it could instead be written as;

```nix
link_arguments = map (x: ''"${x.outPath}" '') dictlist;
```

Meaning the GNU flavored `dict` needs to stuff something in it's `$out/locale`
path?...  Maybe...

---

### Double-checking assumptions

The default value for `services.dictd.DBs` points to two packages that could be
worthy of investigating, and may expose other assumptions that NixOS need
satisfied too.

> `~/git/hub/NixOS/nixpkgs/pkgs/servers/dict/wiktionary/default.nix` **(snip)**

```nix
{ /*...*/ }:

stdenv.mkDerivation rec {
  # ...
  installPhase = ''
    mkdir -p $out/share/dictd/
    cd $out/share/dictd

    source_date=$(date --utc --date=@$SOURCE_DATE_EPOCH "+%F %T")
    faketime -f "$source_date" ${python3.interpreter} -O ${./wiktionary2dict.py} "${src}"
    faketime -f "$source_date" dictzip wiktionary-en.dict
    echo en_US.UTF-8 > locale
  '';
  # ...
}
```

...  Not only does `echo en_US.UTF-8 > locale` show a value that can be
yoinked, the `mkdir -p $out/share/dictd/` also shows the paths previously taken
from AUR's packaging of `dict-gcide` will need a bit of an adjustment.

---

### Just one more diff that'll fix it good...  right?

> `/etc/nixos/packages/dict-gcide/default.nix` **(diff)**

```diff
   installPhase = ''
-    install -m 0755 -d "$out/usr/share/dictd";
-    install -m 0644 -t "$out/usr/share/dictd/" ./gcide.{dict.dx,index};
+    install -m 0755 -d "$out/share/dictd";
+    install -m 0644 -t "$out/share/dictd/" ./gcide.{dict.dx,index};
+
+    echo "en_US.UTF-8" > "$out/usr/share/dictd/local"
+
     install -m 0755 -d "$out/share/doc/dict-gcide";
     install -m 0644 -t "$out/share/doc/dict-gcide/" "${gcide.out}"/{README,INFO,pronunc.txt};
   '';
 }
```

Above the `/usr` sub-directory is getting stripped, and writing a `locale` file
is added.  Fingers, and tows, crossed for the luck.

And I runs a re-build;

```bash
nixos-rebuild test --flake .;
#> Warning: Git tree '/etc/nixos' is dirty
#> ...
#> Done. Then new configuration is /nix/store/<ID>-nixos-system-nixos-<version>.<date-time>
```

Remember the words of my ancestors, and don't get too hopeful, but could it be
acktually working?  So with crossed-eyes, and rumbling tummy, the following
keys are clacked;

```bash
dict hello;
#> 1 definition found
#>
#> From The Collaborative International Dictionary of English v0.53 [dict-gcide]:
#> ...
```

> Readers, if so inclined, may now imagine a victory dance done as though you
> be watching.


______


## Wrapping-up and cleaning-up


Certain bits bother me about the current state of code, and I wanna clean it
up, but I ain't gonna make ya sit through all that dear reader.  Ya've been a
good sport, throughout this multi-day roller coaster ride of development
challenges, so if eager about testing thangs in their final form head on over
to;

[`https://github.com/nix-utilities/dict-gcide`](https://github.com/nix-utilities/dict-gcide)

I'll also be opening-up a Pull/Merge request for the `NixOS/nixpkgs` folks to
gander at, and maybe consider allowing me to contribute.

From start-to-finish, minus the next few words and sub-sections, this whole
adventure took about twenty eight hours and nearly as many minutes.
Documenting a journey like this ain't easy; so if ya found it some combo of
enjoyable, or educational, then maybe say nice things me somewhere ;-)


______


## Tips to take with you


Finally here be some hard-won tips/tricks I picked-up while making mistakes!


### Changing `buildInputs` means `nix-shell` will require repairing

```bash
nix-shell --repair default.nix;
```

---

### Report a package's first `outPath` from CLI

```bash
nix-instantiate --eval-only --expr '(import <nixpkgs> {}).dict.outPath';
```

> Replace the `dict` with whatever `pname` ya wanna search

---

### Interactive build via `nix-shell`

Inspect environment variables via;

```bash
nix-shell default.nix;

echo "pname -> $pname";
echo "version -> $version";
echo "out -> $out";
```

Inspect various environment functions provided;

```bash
type configurePhase;
```

Run all build phases within shell with;

```bash
genericBuild;
```

---

### Order of phases

0. `unpackPhase` only necessary to define if `src` is unrecognized type
0. `patchPhase`
0. `configurePhase` can be skipped via `dontConfigure = true;`
0. `buildPhase` sometimes needs `enableParallelBuilding = false;`, or can be
   skipped via `dontBuild = true;`
0. `checkPhase` requires `doCheck = true;`
0. `installPhase`

There are probably more phases, but the above are what seems useful for maybe
getting GCIDE packaged properly.

