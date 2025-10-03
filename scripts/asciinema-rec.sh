#!/usr/bin/env bash
## vim: noexpandtab

##
# Wrapper script for alacritty and asciinema recording
#
# ## Example usage
#
# ```markdown
# ---
# title: Test
# description: Test of asciinema player
#
# scripts:
#   - src: assets/javascript/asciinema-player/asciinema-player.min.js
#
# stylesheets:
#   - href: assets/css/asciinema-player/asciinema-player.css
# ---
#
# <div id="demo"></div>
# <script> AsciinemaPlayer.create('{{- "/assets/asciinema/posts/test.cast" | relative_url -}}', document.getElementById('demo')); </script>
# ```
##

_output_path="${1:?Undefined output path}";

if [[ -f "${_output_path}" ]]; then
	printf >&2 'Output path already exists: %s\n' "${_output_path}";
	exit 1;
fi

_asciinema_exec="$(which asciinema)";
_alacritty_exec="$(which alacritty)";

if ! [[ -x "${_asciinema_exec}" ]]; then
  printf >&2 'Missing executable: asciinema\n';
  exit 1;
elif ! [[ -x "${_alacritty_exec}" ]]; then
  printf >&2 'Missing executable: alacritty\n';
  exit 1;
fi

_alacritty_opts=(
	--option font.size=16
	--option window.startup_mode='"Maximized"'
);

"${_alacritty_exec}" "${_alacritty_opts[@]}" --command "${_asciinema_exec}" rec "${_output_path}";

