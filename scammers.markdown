---
layout: modules/collection-home/collection-home
collection_name: scammers
list_title: Logs dumped from baiting scammers that make the mistake of reaching-out
title: "Scammer Logs"
date: 2024-11-13 13:58:05 -0700
categories: entertainment
---

## Contents


- [Tips to protect yourselves][heading__tips_to_protect_yourselves]
  - [For employees and job seekers][heading__for_employees_and_job_seekers]
  - [For employers hiring managers and recruiters][heading__for_employers_hiring_managers_and_recruiters]
    - [Option one -- Download a repo and serach for author email][heading__option_one_download_a_repo_and_serach_for_author_email]
    - [Option two -- Use the GitHub API and a bit of Bash scripting][heading__option_two_use_the_github_api_and_a_bit_of_bash_scripting]
- [{{ page.list_title }}](#{{ page.list_title | slugify: "ascii" }})

______


## Tips to protect yourselves
[heading__tips_to_protect_yourselves]: #tips-to-protect-yourselves


### For employees and job seekers
[heading__for_employees_and_job_seekers]: #for-employees-and-job-seekers


Configure your email address via the Git command line!  Yes this means you'll
occasionally receive spam and scam messages, but you'll also protect your
reputation as well as offer an avenue for organizations to protect themselves
from employment scams too.

Here are a few options in order of increasing difficulty/friction level

0. Set your email for the currently logged in user
   ```bash
   git config set --global user.email <EMAIL_USER>@<EMAIL_HOST>.<TLD>
   git config set --global user.name <GITHUB_USER_NAME>
   ```

0. Or use scoped configurations

**`~/.gitconfig` snippet**

```gitconfig
[includeIf "gitdir:~/git/hub/"]
	path = ~/git/hub/.gitconfig
```

**`~/git/hub/.gitconfig` snippet**

```gitconfig
[user]
	email = <EMAIL_USER>@<EMAIL_HOST>.<TLD>
	name = <GITHUB_USER_NAME>
```

---


### For employers hiring managers and recruiters
[heading__for_employers_hiring_managers_and_recruiters]: #for-employers-hiring-managers-and-recruiters


When an applicant provides you with a link to their GitHub, or GitLab, account
it is often possible to get the email address they use for committing changes.
So it is wise to reach-out to them at that email address for confirmation that
who applied is the same person!

The Git CLI tool has all you need to obtain information about an applicant once
you've got their username, and following sub-sections aim to provide few
options; including one requiring no downloads at all!

---

#### Option one: Download a repo and serach for author email
[heading__option_one_download_a_repo_and_serach_for_author_email]: #option-one-download-a-repo-and-serach-for-author-email

0. Find a repositories the applicant has published
  - GitHub URL syntax: `https://github.com/<GITHUB_USER_NAME>?tab=repositories&q=&type=source&language=&sort=`
  - [GitHub example](https://github.com/S0AndS0?tab=repositories&q=&type=source&language=&sort=)
   > Explanation of search query string parameters;
   >
   > - `tab=repositories` automatically selects repository for the given username
   > - `type=source` filters listed repositories to only include those published by the given username
0. Clone (AKA download) a repository
  - GitHub URL syntax: `https://github.com/<GITHUB_USER_NAME>/<REPO_NAME>.git`
  - GitHub example: [`https://github.com/S0AndS0/S0AndS0.github.io.git`](https://github.com/S0AndS0/S0AndS0.github.io.git)
  - Git CLI command: `git clone https://github.com/S0AndS0/S0AndS0.github.io.git`
0. Change your current working directory to that of the repository root, then list committed changes by the given username
  - Example Bash shell commands
   ```bash
   cd S0AndS0.github.io
   git log --author=S0AndS0 --format="%aE" -n1
   ```
  - Example output
   ```
   strangerthanbland@gmail.com
   ```

---

#### Option two: Use the GitHub API and a bit of Bash scripting
[heading__option_two_use_the_github_api_and_a_bit_of_bash_scripting]: #option-two-use-the-github-api-and-a-bit-of-bash-scripting

Without downloading anything you can opt for searching through the JSON output of GitHub's API;

- GitHub API URL syntax: `https://api.github.com/users/<GITHUB_USER_NAME>/events/public`
- GitHub API URL example: [`https://api.github.com/users/S0AndS0/events/public`](https://api.github.com/users/S0AndS0/events/public)

...  Or if you've got lots of applicants to search through, here's a simple Bash script that uses `curl` to download and API response and parse results via `jq`;

```bash
#!/usr/bin/env bash

##
# Author: S0AndS0 <https://api.github.com/users/S0AndS0>
# License: AGPL-v3.0
# Descriptor: Get email address(es) for a GitHub user name
##

set -eET

NAME="${NAME:-${1:-S0AndS0}}"
_api_url="https://api.github.com/users/${NAME:?Undefined user}/events/public"

curl "${_api_url:?Undefined URL}" |
  jq --raw-output --arg NAME "${NAME}" '[
    .[]
      | select(.type == "PushEvent")
      | select(.actor.login == $NAME)
      | .payload.commits[]
        | select(.author.name == $NAME)
        | { "name": $NAME, "email": .author.email }
  ] | unique'
```

> `github-email-addresses-of S0AndS0`


______


