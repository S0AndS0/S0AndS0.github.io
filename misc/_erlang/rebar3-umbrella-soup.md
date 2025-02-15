---
title: Rebar3 umbrella soup
description: Supervising supervisors in an umbrella Rebar3 managed Erlang project
layout: post
date: 2025-02-15 13:35:37 +0000
time_to_live: 1800
author: S0AndS0
tags: [ erlang, rebar3 ]
image: assets/images/erlang/rebar3-umbrella-soup/first-code-block.png
# social_comment:
#   links:
#     - text: Twitter
#       href: 
#       title: Link to Tweet thread for this post
---



Over the last few weeks I've been learning the ways of Erlang OTP, and a
project I'm working on feels like it'd benefit from a well defined supervisor
tree.  Tragically the mid-level guides, with minimal fluff, couldn't be found
at the time of writing; I.E. something between the level of _hello server_ and
giddy-up cowboy!  So what follows be something that hopefully fills the gap.


## Project initialization with one local app dependency


```bash
_project_name="my_project";
_sub_name="sub_service";

## Initialize project and switch to project root
rebar3 new umbrella "${_project_name}";
pushd "${_project_name}";

## Switch to `apps/` sub-directory and initialize dependency application
pushd apps;
rebar3 new app "${_sub_name}";

## Remove unnecessary files then switch back to project root
rm "${_sub_name}/"{.gitignore,LICENSE.md};
popd;
```

<details><summary>Details about above commands:</summary>
{% capture details_summary_content %}
- `rebar3 new unbrella <name>` will use the `unbrella` template to create a
  directory/file structure similar to
   ```
   my_project/apps/my_project/src/my_project_app.erl
   my_project/apps/my_project/src/my_project_sup.erl
   my_project/apps/my_project/src/my_project.app.src
   my_project/rebar.config
   my_project/config/sys.config
   my_project/config/vm.args
   my_project/.gitignore
   my_project/LICENSE.md
   my_project/README.md
   ```
- `pushd <path>` is like `cd`, but with a longer history such that the `popd`
  command can _undo_ current working directory changes
   ```bash
   pushd "${_project_name}";
   pwd;
   #> /tmp/my_project

   pushd apps;
   pwd;
   #> /tmp/my_project/apps
   ```
- `rebar3 new app <name>` will use the `app` template to create a
  directory/file structure similar to
   ```
   sub_service/src/sub_sup_app.erl
   sub_service/src/sub_sup_sup.erl
   sub_service/src/sub_sup.app.src
   sub_service/rebar.config
   sub_service/.gitignore
   sub_service/LICENSE.md
   sub_service/README.md
   ```
   > Note; everything but the `src/` sub-directory may be removed if no special
   > documentation, licensing, and/or dependencies are required.
- In this example we only remove the extra `.gitignore` and `LICENSE.md` files,
  because it should inherit these from the root level project
   ```bash
   rm "${_sub_name}/"{.gitignore,LICENSE.md};
   popd;
   pwd;
   #> /tmp/my_project
   ```
{% endcapture %}
{{ details_summary_content | markdownify }}
</details>


## Add app dependency supervisor to project supervision tree


Edit the tippity-top-level supervisor for the project to make use of the
`sub_service` supervisor;

```diff
 init([]) ->
     SupFlags = #{
         strategy => one_for_all,
         intensity => 0,
         period => 1
     },
-    ChildSpecs = [],
+    ChildSpecs = [
+      #{
+        id => sub_service_sup,
+        start => {sub_service_sup, start_link, []}
+      }
+    ],
     {ok, {SupFlags, ChildSpecs}}.
```


## Sanity checking


Consider adding the following to your `init/1` functions within the various
supervisors just before each returns `{ok, {SupFlags, ChildSpecs}}`;

```erlang
io:format("~p:init | SupFlags -> ~p | ChildSpecs -> ~p~n", [?MODULE, SupFlags, ChildSpecs]),
```

For example...

**`/tmp/my_project/apps/my_project/src/my_project_sup.erl`**

```diff
 init([]) ->
     SupFlags = #{
         strategy => one_for_all,
         intensity => 0,
         period => 1
     },
     ChildSpecs = [
       #{
         id => sub_service_sup,
         start => {sub_service_sup, start_link, []}
       }
+    io:format("~p:init | SupFlags -> ~p | ChildSpecs -> ~p~n", [?MODULE, SupFlags, ChildSpecs]),
     {ok, {SupFlags, ChildSpecs}}.
```

**`/tmp/my_project/apps/sub_service/src/sub_service_sup.erl`**

```diff
 init([]) ->
     SupFlags = #{
         strategy => one_for_all,
         intensity => 0,
         period => 1
     },
     ChildSpecs = [],
+    io:format("~p:init | SupFlags -> ~p | ChildSpecs -> ~p~n", [?MODULE, SupFlags, ChildSpecs]),
     {ok, {SupFlags, ChildSpecs}}.
```

...  Now when one runs `rebar shell` the following is sorta what can be
expected;

```
[USER@HOST my_project]$ rebar3 shell 
===> Verifying dependencies...
===> Analyzing applications...
===> Compiling my_project
===> Compiling sub_sup
Erlang/OTP 27 [erts-15.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

Eshell V15.2.1 (press Ctrl+G to abort, type help(). for help)
my_project_sup:init | SupFlags -> #{intensity => 0,period => 1,
                                    strategy => one_for_all} | ChildSpecs -> [#{id =>
                                                                                 sub_service,
                                                                                start =>
                                                                                 {sub_service_sup,
                                                                                  start_link,
                                                                                  []}}]
sub_service_sup:init | SupFlags -> #{intensity => 0,period => 1,
                                 strategy => one_for_all} | ChildSpecs -> []
===> Booted my_project
===> Booted sasl
1> 
```

