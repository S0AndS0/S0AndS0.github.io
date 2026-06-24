---
vim: spell nowrap textwidth=79
title: DRM Widevine on Raspberry Pi
description: Partially functional setup for chromium and gecko based browsers with investigation notes on where things are broken
date: 2026-06-24 10:12 -0000
date_updated: 2026-06-25 20:14 -0000
categories: nix
tags: [ nix, nixos, raspbery-pi, linux, drm ]
layout: post
time_to_live: 1800
image: assets/images/nix/drm-widevine-on-raspberry-pi/first-code-block.png

attribution:
  links:
    - text: 'GitHub -- `NixOS/nixpkgs` -- widevine-cdm: add aarch64 support'
      href: https://github.com/NixOS/nixpkgs/pull/343393#issuecomment-2656565823
      title: 'widevine-cdm: add aarch64 support'

    - text: YouTube -- DistroTube -- How To Enable DRM Restricted Content In LibreWolf
      href: https://www.youtube.com/watch?v=bJsdnBxDKI8
      title: How To Enable DRM Restricted Content In LibreWolf

    - text: "Codeberg -- `librewolf` -- DRM still doesn't work"
      href: https://codeberg.org/librewolf/issues/issues/2714
      title: "DRM still doesn't work"

    - text: Reddit -- `r/NixOS` -- How to configure brave browser to install extensions
      href: https://www.reddit.com/r/NixOS/comments/1bqilmi/how_to_configure_brave_browser_package_to_install/
      title: How to configure brave browser to install extensions

    - text: "GitHub -- `nix-community/home-manager` -- `1768d4e:modules/programs/chromium.nix`"
      href: https://github.com/nix-community/home-manager/blob/1768d4e/modules/programs/chromium.nix
      title: "`nix-community/home-manager` -- `1768d4e:modules/programs/chromium.nix`"

    - text: Wiki -- NixOS -- Chromium
      href: https://wiki.nixos.org/wiki/Chromium
      title: NixOS -- Chromium

    - text: GitHub -- `brave/brave-browser` -- Wiki -- Support widevine on Brave linux
      href: https://github.com/brave/brave-browser/wiki/Support-widevine-on-Brave-linux
      title: Wiki -- Support widevine on Brave linux

    - text: Brave App Support -- How to I enable Widevine DRM on Linux?
      href: https://support.brave.app/hc/en-us/articles/23881756488717-How-do-I-enable-Widevine-DRM-on-Linux
      title: Brave -- How to I enable Widevine DRM on Linux?

    - text: Codeberg -- `mogwai/widevine` -- New widevine version
      href: https://codeberg.org/mogwai/widevine/issues/4
      title: New widevine version

    - text: Stack Exchange -- Unix & Linux -- How to get the path of installed package in the nix store?
      href: https://unix.stackexchange.com/questions/790954/how-to-get-the-path-of-installed-package-in-the-nix-store
      title: How to get the path of installed package in the nix store?

    - text: GitHub Gist -- `ruario` -- A script that fetches a ChromeOS image
      href: https://gist.github.com/ruario/19a28d98d29d34ec9b184c42e5f8bf29
      title: A script that fetches a ChromeOS image

    - text: PINE64 -- PineTab2 FAQ -- Can PineTab2 play back DRM content such as Netflix?
      href: https://wiki.pine64.org/wiki/PineTab2_FAQ#Can_PineTab2_play_back_DRM_content_such_as_Netflix%3F
      title: Can PineTab2 play back DRM content such as Netflix?

social_comment:
  links:
    - text: Blue Sky
      href: https://bsky.app/profile/s0-and-s0.bsky.social/post/3mp2ylfivdk2j
      title: Link to thread for this post

    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_linux-nixos-raspberrypi-share-7475680616420872192-hfoj/
      title: Link to LinkedIn thread for this post

    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/116807509286320005
      title: Link to Toot thread for this post

    - text: Twitter
      href: https://x.com/S0_And_S0/status/2069914895345205288
      title: Link to Tweet thread for this post
---



## TLDR


The following configuration snippet mostly works, either via Home Manager or
system wide, for applying explicit modifications to various web-browsers;

