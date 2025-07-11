---
vim: spell nowrap textwidth=79

title: Install NixOS
description: Speed-run fresh NixOS install from a noob perspective
categories: [ nixos, linux ]
author: S0AndS0
layout: post

time_to_live: 1800
date_updated: 2025-07-11 15:57:00 -0700
date: 2025-07-06 09:00:00 -0700

image: assets/images/linux/install-nixos/first-code-block.png
social_comment:
  links:
    - text: Blue Sky
      href: https://bsky.app/profile/s0-and-s0.bsky.social/post/3ltgd63wxjk25
      title: Link to Post thread for this post
    - text: LinkedIn
      href: https://www.linkedin.com/posts/s0ands0_linux-nixos-sysadmin-activity-7348186311771484160-nuJk
      title: Link to comment thread for this post
    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/114815411102338325
      title: Link to Toot thread for this post
    - text: Twitter
      href: https://x.com/S0_And_S0/status/1942420616394539254
      title: Link to Tweet thread for this post

attribution:
  links:
    - text: Calamares Docs -- Finish
      href: https://calamares.io/docs/finish/
      title: Calamares Docs -- Finish

    - text: NixOS WiKi -- Flakes
      href: https://nixos.wiki/wiki/flakes
      title: Flakes Wiki

    - text: lewo -- NixOS Manual -- Wireless Networks
      href: https://nlewo.github.io/nixos-manual-sphinx/configuration/wireless.xml.html
      title: NixOS Manual -- Wireless Networks

    - text: "GitHub -- NixOS Issue 11728 -- warning: download buffer is full"
      href: https://github.com/NixOS/nix/issues/11728
      title: "NixOS Issue 11728 -- warning: download buffer is full"

    - text: Nix Comunity -- Home Manager -- NixOS module
      href: https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
      title: Home Manager -- NixOS module

    - text: Install Linux Guides -- USB UEFI Compatible via VirtualBox
      href: https://install-linux-guides.github.io/usb-uefi-compatible/
      title: Install Linux Guides -- USB UEFI Compatible via VirtualBox

    - text: isabel of BlueSky -- "git add moment?"
      href: https://bsky.app/profile/isabelroses.com/post/3ltolteeivs2a
      title: "git add moment?"

    # - text: 
    #   href: 
    #   title: 
---



