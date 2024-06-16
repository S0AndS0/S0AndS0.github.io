---
vim: spell nowrap textwidth=79
title: Docker Compose NGINX Reverse Proxy cache Jekyll GitHub Metadata
description: >-
  Guide for caching GitHub API responses via NGINX reverse proxy for use with
  Jekyll GitHub Metadata plugin

date: 2024-04-21 07:09:42 -0700
layout: post
categories:
  - docker
  - docker-compose
  - nginx
  - proxy
  - reverse-proxy
  - cache
  - jekyll
  - jekyll-plugin
  - github
  - metadata
  - github-metadata

time_to_live: 1800
attribution:
  links:
    - text: Developer Github -- Authenticating to REST API
      href: 'https://developer.github.com/v3/auth/'
      title: Authenticating to REST API

    - text: Docker Docs -- Networks top-level elements
      href: 'https://docs.docker.com/compose/compose-file/06-networks/'
      title: Networks top-level elements

    - text: Docker Docs -- Networks top-level elements -- IPAM
      href: 'https://docs.docker.com/compose/compose-file/06-networks/#ipam'
      title: Networks top-level elements -- IPAM

    - text:  Docker Docs -- docker network connect
      href: 'https://docs.docker.com/reference/cli/docker/network/connect/'
      title: docker network connect

    - text: GitHub -- Jekyll Docker -- Caching
      href: 'https://github.com/envygeeks/jekyll-docker/blob/master/README.md#caching'
      title: Jekyll Docker -- Caching

    - text: Docker Hub -- NGINX -> "Running nginx as non-root user"
      href: 'https://hub.docker.com/_/nginx'
      title: NGINX -> "Running nginx as non-root user"

    - text: Kaspars Dambis -- Using Nginx as Reverse Proxy to Mirror GitHub API
      href: 'https://kaspars.net/blog/use-nginx-reverse-proxy-mirror-github-api'
      title: Using Nginx as Reverse Proxy to Mirror GitHub API

    - text: Stack Overflow -- Using `--add-host` or `extra_hosts` with `docker-compose`
      href: 'https://stackoverflow.com/questions/29076194/using-add-host-or-extra-hosts-with-docker-compose'
      title: Using `--add-host` or `extra_hosts` with `docker-compose`

    - text: Stack Overflow -- Communication between multiple docker-compose projects
      href: 'https://stackoverflow.com/questions/38088279/communication-between-multiple-docker-compose-projects'
      title: Communication between multiple docker-compose projects

    - text: Stack Overflow -- How to change configuration of existing docker network
      href: 'https://stackoverflow.com/questions/64596780/how-to-change-configuration-of-existing-docker-network'
      title: How to change configuration of existing docker network

    - text: Stack Overflow -- Using regex capture groups from both the locaiton and rewrite?
      href: 'https://stackoverflow.com/questions/74952154/using-regex-capture-groups-from-both-the-location-and-rewrite'
      title: Using regex capture groups from both the locaiton and rewrite?

announcements:
  - text: Mastodon
    href: https://mastodon.social/@S0AndS0/112328868052118173

  - text: LinkedIn
    href: https://www.linkedin.com/posts/s0ands0_docker-compose-nginx-reverse-proxy-cache-activity-7189048381065838592-lwsm?utm_source=share&utm_medium=member_desktop

  - text: Twitter
    href: https://x.com/S0_And_S0/status/1783282472534389014
---


The end-goal is to access GitHub API, and download Gems, in a respectful
fashion by caching responses for a reasonable amount of time.  All while also
minimizing developer friction by reducing the resulting command required a
simple `docker-compose up` to serve a test site locally!


______


## Overview
[heading__overview]: #overview


When Jekyll GitHub Metadata plugin makes requests of GitHub API, we redirect to
NGINX reverse proxy.  The NGINX reverse proxy then either serves a cached
response, or makes the request to GitHub's API caches successful response(s)
then replies to Jekyll with the data.