```nix
{
  widevine-cdm,
  ...
}:

rec {
  chromium.drm = {
    brave.package.overrideAttrs.postInstall = ''
      mkdir -p $out/opt/brave.com/brave/WidevineCdm/_platform_specific/linux_arm64

      ln -s "${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so" \
        $out/opt/brave.com/brave/WidevineCdm/_platform_specific/linux_arm64/

      ln -s "${widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json" \
        $out/opt/brave.com/brave/WidevineCdm/
    '';
  };

  gecko.drm = {
    default.package.overrideAttrs.buildCommand = ''
      mkdir -p $out/gmp-widevinecdm/system-installed

      ln -s "${widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so" \
        $out/gmp-widevinecdm/system-installed/libwidevinecdm.so

      ln -s "${widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json" \
        $out/gmp-widevinecdm/system-installed/manifest.json

      wrapProgram "$oldExe" --set MOZ_GMP_PATH "$out/gmp-widevinecdm/system-installed"
    '';

    firefox.profiles.settings = {
      "media.eme.enabled" = true;
      "media.eme.encrypted-media-encryption-scheme.enabled" = true;
      "media.gmp-widevinecdm.autoupdate" = false;
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-widevinecdm.version" = "system-installed";
      "media.gmp-widevinecdm.visible" = true;
    };

    librewolf.profiles.settings = gecko.drm.firefox.profiles.default.settings // {
      "browser.profiles.enabled" = true;
      "extensions.autoDisableScopes" = 0;
      "media.gmp-gmpopenh264.enabled" = true;
      "media.gmp-provider.enabled" = true;
      "webgl.disabled" = false;
    };
  };
}
```

### Assumptions

- Above file is: `/etc/nixos/home-manager/rpi5/package-modifications/web-browsers/default.nix`
- Home Manager users live at: `/etc/nixos/home-manager/rpi5/users/<NAME>.nix`

### What works and what no works

#### Streaming services that works

- Apple TV
- Hulu

#### Streaming services that no works

- Netflix, works with Brave/Chromium with `"Mozilla/5.0 (X11; CrOS x86_64
  14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0
  Safari/537.36"` user-agent string

   JavaScript console for all browsers so far tested says;

   ```
   Cannot play media. No decoders for requested formats: audio/mp4; codecs="mp4a.40.42"
   ```

   Firefox CLI reports;

   ```
   GetShaderInfoLog() ->
   0:2(12): error: extension `GL_EXT_shader_texture_lod' unsupported in fragment shader

   GetShaderSource() ->

   #extension GL_EXT_shader_texture_lod: require
   void main() {}

   [GFX1-]: Couldn't sanitize GL_RENDERER "V3D 7.1.7.0"
   ```

   Brave from CLI reports;

   ```
   [23114:23114:0621/105734.425308:ERROR:ui/gl/angle_platform_impl.cc:47] Display.cpp:1097 (initialize): ANGLE Display::initialize error 12289: OpenGL ES 2.0 is not supportable.
   ERR: Display.cpp:1097 (initialize): ANGLE Display::initialize error 12289: OpenGL ES 2.0 is not supportable.
   [23114:23114:0621/105734.427353:ERROR:ui/gl/egl_util.cc:92] EGL Driver message (Critical) eglInitialize: OpenGL ES 2.0 is not supportable.
   [23114:23114:0621/105734.427572:ERROR:ui/gl/gl_display.cc:638] eglInitialize OpenGL failed with error EGL_NOT_INITIALIZED, trying next display type
   [23114:23114:0621/105734.493198:ERROR:media/gpu/vaapi/vaapi_wrapper.cc:1658] vaInitialize failed: unknown libva error
   ```

### Usage example -- Home Manager

```nix
{
  pkgs,
  ...
}:
let
  package-modifications_web-browsers = import ../../package-modifications/web-browsers/default.nix {
    inherit (pkgs) widevine-cdm;
  };
in
{
  programs.chromium = {
    enable = true;

    package = pkgs.brave.overrideAttrs (old: {
      postInstall =
        (pkgs.lib.attrByPath [ "postInstall" ] "" old)
        + package-modifications_web-browsers.chromium.drm.brave.package.overrideAttrs.postInstall;
    });

    commandLineArgs = [
      "--user-agent='Mozilla/5.0 (X11; CrOS x86_64 14541.0.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36'"
    ];
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.overrideAttrs (old: {
      buildCommand =
        old.buildCommand
        + package-modifications_web-browsers.gecko.drm.default.package.overrideAttrs.buildCommand;
    });

    profiles.default = {
      id = 0;
      settings = package-modifications_web-browsers.gecko.drm.firefox.profiles.settings;
    };
  };

  programs.librewolf = {
    enable = true;

    package = pkgs.librewolf.overrideAttrs (old: {
      buildCommand =
        old.buildCommand
        + package-modifications_web-browsers.gecko.drm.default.package.overrideAttrs.buildCommand;
    });

    profiles.default = {
      id = 0;
      settings = package-modifications_web-browsers.gecko.drm.librewolf.profiles.settings;
    };
  };
}
```

______


## Investigating why Netflix no works

**2026-06-25 update** Brave/Chromium seems to work by modifying user-agent
string, as shown above, and following sub-sections can be ignored.

### Query Nix store requisites

Brave running on x86 via NixOS seems to work with Netflix, so I compared
requisites between it and aaarch64;

```bash
nix-store --query --requisites "$(which brave)" |
  sed -E '{ s@(/nix/store/)([[:alnum:]]*)(-.*)@\1<NUR>\3@g; }' |
  sort > /tmp/brave-requisites_x86.txt;

