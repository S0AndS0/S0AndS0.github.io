---
layout: home
title: "Pages by S0AndS0"
permalink: /index:output_ext
---


Miscellaneous tips, tricks, and thoughts from the author known as S0AndS0


## [![Byte size of S0AndS0.github.io][badge__master__s0ands0__source_code]][master__source_code__s0ands0] [![Open Issues][badge__issues__s0ands0]][issues__s0ands0] [![Open Pull Requests][badge__pull_requests__s0ands0]][pull_requests__s0ands0] [![Latest commits][badge__commits__s0ands0__master]][commits__s0ands0__master] [![Feed Atom Demos][badge__demo__s0ands0]][demo__s0ands0]



------


#### Table of Contents


- [&#9889; Quick Start][heading__quick_start]

- [&#x1F5D2; Notes][notes]

- [&#x1F4C7; Attribution][heading__attribution]

- [&#x2696; License][heading__license]


------



## Quick Start
[heading__quick_start]: #quick-start "&#9889; Perhaps as easy as one, 2.0,..."


The following are for those that wish to build documentation privatively or on another server.


**Downloading Source**


1. Make a directory path for GitHub sources and change directory

2. Clone the source and any submodules utilized by this repository

3. Change directory again and checkout a new branch for tracking changes


```Bash
mkdir -vp ~/git/hub/S0AndS0
cd ~/git/hub/S0AndS0

git clone --recurse-submodules git@github.com:S0AndS0/S0AndS0.github.io.git

cd S0AndS0.github.io
git checkout -b fork
```


> Note if building on a server, consider utilizing the [Jekyll Administration][s0ands0__jekyll_admin] project that is maintained for emulating many features of GitHub Pages privatively.


**Forking**


1. Change directory to repository

2. Add remote pointing to where you've forked this repository on GitHub

3. Fetch and set fork as default upstream that is pushed to and pulled from


```Bash
cd ~/git/hub/S0AndS0/S0AndS0.github.io

## Replace <your-name> with your GitHub account name
git remote add fork git@github.com:<your-name>/S0AndS0.github.io

git fetch fork
git branch --set-upstream-to=fork/master
```


**Building**


1. Change directory to repository, and generate a coma separated list of configuration files

2. Update submodules and Jekyll related dependencies

3. Build source into files that many web-browsers understand


```Bash
cd ~/git/hub/S0AndS0/S0AndS0.github.io
_config_files="_config.yml"
while read _p; do
    _f="${_p##*/}"
    [[ "${_f}" == '_config.yml' ]] && continue
    [[ "${_f}" == '_config.yaml' ]] && continue
    _config_files+=",${_f}"
done < <(ls -1 ./_config*.y*ml)

git submodule update --init --recursive --merge
# bundle install --path="${HOME}/.bundle/install"
bundle update

bundle exec jekyll build\
 --config "${_config_files}"\
 --destination "${HOME}/www"
```


___


## Notes
[notes]: #notes "&#x1F5D2; Additional notes and links that may be worth clicking in the future"


For private builds GitHub [Authentication][jekyll__metadata_authentication] setup is required to make full use of Metadata plugins. Those utilizing the `Jekyll_Admin` repository may use the `edit-configs` git shell command setting such configurations.


___


## Attribution
[heading__attribution]: #attribution "&#x1F4C7; Resources that where helpful in building this project so far."


> Note, if something is missing from the following please issue a Pull Request so that corrections may be reviewed.


- [Jekyll][jekyll__home] is what builds this repository into something that web servers may serve statically and many web-browsers are to render

- [GitHub Pages][github__pages] is what publicly hosts this repository, and may others.


___


## License
[heading__license]: #license "&#x2696; Legal bits of Open Source software"


Legal bits of Open Source software


```
Content and code of this file.
Copyright (C) 2019  S0AndS0

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```


___



[badge__commits__s0ands0__master]: https://img.shields.io/github/last-commit/S0AndS0/S0AndS0.github.io/master.svg

[commits__s0ands0__master]: https://github.com/S0AndS0/S0AndS0.github.io/commits/master "&#x1F4DD; History of changes on this branch"


[s0ands0__community]: https://github.com/S0AndS0/S0AndS0.github.io/community "&#x1F331; Dedicated to functioning code"


[badge__demo__s0ands0]: https://img.shields.io/website/https/S0AndS0.github.io.svg?down_color=darkorange&down_message=Offline&label=Demo&logo=Demo%20Site&up_color=success&up_message=Online

[demo__s0ands0]: https://S0AndS0.github.io "&#x1F52C; Check the live build when on-line"


[badge__issues__s0ands0]: https://img.shields.io/github/issues/S0AndS0/S0AndS0.github.io.svg

[issues__s0ands0]: https://github.com/S0AndS0/S0AndS0.github.io/issues "&#x2622; Search for and _bump_ existing issues or open new issues for project maintainer to address."


[badge__pull_requests__s0ands0]: https://img.shields.io/github/issues-pr/S0AndS0/S0AndS0.github.io.svg

[pull_requests__s0ands0]: https://github.com/S0AndS0/S0AndS0.github.io/pulls "&#x1F3D7; Pull Request friendly, though please check the Community guidelines"


[badge__master__s0ands0__source_code]: https://img.shields.io/github/repo-size/S0AndS0/S0AndS0.github.io

[master__source_code__s0ands0]: https://github.com/S0AndS0/S0AndS0.github.io/blob/master/S0AndS0.github.io "&#x2328; Source code that GitHub Pages builds!"


[s0ands0__jekyll_admin]: https://github.com/S0AndS0/Jekyll_Admin "Collection of scripts for administration and private git account interactions"


[jekyll__home]: https://jekyllrb.com "Home page of Jekyll project"

[jekyll__metadata_authentication]: https://github.com/jekyll/github-metadata/blob/master/docs/authentication.md "Tips from the maintainers of Jekyll on how to setup Authentication to GitHub APIs"

[github__pages]: https://pages.github.com "Home page of GitHub Pages"