This post is supplemental to a guide published some years ago that still
be useful for boot-strapping a bootable USB compatible with UEFI boot-loaders,
descriptively named
[Install Linux Guides -- USB UEFI Compatible via VirtualBox](https://install-linux-guides.github.io/usb-uefi-compatible/)
and as such will not cover here the details covered there.

> **TLDR:** setup USB pass-through within preferred vitalization software
> between host and guest, then mount the installer ISO to the guest, and go
> through the GUI installation within the guest that _should_ only see the USB
> as a valid target.
>
> This totally side-steps most of the issues that can be created by MicroSoft®
> Windows™ updates hosing a grub2 or SystemD boot partition, and other **Fun**
> that can be created by dual-boot setups.  Only thing that requires
> modification on the host, after USB install, is modifying the UEFI firmware
> settings to put the USB at the start of boot order.


______


## Host setup

### Download SHA256

```bash
_url_sha256="https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso.sha256";
_file_sha256="${HOME}/Downloads/linux-iso/$(date +%F)_${_url_sha256##*/}";

curl --fail --location "${_url_sha256}" --output "${_file_sha256}";
```

### Download ISO

```bash
_url_iso="https://channels.nixos.org/nixos-25.05/latest-nixos-graphical-x86_64-linux.iso";
_file_iso="${HOME}/Downloads/linux-iso/$(date +%F)_${_url_iso##*/}";

curl -fL "${_url_iso}" -o "${_file_iso}";
```

### Verify download of ISO against SHA256

```bash
sha256sum -c < <(awk -v _name="${_file_iso##*/}" '{
  printf "%s %s", $1, _name;
  exit length($1) ? 0 : 1 ;
}' "${_file_sha256}");
printf 'sha256sum exit status -> %i\n' "$?";
```

An exit status of `0` is generally a good thing, anything else likely be an
error worthy of investigating before moving on to next steps.


______


## Install to USB


Again check the
[Install Linux Guides -- USB UEFI Compatible via VirtualBox](https://install-linux-guides.github.io/usb-uefi-compatible/)
set of pages for details!

______


## Boot via Virt-Manager or VirtualBox


Note booting directly into the fresh NixOS from the host, I.E. without
vitalization is **not** recommended!  First because the vitalized hardware is
likely to be more compatible, and second because debugging and research is
gonna be way easier from a working host hosting the virtual machine ;-)

---

### Track default configuration

```bash
sudo nix-shell -p git vim_configurable ;

pushd /etc/nixos ;

tee -a .gitignore 1>/dev/null <<'EOF'
*.swp
*.swo
EOF

git init . ;

git add .gitignore configuration.nix hardware-configuration.nix ;

git -c user.name root -c user.email 'root@localhost' commit -m ':tada: Initial commit' ;
```

Above will allow for tracking changes and the option to role-back to, or
cherry-pick, previous changes even after garbage collector has run...  Provided
that is one is fastidious about committing changes.

---

### Enable all re-distributable firmware

> Diff `/etc/nixos/configuration.nix` snip

```diff
+  ## Added to maybe sort-out WiFi card not recognized
+  hardware.enableRedistributableFirmware = true;

   ## Enable networking
   networking.networkmanager.enable = true;
```

Above _should_ allow things like Intel builtin WiFi and/or Bluetooth hardware
to actually work with the network manager services.

---

### Install Vim

> Diff `/etc/nixos/configuration.nix` snip

```diff
   environment.systemPackages = with pkgs; [
   #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   #  wget
+    vim_configurable
   ];
```

---

### Enable experimental Nix Flakes

> Diff `/etc/nixos/configuration.nix` snip

```diff
   system.stateVersion = "25.05";

+  nix.settings.experimental-features = [
+    "nix-command" "flakes"
+  ];

 }
```

This _should_ allow for more finite control, and reproduce-ability, over
installed package versions as well as rollbacks. Plus the community mostly be
heading the way of flakes being widely adopted, so probably wise to start off
learning with instead of without.

**Apply changes**

```bash
nixos-rebuild switch
```

---

### Start using Flakes for whole system

```bash
pushd /etc/nixos && {
  sudo nix flake init ;

  sudo vim flake.nix ;
}
```

> Diff `/etc/nixos/flake.nix` snip

```diff
 {
-  description = "A very basic flake";
+  description = "System wide flake";

   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
   }

-  outputs = { self, nixpkgs }: {
-
-    packages.x86_64-linux.hello = nixpkgs.lagecyPackages.x86_64-linux.hello;
-
-    packages.x86_64-linux.default = self.pakcages.x86_64-linux.hello;
-
+  outputs = { self, nixpkgs, ... }@attrs:
+  let
+    hostname = "nixos";
+    system = "x86_64-linux";
+  in
+  {
+    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
+      system = "${system}";
+      specialArgs = attrs;
+      modules = [
+        ./configuration.nix
+      ];
+    };
   };
 }
```

By defining `hostname = "nixos"` within the `let`/`in` block and using it as a
variable `nixosConfigurations."${hostname}"` we're allowed to shorten following
rebuild command, as well as mitigate future self's forgetfulness.

**Apply changes**

```bash
sudo nixos-rebuild switch --flake . 
```

Expect this rebuild to take _some_ time!

---

### Add `home-manager` to flake as NixOS module

> Diff `/etc/nixos/flake.nix` snip

```diff
   inputs = {
     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
+    home-manager.url = "github:nix-community/home-manager";
+    home-manager.inputs.nixpkgs.follows = "nixpkgs";
   }

-  outputs = { self, nixpkgs, ... }@attrs:
+  outputs = { self, home-manager, nixpkgs, ... }@attrs:
   let
     hostname = "nixos";
     system = "x86_64-linux";
@@ ... @@
       specialArgs = attrs;
       modules = [
         ./configuration.nix
+        home-manager.userGlobalPkgs = true;
+        home-manager.userUserPackages = true;
       ];
     };
   };
```

Above will get `home-manager` installed and basic system level configurations
configured, and bellow is how I'm currently separating concerns for a
multi-user device...

```bash
pushd /etc/nixos && {
  sudo mkdir home-manager ;

  sudo tee home-manager.nix <<EOF
{ config, pkgs, ... }:

{
  home-manager.users.${USER} = ./home-manager/${USER}.nix;
}
EOF

  sudo tee home-manager/${USER}.nix <<'EOF'
{ config, pkgs, ... }:

{
  ## This should match `system.stateVersion` defined in `../configuration.nix`
  home.stateVersion = "25.05";
}
EOF

}
```

...  This requires touching the root-level `configuration.nix` file once more,
but it's only one more line;

> Diff `/etc/nixos/configuration.nix` snip

```diff
 { config, pkgs, ... }:

 {
   imports = [
     ## Include the results of the hardware scan.
     ./hardware-configuration.nix
+    ./home-manager.nix
   ];
```

**Apply changes**

```bash
sudo nixos-rebuild switch --flake . 
```

Expect this rebuild to, again, take _some_ time!

Trade-offs being made here are, convenience of one command `nixos-rebuild` to
manage both system packages and user configurations, but at the cost of
requiring `sudo`/`root` level permissions.  Which the inconvenience of
escalated permission requirements I feel is balanced by moving user
configuration related things to a separate directory/file structure.

> I.E. it allows for changing one's mind in the future with minimal friction.


______


## Manage your packages cheat-sheet


### Apply flake system changes

```bash
pushd /etc/nixos && {
  sudo nixos-rebuild switch --flake . ;
  popd ;
}
```

Provided previous steps in this post were followed, above _should_ handle both
system level packages and configuration changes, as well as home-manager stuff.

### Collect garbage

```bash
nix-collect-garbate --delete-older-than 1d
```

Above will delete orphaned things from `/nix/store` older than `1` day which,
provided one has successfully rebooted after a rebuild recently, _should_ be
safe enough.

### Update hardware configuration

```bash
pushd /etc/nixos && {
  sudo nixos-generate-config
}
```

Above should be run after re-booting host into USB installed NixOS environment,
I.E. what is often called "bare-mettle" state, because it is highly unlikely
VirtualBox or Virt-Manager will have emulated the host hardware accurately
during install.


______


## Issues

### fixupPhase crashes Guest when installing to LUKS encrypted partition

**Guest specs**

```yaml
cpus: 4
memory: 31957
```

**Host specs**

```yaml
cpus: 8
memory: 31957
```

Notice how `memory` is the same?! 🤦 ... yeah, turns out giving a guest
permission to use all memory means the host may run out of memory!

Knocking the guest down to a more reasonable ten, or so, gigabytes allowed for
encrypted install to chug along fine...  Though is kinda odd how LUKS encrypted
partition processes be memory hungry.

---

### error: path '/nix/store/<hash>-source/home-manager/root.nix' does not exist

Assuming readers reading this tried modifying the normal user account setup for
`home-manager` to target the `root` account to, eg...

```bash
pushd /etc/nixos && {
  sudo mkdir home-manager;

  sudo tee home-manager/configuration.nix <<EOF
{ config, pkgs, ... }:

{
  home-manager.users.root = ./root.nix;
}
EOF

  sudo tee home-manager/root.nix <<'EOF'
{ config, pkgs, ... }:

{
  ## This should match `system.stateVersion` defined in `../configuration.nix`
  home.stateVersion = "25.05";
}
EOF

}
```

...  and now be popping file does not exist errors.  As of 2025-07-10 it seems
flakes need Git to have new files staged?!

```bash
git add home-manager/root.nix;

nix flake check;
```

Thanks be to [isabel](https://bsky.app/profile/isabelroses.com/post/3ltolteeivs2a)

---

### Where is the install log?

The official documentation for [Calamares](https://calamares.io/docs/finish/)
says, "log is copied to /var/log/installation.log of the target system", but
that seems to not be the case with NixOS.

Even doing a bit of `find` summoning seems to show no joy...

```bash
find /var -type f -iname 'instal*.log' -print
```

...  More research will be needed!