ssh pi@pi5 '{
  nix-store --query --requisites "$(which brave)" |
    sed -E "{ s@(/nix/store/)([[:alnum:]]*)(-.*)@\1<NUR>\3@g; }" |
    sort;
}' > /tmp/brave-requisites_aarch64.txt;

git diff /tmp/brave-requisites_{aarch64,x86}.txt |
  grep -E '^(-|\+)' |
  tail -n +3 > /tmp/brave-requisites_diff_aarch-vs-x86.txt;
```

... But, nothing popped out as easy to blame there.

Side note, following command is how to get to documentation about above
`nix-store` options used;

```bash
man --pager='less --pattern="--requisites / -R"' nix-store-query;
```

### Nix derivation show

Interrogations of computed Nix derivations also didn't result in joy;

```bash
nix derivation show -r 'nixpkgs#brave' > /tmp/nix_derivation_show_brave_x86.json

ssh pi@pi5 "nix derivation show -r 'nixpkgs#brave'" > /tmp/nix_derivation_show_brave_aarch64.json
```

... note, for whatever reason, parsing out URLs required a little fiddling too;

```bash
nix derivation show -r "nixpkgs#brave" |
  jq -r ".derivations[] | select(.outputs.out.hash and .env.urls) | .env.urls" |
  uniq |
  sort > /tmp/nix_derivation_show_brave_urls_x86.txt

ssh pi@pi5 'nix derivation show -r "nixpkgs#brave"' |
    jq -r ".[] | select(.outputs.out.hash and .env.urls) | .env.urls" |
    uniq |
    sort > /tmp/nix_derivation_show_brave_urls_aarch64.txt
```

### Nix store outputs

Considering the codecs related error from JavaScript console;

```
Cannot play media. No decoders for requested formats: audio/mp4; codecs="mp4a.40.42"
```

... I figured it'd be wise to double-check what codecs Widevine advertises
supporting on both working and non working systems via;

```bash
jq '."x-cdm-codecs"' "$(
  NIXPKGS_ALLOW_UNFREE=1 nix-instantiate --eval-only --raw --expr '(import <nixpkgs> {}).widevine-cdm.outPath'
)/share/google/chrome/WidevineCdm/manifest.json";

jq -r '."x-cdm-codecs"' <<<"$(
  ssh home-pi5-eth <<'EOF'
    cat "$(NIXPKGS_ALLOW_UNFREE=1 nix-instantiate --eval-only --raw --expr '(import <nixpkgs> {}).widevine-cdm.outPath')/share/google/chrome/WidevineCdm/manifest.json";
EOF
)";
```

... But, again no joy, as both of above commands resulted in;
`vp8,vp09,avc1,av01`

`vp8,vp9.0,avc1,av01` is what are defined in
[AUR `PKGBUILD`](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=widevine-aarch64),
and [Raspberry Pi archives](https://archive.raspberrypi.org/debian/pool/main/w/widevine/),
which may be worth additional investigation.  However, because RPi archive's
version `"4.10.2662.3"` in `manifest.json` being identical, for now, to what
Nix store outputs for `aarch64` it doesn't seem worth while at this time to
pursue.

### Declared `pkgs`

Widevine seems to be defined in `NixOS/nixpkgs` via the following three files;

- `pkgs/by-name/wi/widevine-cdm/package.nix`
- `pkgs/by-name/wi/widevine-cdm/aarch64-linux.nix`
- `pkgs/by-name/wi/widevine-cdm/x86_64-linux.nix`

The `package.nix` is the entry point for external callers, and routes to either
`aarch64-linux.nix` or `x86_64-linux.nix` files based on current
`${stdenv.hostPlatform.system}`, and none of that seems out of sorts.

