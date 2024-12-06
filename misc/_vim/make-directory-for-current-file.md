---
vim: filetype=markdown.liquid
title: Make directory for current file
description: "TLDR: `:command! Mkdir call mkdir(expand('%:h'), 'p')`"
layout: post
date: 2024-12-06 08:17:38 -0800
time_to_live: 1800
author: S0AndS0
tags: [ bash, vim ]
image: assets/images/vim/make-directory-for-current-file/first-code-block.png

# social_comment:
#   links:
#     - text: Blue Sky
#       href: 
#       title: Link to BS thread for this post
# 
#     - text: LinkedIn
#       href: 
#       title: Link to LinkedIn thread for this post
# 
#     - text: Mastodon
#       href: 
#       title: Link to Mastodon Toots for this post
# 
#     - text: Twitter
#       href: 
#       title: Link to Tweet thread for this post
---



If ya like one-liners and lambdas, then the following _should_ satisfy most
use-cases;

```vim
command! -nargs=? -complete=dir Mkdir call foreach(
      \   len([<f-args>]) ? [<f-args>] : [expand('%:h')],
      \   { _index, directory_path -> mkdir(directory_path, 'p') }
      \ )
```

...  We can now call `Mkdir /tmp/some/where` to create a directory path to
`/tmp/some/where`, or `Mkdir` without any arguments to create a directory path
leading to the current buffer's path.

> Bit of explanation:
>
> - `len([<f-args>]) ? [<f-args>] : [expand('%:h')]` ↔ Assigns the array for
>   the `foreach` function call, either pass `<f-args>` or default to value of
>   `expand(%:h)`
> - `{ _, p -> mkdir(p, 'p') }` ↔ Callback lambda for the `foreach` function
>   call
>
> We must use an list-function for the `call` target because calling
> `len(<args>)` directly results in an error being thrown, and a `try`/`catch`
> would lengthen the one-liner considerably.  Plus the `-args=?` command
> modifier ensures only one or none arguments are allowed, so performance
> concerns aren't really a thing for this use-case.


If instead code readability is important, then the following _should_ be more
satisfying;

```vim
function! s:Mkdir(...) abort
	if len(a:000)
		let l:path = a:000[0]
	else
		let l:path = expand('%:h')
	endif

	if !len(l:path)
		throw 'No directory path to make'
	endif

	return mkdir(l:path, 'p')
endfunction

command! -nargs=? -complete=dir MakeDirectory call <SID>Mkdir(<f-args>)
```

...  The behavior of `MakeDirectory` command will be nearly identical to that
of `Mkdir`, only exception be calling with an explicitly empty path
(`MakeDirectory ''`) results in an error being thrown at Vim's execution layer
instead of OS's.


______


## Attributions and documentation
[heading__attributions_and_documentation]: #attributions-and-documentation


Useful Vim help topics;

- `help :command-nargs`
- `help :command-completion`
- `help list-functions`
- `help foreach()`
- `help expand()`
- `help a:000`
- `help mkdir()`

