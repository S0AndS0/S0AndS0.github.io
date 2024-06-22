---
title: Into the Deep-End
description: Compare more complex CI/CD configurations defined for Travis CI vs GitHub Actions
layout: post
date: 2019-10-13 13:30:05 -0700
time_to_live: 1800
tags: [ github, javascript ]
categories: github actions docker
image: assets/images/gha/into-the-deep-end/first-code-block.png

# social_comment:
#   links:
#     - text: Twitter
#       href: https://x.com/i/web/status/<ID>
#       title: Link to Tweet thread for this post

attribution:
  links:
    - text: GitHub -- `actions/checkout`
      href: https://github.com/actions/checkout
      title: actions/checkout

    - text: GitHub -- `actions/download`
      href: https://github.com/actions/download
      title: actions/download

    - text: GitHub -- `actions/upload-artifact`
      href: https://github.com/actions/upload-artifact
      title: actions/upload-artifact

    - text: GitHub -- `peter-evans/create-pull-request`
      href: https://github.com/peter-evans/create-pull-request
      title: peter-evans/create-pull-request

    - text: StackOverflow -- GitHub Actions share workspace artifacts between jobs
      href: https://stackoverflow.com/questions/57498605/
      title: GitHub Actions share workspace artifacts between jobs
---



The premise is a branch (`docs-srv`) contains source files used to build
documentation served from another branch (`gh-pages`), and shuttling compiled
files to a different branch mitigates force push temptations.


------


#### Table of Contents