When Jekyll (via `bundle`) attempts to install Ruby Gems, we have it check the
mounted cached docker volume first.  If dependencies are not cached, or out of
date, then it'll download and cache those packages too.

To help prevent cached artifacts, and authentication details, from being
tracked and pushed by Git we also must update the `.gitignore` file.  Though
readers may wish to implement extra protections via a `pre-commit` hook to add
additional restrictions for tracking `.env` files.


- [Overview][heading__overview]
- [Git configurations][heading__git_configurations]
  - [`.gitignore`][heading__gitignore]
- [Jekyll configurations][heading__jekyll_configurations]
  - [`Gemfile`][heading__gemfile]
  - [`_config.yml`][heading___configyml]
- [NGINX configurations][heading__nginx_configurations]
  - [`docker-compose/nginx/templates/reverse-proxy-cache_api.github.com.conf.template`][heading__dockercomposenginxtemplatesreverseproxycache_apigithubcomconftemplate]
- [Docker Compose configurations][heading__docker_compose_configurations]
  - [`.env/nginx.env`][heading__envnginxenv]
  - [`docker-compose.yaml`][heading__dockercomposeyaml]
- [Notes and tips][heading__notes_and_tips]


______


## Git configurations
[heading__git_configurations]: #git-configurations


### `.gitignore`
[heading__gitignore]: #gitignore


```gitignore
.bundle

## Vim
*.swp
*.swo

## Development
.env

## Docker
docker-volumes

### Jekyll
_site
.sass-cache/
.jekyll-metadata
```


<details>
<summary>Notes for -- `.gitignore`</summary>
{% capture details_summary_content %}
- Tip; check the manual for `githooks`, specifically the `pre-commit` event,
  for hints on how to reject tracking `.env` files, eg.
  `man --pager='less --pattern="^\s+pre-commit"' githooks`
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


______


## Jekyll configurations
[heading__jekyll_configurations]: #jekyll-configurations


### `Gemfile`
[heading__gemfile]: #gemfile

```ruby
source "https://rubygems.org"

gem "jekyll", "~> 3.9.5"

gem "minima", "~> 2.5.1"

gem "jekyll-github-metadata"

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.6"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.0", :install_if => Gem.win_platform?

##
# Required to make Docker happy
group :docker_compose do
  gem "webrick"
  gem "kramdown-parser-gfm"
end

group :custom_plugins do
  gem 'nokogiri'
end
```

