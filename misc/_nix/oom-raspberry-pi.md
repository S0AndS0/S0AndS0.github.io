---
vim: spell nowrap textwidth=79
title: OOM Raspberry Pi
description: Managing out of memory conditions with grace on low memory devices
date: 2026-06-15 19:29 -0000
categories: nix
tags: [ nix, nixos, raspbery-pi, linux, memory ]
layout: post
time_to_live: 1800
image: assets/images/nix/oom-raspberry-pi/first-code-block.png

attribution:
  links:
    - text: Cameron McKay -- Stop your Raspberry Pi NixOS builds from crashing
      href: https://cdmckay.org/stop-your-raspberry-pi-nixos-builds-from-crashing/
      title: Stop your Raspberry Pi NixOS builds from crashing

    - text: MyNixOS -- `systemd.slices.<name>.sliceConfig`
      href: https://mynixos.com/nixpkgs/option/systemd.slices.%3Cname%3E.sliceConfig
      title: systemd.slices.<name>.sliceConfig

    - text: GitHub -- `home-assistant/operating-system#4616` -- /proc/pressure/ (PSI) not enabled by default on RPi boards
      href: https://github.com/home-assistant/operating-system/issues/4616
      title: /proc/pressure/ (PSI) not enabled by default on RPi boards

    - text: GitHub -- `raspberrypi/linux#4683` -- PSI support
      href: https://github.com/raspberrypi/linux/issues/4683
      title: PSI support

    - text: GitHub -- `nvmd/nixos-raspberrypi` -- Configure the bootloader and firmware (`config.txt`)
      href: https://github.com/nvmd/nixos-raspberrypi#configure-the-bootloader-and-firmware-configtxt
      title: Configure the bootloader and firmware (`config.txt`)

    - text: GitHub -- `nvmd/nixos-raspberrypi#107` -- how to set `cgroup_memory=enable`
      href: https://github.com/nvmd/nixos-raspberrypi/issues/107
      title: how to set `cgroup_memory=enable`

    - text: GitHub -- `henrygd/beszel#1433` -- Missing memory stats in Systemd Services table on Raspberry Pi
      href: https://github.com/henrygd/beszel/discussions/1433
      title: Missing memory stats in Systemd Services table on Raspberry Pi

#     - text: 
#       href: 
#       title: 
---


## TLDR

The following configurations worked well on Raspberry Pi version 5 for building
Xfce on device and not running out of memory.

```nix
{ ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/lib/swapFile";
      size = 8041;
    }
  ];

  systemd = {
    oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };

    slices = {
      system.sliceConfig.ManagedOOMMemoryPressureLimit = "60%";
      user.sliceConfig.ManagedOOMMemoryPressureLimit = "40%";
    };

    services.sshd.serviceConfig.ManagedOOMMemoryPreference = "avoid";
  };

  boot.kernelParams = [
    "psi=1"
    "cgroup_enable=memory"
  ];
}
```


______


## Story time


Awhile back one of my RPis experienced an unexpected loss of power, which
partially corrupted/tainted the file-system.  Thing still restarted into the
default Raspbian OS, but slowly, and things still ran, but, again _slowly_...

I could have ran a `fsck` via another device, that's worked in the past, maybe
that would have worked this time too.  But I chose to consider it a sign to
install NixOS, because, in the past `fsck` has also prolonged the pain with a
failing file-system.

Plus, worse case, re-flashing Raspbian then manually reinstalling and
re-configuring every application manually didn't spark joy.

So un-pluged, and un-loved, the board sat for a few weeks...  Until, annoyed
enough, I chose to dive into flashing NixOS on to it!  Which resulted in other
opportunities for annoyance, but, a story for another time that will be, maybe.

Eventually I got NixOS mostly running and building fine...  _mostly_...  that
was until I tried to install KDE with Wayland.  Kernel noped that plan with OOM
(Out Of Memory) errors.

Naively I thought, "okay maybe Xfce will build?", and Kernel **noped** that
too!

Few days of off-and-on web-searching, and poking at other GUI options,
eventually resulted in finding Cameron McKay's blog post
[Stop your Raspberry Pi NixOS builds from crashing](https://cdmckay.org/stop-your-raspberry-pi-nixos-builds-from-crashing/),
which was near perfect!  So close to perfect that I was able to get Xfce built
and installed successfully, and was almost ready to move on, until I spotted
`systemd-oomd.service` reporting failure to restart on each system rebuild.

YeahhhhuUgh, to avoid annoyance of re-flashing Raspbian then manually
reinstalling and re-configuring every application manually, I had discovered
new and _joy filled_ ways to annoy myself x-]

Fortunately the first error;

```
ConditionPathExists=/proc/pressure/memory was not met
```

... was something the folks at
[GitHub -- `home-assistant/operating-system`](https://github.com/home-assistant/operating-system/issues/4616)
had already sorted out by adding `psi=1` to the `boot.kernelParams`, ex;

```nix
{
  boot.kernelParams = [
    "psi=1"
  ];
}
```

Another rebuild, and, another error!

```
ConditionControlGroupController=memory was not met
```

... But, progress is progress.  And again was a quick web-search to find the
[GitHub -- `henrygd/beszel`](https://github.com/henrygd/beszel/discussions/1433),
and
[GitHub -- `nvmd/nixos-raspberrypi`](https://github.com/nvmd/nixos-raspberrypi/issues/107)
projects had resolved and relevant issues. Adding `cgroup_enable=memory` to the
`boot.kernelParams` list;


```nix
{
  boot.kernelParams = [
    "psi=1"
    "cgroup_enable=memory"
  ];
}
```

... resulted in satisfying `systemd-oomd.service`, at least enough that it
starts and seems to work as intended.