- [&#x1F373; Workflow Examples][heading__workflow_examples]
  - [`.github/workflows/build_css.yml`][heading__action__build_css]
  - [`.github/workflows/open_pull_request.yml`][heading__action__pull_request]
- [&#x1F50D; Dissecting Workflows][heading__dissecting_workflows]
  - [Example `.travis.yml`][heading__example__travis_ci]
- [&#x1F5D2; Notes][heading__notes]


------


## Workflow Examples
[heading__workflow_examples]: #configuration-examples "&#x1F373; "


> To keep the scope narrow only steps involved with compiling CSS from Sass
> files are shown. The following two Workflows will be covered in more detail,
> and serve as a _simple_ example of one way to chain multiple Actions and
> Workflow Steps.


### `.github/workflows/build_css.yml`
[heading__action__build_css]: #githubworkflowsbuild_cssyml


```YAML
on:
  push:
    branches:
      - docs-src

jobs:
  build_css:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
        with:
            ref: docs-src
            fetch-depth: 10
            submodules: true

      - run: mkdir -vp /workspace_sass/compiled_css

      - name: Compile CSS from SCSS files
        uses: scss-utilities/gha-sass@v0.0.2
        with:
          sass_source: _scss/main.scss
          sass_destination: /workspace_sass/compiled_css/main.css

      - name: Upload Complied CSS
        uses: actions/upload-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: /workspace_sass/compiled_css
```


### `.github/workflows/open_pull_request.yml`
[heading__action__pull_request]: #githubworkflowsopen_pull_requestyml


```YAML
on:
  push:
    branches:
      - docs-src

jobs:
  open_pull_request:
    needs: [build_css]
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
        with:
            ref: gh-pages
            fetch-depth: 1
            submodules: true

      - name: Download Compiled CSS
        uses: actions/download-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: assets/css

      - name: Open Pull Request
        uses: peter-evans/create-pull-request@v1.5.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          COMMIT_MESSAGE: Compiles CSS from SCSS files
          PULL_REQUEST_BODY: >
            This pull request was auto-generated thanks to [create-pull-request](https://github.com/peter-evans/create-pull-request)

            And builds CSS with Dart Sass via [scss-utilities/gha-sass](https://github.com/scss-utilities/gha-sass)
```


> For sake of above examples suppose the following `main.scss`


**`_scss/main.scss`**


```CSS
.example-class {
  height: auto;
  width: auto;
}
```


___


## Dissecting Workflows
[heading__dissecting_workflows]: #dissecting-workflows "&#x1F50D;"


Starting from the top, both `build_css.yml` and `open_pull_request.yml`
Workflows are triggered when the `docs-src` branch is pushed to...


```YAML
on:
  push:
    - docs-src
```


------



Both Jobs (`build_css` and `open_pull_request`) run on the latest Ubuntu base
image, and `open_pull_request` requires that `build_css` finishes first...


**Snip -- `.github/workflows/build_css.yml`**


```YAML
jobs:
  build_css:
    runs-on: ubuntu-latest
```


**Snip -- `.github/workflows/open_pull_request.yml`**


```YAML
jobs:
  open_pull_request:
    needs: [build_css]
    runs-on: ubuntu-latest
```


> Note; `needs` may list multiple jobs that should be processed before
> `open_pull_request` starts running steps. For example suppose that one wants
> to build HTML from templates, and transpile TypeScript to JavaScript from
> other Workflows...
>
>
> **Snip -- `.github/workflows/open_pull_request.yml`**


```YAML
jobs:
  open_pull_request:
    needs: [build_css, build_html, transpile_ts]
    runs-on: ubuntu-latest
```


------


The steps of `build_css` are;


`0` Checkout the source branch (`docs-src`) for documentation...


```YAML
    steps:
      - uses: actions/checkout@v1
        with:
            ref: docs-src
```


`1` Make a directory for compiled CSS output files outside of the Git repository...


```YAML
      - run: mkdir -vp /workspace_sass/compiled_css
```


`2` Compile SASS or SCSS (`sass_source`) file(s) into a CSS file (`sass_destination`)...


```YAML
      - name: Compile CSS from SCSS files
        uses: scss-utilities/gha-sass@v0.0.2
        with:
          sass_source: _scss/main.scss
          sass_destination: /workspace_sass/compiled_css/main.css

```


`3` Upload results such that other Workflow Steps may access output via `name` `Compiled-CSS`


```YAML
      - name: Upload Complied CSS
        uses: actions/upload-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: /workspace_sass/compiled_css
```


------


The steps of `open_pull_request` are;


`0` Checkout the branch that built documentation files are served from


```YAML
    steps:
      - uses: actions/checkout@v1
        with:
            ref: gh-pages
            fetch-depth: 1
            submodules: true
```


`1` Download files built by other Workflow Steps


```YAML
      - name: Download Compiled CSS
        uses: actions/download-artifact@v1.0.0
        with:
          name: Compiled-CSS
          path: assets/css
```


`2` Open a Pull Request to the branch that documentation files are served from


```YAML
      - name: Open Pull Request
        uses: peter-evans/create-pull-request@v1.5.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          COMMIT_MESSAGE: Compiles CSS from SCSS files
          PULL_REQUEST_BODY: >
            This pull request was auto-generated thanks to [create-pull-request](https://github.com/peter-evans/create-pull-request)

            And builds CSS with Dart Sass via [scss-utilities/gha-sass](https://github.com/scss-utilities/gha-sass)
```


------


### `.travis.yml`
[heading__example__travis_ci]: #travisyml "Provided for some context and not required to make use of Actions"


> Provided for some context **and** not required to make use of Actions, the
> following is how one could achieve _similar_ results with Travis CI...


```YAML
language: bash

branches:
  only:
    - docs-src
  except:
    - gh-pages

git:
  depth: 10
  quite: true
  submodules: true

matrix:
  fast_finish: true
  include:
    - name: 'Linux Xenial'
      os: linux
      dist: xenial


before_install:
  - sudo apt-get install npm

install:
  - sudo npm install -g sass

before_script:
  - mkdir -vp ~/workspace_sass/compiled_css

script:
  - sass _scss/main.scss ~/workspace_sass/compiled_css/main.css

after_failure:
  - printf 'Where did we go wrong?\n'

after_success:
  - printf 'No errors with build process.\n'

after_script:
  - printf 'Build Phase Finished!\n'


before_deploy:
  - git config --local user.name "Travis CI"
  - git config --local user.email "travis@travis-ci.org"

  - git pull origin gh-pages
  - git checkout gh-pages
  - git submodule update --init --recursive --merge

  - mkdir -vp assets/css
  - mv ~/workspace_sass/compiled_css/main.css assets/css/main.css
  - rm -rf ~/workspace_sass
  - git add assets/css/main.css
  - git commit -m 'Thanks be to Travis CI for building latest style sheets!'


deploy:
  provider: pages
  skip_cleanup: true
  # Set in the settings page of your repository, as a secure variable
  github_token: $GITHUB_TOKEN
  keep_history: true
  target-branch: gh-pages
  on:
    branch: docs-src
```


___


## Notes
[heading__notes]: #notes "&#x1F5D2; Additional notes that may be worth consideration"


I'll leave it up to readers to decide which is more appropriate for a given
project; in other-words I'm not looking for a _holy war_, both services are
solving similar but identical use-cases. Additionally Actions are in Beta where
as Travis CI is a mature service, and the former is only triggered on the same
platform where as the latter is independent of source hosting choices.