<details>
<summary>Notes for -- `Gemfile`</summary>
{% capture details_summary_content %}
- `gem "jekyll", "~> 3.9.5"` is set explicitly to avoid SASS build errors
  introduced by Jekyll version 4 and, as to last update to this post, is the
  exact version used by [GitHub Pages](https://pages.github.com/versions/) so
  setting _should_ help avoid "it works on CI/CD" sorts of issues
- `gem "jekyll-github-metadata"` check the official
  [repository](https://github.com/jekyll/github-metadata) for additional
  details and configuration considerations
- Other than last few entries, as noted, all others are defaults taken from
  newly initialized Jekyll project
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


---


### `_config.yml`
[heading___configyml]: #_configyml

```yaml
title: S0AndS0
description: >- # this means to ignore newlines until "baseurl:"
  Miscellaneous tips, tricks, and thoughts from the author known as S0AndS0

baseurl: "/" # the subpath of your site, e.g. /blog
url: 'https://s0ands0.github.io'

##
# Make docker happy with metadata plugin
repository: S0AndS0/S0AndS0.github.io

# Build settings
markdown: kramdown
theme: minima
plugins:
  - jekyll-feed
  - jekyll-github-metadata

# Exclude from processing.
# The following items will not be processed, by default. Create a custom list
# to override the default setting.
exclude:
  - .env
  - Gemfile
  - Gemfile.lock
  - docker-compose
  - docker-compose.yaml
  - docker-volumes
  - node_modules
  - vendor/bundle/
  - vendor/cache/
  - vendor/gems/
  - vendor/ruby/
```

<details>
<summary>Notes for -- `_config.yml`</summary>
{% capture details_summary_content %}
- `repository` must be defined to make Jekyll GitHub Metadata plugin happy,
  check
  [GitHub -- Jekyll -- Issue `4705`](https://github.com/jekyll/jekyll/issues/4705)
  for further details.
- `exclude` should list `docker-compose` and `docker-volumes` related
  directory/file(-s) so as to avoid re-building when those locations have file
  changes.
- `markdown: kramdown` is co-dependent with [`Gemfile`][heading__gemfile]'s
  `gem "kramdown-parser-gfm"` configuration, so if utilizing a different
  MarkDown transpiler things may need additional adjustments.
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


______


## NGINX configurations
[heading__nginx_configurations]: #nginx-configurations


### `docker-compose/nginx/templates/reverse-proxy-cache_api.github.com.conf.template`
[heading__dockercomposenginxtemplatesreverseproxycache_apigithubcomconftemplate]: #dockercomposenginxtemplatesreverseproxycache_apigithubcomconftemplate

```nginx
# vim: filetype=nginx

# Use cache path we have permissions for writing to within Docker
proxy_cache_path /tmp/nginx-cache/api.github.com levels=1:2 keys_zone=api.github.com:10m;

server {
	server_name api.github.com;
	listen ${NGINX_LISTEN_PORT};

	## Un-comment to possibly enable persistent logs
	# access_log /var/log/nginx/api.github.com-access.log;
	# error_log /var/log/nginx/api.github.com-error.log;

	##
	# Fix errors involving
	#
	#     *1 upstream sent too big header while reading response header from upstream
	proxy_busy_buffers_size 512k;
	proxy_buffers 4 512k;
	proxy_buffer_size 256k;

	location / {
		resolver 8.8.8.8;
		proxy_pass https://api.github.com;
		proxy_cache github;
		proxy_cache_valid 200 302 1d;
		proxy_ignore_headers Expires Cache-Control Set-Cookie X-Accel-Redirect X-Accel-Expires;
		proxy_cache_use_stale error timeout invalid_header updating http_500 http_502 http_503 http_504;

		proxy_set_header User-Agent ${GITHUB_USER_NAME};
		proxy_set_header Authorization "Token ${GITHUB_AUTH_TOKEN}";
	}
}
```

<details>
<summary>Notes for -- `reverse-proxy-cache_api.github.com.conf.template`</summary>
{% capture details_summary_content %}
- All paths above are from the perspective of running within a Docker container
- `proxy_cache_path` and `proxy_cache_valid` have long lifetimes, `1d` (one
  day), which may need reduced if lots of updates are consistently being pushed
  to GitHub
- `listen` and `proxy_set_header` environment variable values are expanded via
  the `services.nginx.image` internal Docker image script at
  `/docker-entrypoint.d/20-envsubst-on-templates.sh`,
  injected via `services.nginx.env_file` definition within the
  [`docker-compose.yaml`][heading__dockercomposeyaml] file, and values of
  environment variables are set within the following
  [`.env/nginx.env`][heading__envnginxenv] file.
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


______


## Docker Compose configurations
[heading__docker_compose_configurations]: #docker-compose-configurations


### `.env/nginx.env`
[heading__envnginxenv]: #envnginxenv


```sh
# shellcheck disable=all
NGINX_LISTEN_PORT=80
GITHUB_USER_NAME=Your-User-Name
GITHUB_AUTH_TOKEN='sOm3sEc4eTe'
```

<details>
<summary>Notes for -- `.env/nginx.env`</summary>
{% capture details_summary_content %}
⚠ Replace values for `GITHUB_USER_NAME`, and `GITHUB_AUTH_TOKEN`, before
proceeding!

Tip, the value for `GITHUB_AUTH_TOKEN` may be obtained via;
[`https://github.com/settings/tokens/new`](https://github.com/settings/tokens/new)
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


---


### `docker-compose.yaml`
[heading__dockercomposeyaml]: #dockercomposeyaml

```yaml
version: '2'

##
services:
  ##
  jekyll:
    image: jekyll/jekyll:latest
    container_name: service-jekyll
    command: jekyll serve --watch --force_polling --verbose --trace --incremental

    depends_on:
      - nginx

    volumes:
      - .:/srv/jekyll
      - ./docker-volumes/jekyll/bundle:/usr/local/bundle

    environment:
      ## Downgrade to non-SSL if using `networks.net-services.ipam`
      - PAGES_API_URL=http://api.github.com
      ## Or swap above with below if NGINX be playing with only one config
      # - PAGES_API_URL=http://host-nginx

    ## Point URL(s) at internally static IP address(es)
    extra_hosts:
      - api.github.com:172.21.0.2

    hostname: host-jekyll
    networks:
      - net-jekyll
      - net-services

    ports:
      - 4000:4000

  ##
  nginx:
    image: nginx:stable-alpine
    container_name: service-nginx
    ## Comment following to reduce output
    command: [nginx-debug, '-g', 'daemon off;']

    volumes:
      - ./docker-compose/nginx/templates:/etc/nginx/templates:ro
      ## Mostly to allow NGINX write access to paths protected by permissions
      - ./docker-volumes/nginx/cache:/tmp/nginx-cache
      - ./docker-volumes/nginx/run:/var/run
      - ./docker-volumes/nginx/logs:/var/logs/nginx

    env_file:
      - path: ./.env/nginx.env
        required: true

    hostname: host-nginx
    networks:
      - net-nginx
      - net-services

##
networks:
  net-jekyll:
    name: net-jekyll
    driver: bridge

  net-nginx:
    name: net-nginx
    driver: bridge

  ## Network over which services may chatter to each other over
  net-services:
    name: net-services
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16
          ip_range: 172.21.0.0/24
          gateway: 172.21.0.1
          aux_addresses:
            host-nginx: 172.21.0.2
            host-jekyll: 172.21.0.3
```

<details>
<summary>Notes for -- `docker-compose.yaml`</summary>
{% capture details_summary_content %}
- Most paths above are from the perspective of the host's repository root, and
  `volumes` map to paths within a given Docker container.
- `networks.net-services.ipam`, and `services.jekyll.extra_hosts`, may need
  adjusted on systems where the defined IP addresses are already claimed by
  another set of Docker containers.
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>

______


## Notes and tips
[heading__notes_and_tips]: #notes-and-tips


- Reload `nginx` service within Docker

   ```bash
   docker compose nginx nginx -t &&
     docker compose nginx nginx -s reload
   ```

- Restart `jekyll` container/service

   ```bash
   docker compose restart jekyll
   ```

- Recreate network(s) after changing `docker-compose.yaml` file

   ```bash
   docker rm network net-services
   ```

- Occasionally the following error(s) will pop, no idea why, and may be a bug
  in the plugin not respecting the `PAGES_API_URL` environment variable's
  defined protocol and/or value

   ```
   service-jekyll  |    GitHub Metadata: Failed to open TCP connection to api.github.com:443 (Connection refused - connect(2) for "api.github.com" port 443)
   ```

- The above, so far, has taken a little over sixteen hours to research,
  develop, and document for you dear reader(s)...  So if it has helped ya, then
  feel free to show your [appreciation](https://liberapay.com/S0AndS0) in a way
  that'll encourage similar publications.

- Moving site source code to a sub-directory may offer a cleaner developer
  experience, and better define responsibilities for each Docker image, however
  [Stack Overflow](https://stackoverflow.com/questions/36782467/set-subdirectory-as-website-root-on-github-pages)
  shows a history of much flux!  GitHub Actions modifications is the latest
  _solution_, and Git Worktree setup may be a more mature solution, but for now
  that all be outside the scope of this guide.

