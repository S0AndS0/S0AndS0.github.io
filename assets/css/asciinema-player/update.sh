#!/usr/bin/env bash

set -EeT;

## Find true directory script resides in, true name, and true path
__SOURCE__="${BASH_SOURCE[0]}";
while [[ -h "${__SOURCE__}" ]]; do
  __SOURCE__="$(find "${__SOURCE__}" -type l -ls | sed -n 's@^.* -> \(.*\)@\1@p')";
done
__DIR__="$(cd -P "$(dirname "${__SOURCE__}")" && pwd)";
__NAME__="${__SOURCE__##*/}";
__AUTHOR__='S0AndS0';
__DESCRIPTION__='Curl wrapper with Tor configuration defaults to download asciinema player';

declare -A _urls=(
  ['LICENSE']='https://raw.githubusercontent.com/asciinema/asciinema-player/refs/heads/develop/LICENSE'
  ['asciinema-player.css']='https://github.com/asciinema/asciinema-player/releases/download/v3.11.0/asciinema-player.css'
);

_socks5='localhost:9050';
_socks5_hostname='localhost:9050';
_user_agent='Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0';

_curl_options=(
  '--socks5' "${_socks5}"
  '--socks5-hostname' "${_socks5_hostname}"
  '--user-agent' "${_user_agent}"
);

pushd "${__DIR__}";

for _file_name in "${!_urls[@]}"; do
  curl "${_curl_options[@]}" --location "${_urls[${_file_name}]}" --output "${_file_name}";
done

popd;
