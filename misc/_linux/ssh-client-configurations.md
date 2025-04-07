---
vim: spell nowrap textwidth=79
title: SSH Client Configurations
description: Advanced reusable configuration examples for SSH
date: 2022-04-24 13:00:05 -0700
categories: linux
layout: post
time_to_live: 1800
attribution:
  links:
    - text: StackOverflow -- How to make git work to push commits to GitHub via tor?
      href: https://stackoverflow.com/questions/27279359/
      title: How to make git work to push commits to GitHub via tor?

    - text: Ubuntu Manpage -- ssh_config
      href: https://manpages.ubuntu.com/manpages/focal/man5/ssh_config.5.html
      title: OpenSSH client configuration file

    - text: Tor Project -- Set Up Your Onion Service
      href: https://community.torproject.org/onion-services/setup/
      title: Set up your onion service
---


This post covers some, though not all, of the advanced and reusable SSH client
configurations I use during my day-to-day administrating of various servers.

Review of the manual page for `ssh_config` is recommend though it is possible
to skip to, or search for, specific topics via the following examples;


```bash
man -P 'less -ip "^patterns"' ssh_config

man -P 'less -ip "^tokens"' ssh_config

man -P 'less -ip "^\s+include"' ssh_config
```


---


- [Defaults for all connections][heading__defaults_for_all_connections]
- [Prefix configuration with trailing glob][heading__prefix_configuration_with_trailing_glob]
- [Suffix configuration with leading glob][heading__suffix_configuration_with_leading_glob]
- [Organize with `Include` files example][heading__organize_with_include_files_example]
- [Example usage][heading__example_usage]


---


## Defaults for all connections
[heading__defaults_for_all_connections]: #defaults-for-all-connections


```sshconfig
Host *
  IdentitiesOnly yes
  StrictHostKeyChecking accept-new
```


Note, any of above may be selectively overridden on a per-host basis within
following configuration blocks.


______


## Prefix configuration with trailing glob
[heading__prefix_configuration_with_trailing_glob]: #prefix-configuration-with-trailing-glob


```sshconfig
Host tor-*
  ProxyCommand socat STDIO SOCKS4A:127.0.0.1:%h:%p,socksport=9050
  AddressFamily inet
  Compression yes

Host vnc-*
  RemoteCommand if ! systemctl --user is-active vncserver; then systemctl --user start vncserver; fi
  LocalForward 5901 localhost:5901
  LocalCommand vncviewer localhost:5901
```


> Note, the above `Host tor-*` block requires the **client** has `socat`, and
> `tor`, installed.  And that the **server** has `tor` and `sshd` configured
> correctly.
>
> And the `Host vnc-*` block requires the **server** has a functional VNC
> server as well as user level SystemD configurations defined.
>
> Tip, review the
> [Tor Project Onion Service Setup][link__tor_project__onion_service__setup]
> guide for details on how to configure the remote server.  Hint, `9050` should
> match the `SOCKSPort` defined within `/etc/tor/torrc` the **client**
> configuration file.  Default is `9050` for many Linux based devices.
>
> The `%h` and `%p` format strings will automatically be replaced with the
> `HostName` and `Port` for a given `Host` configuration block.  Review the
> `man -P 'less -ip "^tokens"' ssh_config` manual section for more details on
> what other format strings are available to `ProxyCommand` value.


______


## Suffix configuration with leading glob
[heading__suffix_configuration_with_leading_glob]: #suffix-configuration-with-leading-glob


```sshconfig
Host *-screen
  RemoteCommand screen -RD ssh
  RequestTTY yes

Host *-tmux
  RemoteCommand tmux attach-session -t ssh || tmux new -s ssh
  RequestTTY yes
```


Note, these may be append to any `Host` that has a trailing glob; check
[Example usage][heading__example_usage] section of this document for details on
how the above may be utilized.


______


## Organize with `Include` files example
[heading__organize_with_include_files_example]: #organize-with-include-files-example


Personally I find custom SSH `Host` order with increasing specificity, eg.
`<Network>.<Server>.<User>`, is preferable because it lends itself well both to
tab-completion as well as file based organization.

Here are a few examples of organizing SSH client configuration by network;


- `~/.ssh/hosts.d/home.conf`

```sshconfig
## Shared for all that connect to `rpi`
Host *home.rpi*
  HostName 10.0.0.42
  Port 2222

## Administrator account for `rpi` server
Host *home.rpi.root*
  User root
  IdentityFile ~/.ssh/rpi-root

## First normal user for `rpi` server
Host *home.rpi.pi*
  User pi
  IdentityFile ~/.ssh/rpi-pi
```

> Note; the globs/asterisks (`*`) on ether end of `Host` blocks is what allows
> for using [prefixes][heading__prefix_configuration_with_trailing_glob],
> and/or [suffixes][heading__suffix_configuration_with_leading_glob], or both
> within a single connection attempt ;-D


- `~/.ssh/hosts.d/tor.conf`

```sshconfig
Host tor-*
  ProxyCommand socat STDIO SOCKS4A:127.0.0.1:%h:%p,socksport=9050
  AddressFamily inet
  Compression yes

Host tor-home.rpi*
  HostName AnOnionDomainHere.onion
```

> Note; due to how globs are parsed, and order of `Include` files, the
> `HostName` within `~/.ssh/hosts.d/home.conf` for `Host *home.rpi*` will be
> overwritten/updated by `Host tor-home.rpi*` login attempts!


- `~/.ssh/hosts.d/vm.conf`

```sshconfig
Host vm.manjaro*
  IdentityFile ~/.ssh/vm-manjaro
  HostName 192.168.122.127

Host vm.manjaro.root*
  User root

Host vm.manjaro.s0ands0*
  User s0ands0
```


- `~/.ssh/config`

```sshconfig
#
#   Warning: includes must be at top of file
#
Include ~/.ssh/hosts.d/*.conf

#
#   Defaults for all connections
#
Host *
  IdentitiesOnly yes
  StrictHostKeyChecking accept-new

#
#    Modifiers for non-interactive sessions
#
Host *batch*
  BatchMode yes
```

> Note; the `Include` glob/asterisk (`*`) allows for loading all `.conf` files
> within the specified directory, which is convenient **only** if order does
> not mater between given files.  Hence why for organizing first by network ;-D


______


## Example usage
[heading__example_usage]: #example-usage


Login to Raspberry Pi as `pi`, over Tor, and immediately start `screen` session


```bash
ssh tor-home.rpi.pi-screen
```

The above functions because of globing definitions and order of overrides.
Expanded out the above command may be treated as though the following
configurations are explicitly defined;


```sshconfig
Host tor-rpi.pi-screen
  # Host *
  IdentitiesOnly yes
  StrictHostKeyChecking accept-new

  # Host tor-*
  ProxyCommand socat STDIO SOCKS4A:127.0.0.1:%h:%p,socksport=9050
  AddressFamily inet
  Compression yes

  # Host *home.rpi*
  #   HostName 10.0.0.42
  Port 2222

  # Host *home.rpi.pi*
  User pi

  # Host tor-home.rpi*
  HostName AnOnionDomainHere.onion

  # Host *-screen
  RemoteCommand screen -RD ssh
  RequestTTY yes
```



[link__tor_project__onion_service__setup]: https://community.torproject.org/onion-services/setup/
[link__github__tigervnc__systemd]: https://github.com/TigerVNC/tigervnc/issues/1096
