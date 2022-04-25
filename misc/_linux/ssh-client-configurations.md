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

man -P 'less -ip "<TOPIC>"' ssh_config
```


---


- [Defaults for all connections][heading__defaults_for_all_connections]
- [Prefix configuration with trailing glob][heading__prefix_configuration_with_trailing_glob]
- [Suffix configuration with leading glob][heading__suffix_configuration_with_leading_glob]
- [Specificity chaining with globs][heading__specificity_chaining_with_globs]
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
```


Note, the above requires the **client** has `socat`, and `tor`, installed.  And
that the **server** has `tor` and `sshd` configured correctly.

Tip, review the
[Tor Project Onion Service Setup][link__tor_project__onion_service__setup]
guide for details on how to configure the remote server.  Hint, `9050` should
match the `SOCKSPort` defined within `/etc/tor/torrc` the **client**
configuration file.  Default is `9050` for many Linux based devices.

The `%h` and `%p` format strings will automatically be replaced with the
`HostName` and `Port` for a given `Host` configuration block.  Review the
`man -P 'less -ip "^tokens"' ssh_config` manual section for more details on
what other format strings are available to `ProxyCommand` value.


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


## Specificity chaining with globs
[heading__specificity_chaining_with_globs]: #specificity-chaining-with-globs


```sshconfig
## Shared for all that connect to `rpi`
Host *rpi*
  HostName 10.0.0.42
  Port 2222

## Extend `tor*` configurations previously defined
Host tor.rpi*
  HostName AnOnionDomainHere.onion

## Administrator account for `rpi` server
Host *rpi.root*
  User root
  IdentityFile ~/.ssh/rpi-root

## First normal user for `rpi` server
Host *rpi.pi*
  User pi
  IdentityFile ~/.ssh/rpi-pi
```


______


## Example usage
[heading__example_usage]: #example-usage


Login to Raspberry Pi as `pi`, over Tor, and immediately start `screen` session


```bash
ssh tor.rpi.pi-screen
```

The above functions not only because of globing, but also because of the order
of `Host` definitions and overrides.  Expanded out the above command may be
treated as though the following configurations are explicitly defined;


```sshconfig
Host tor.rpi.pi-screen
  # Host *
  IdentitiesOnly yes

  # Host tor-*
  ProxyCommand socat STDIO SOCKS4A:127.0.0.1:%h:%p,socksport=9050

  # Host *rpi*
  #   HostName 10.0.0.42
  Port 2222

  # Host tor.rpi*
  HostName AnOnionDomainHere.onion

  # Host *rpi.pi*
  User pi

  # Host *-screen
  RemoteCommand screen -RD ssh
  RequestTTY yes
```



[link__tor_project__onion_service__setup]: https://community.torproject.org/onion-services/setup/
