---
layout: post
title: "Organization of Organizations"
date: 2019-09-13 12:58:05 -0700
categories: posts
---



This year I've begun utilizing Organizations on GitHub in an effort to better organize code, and intent.



Organizations that contain `utilities` within the name, are intended to be utilized within other projects, eg. `bash-utilities` and `liquid-utilities` contains repositories for use within other Bash and Liquid related projects. And Organizations such as `paranoid-linux` and `rpi-curious`, are intended to be utilized for other purposes.


Repository names will be descriptive (as much as possible), will make use of code from other organizations whenever necessary, and will be kept minimal on the default (`master`) branch; for various reasons. Some repositories will also have an `examples` and/or `gh-pages` branch that details and documents further usage.


Currently Git Submodules are utilized as a dependency/package management solution for most projects published this way. Quick start tips will always be within a `ReadMe.md` file at the root of a project, and as always opening Issues and/or Pull Requests via GitHub are welcomed!
