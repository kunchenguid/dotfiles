# Metrics by Business Model

## Table of Contents

- [How to Use This File](#how-to-use-this-file)
- [E-commerce](#e-commerce)
- [SaaS](#saas)
- [Free Mobile App](#free-mobile-app)
- [Media Site](#media-site)
- [User-Generated Content](#user-generated-content)
- [Two-Sided Marketplace](#two-sided-marketplace)
- [Hybrid Models](#hybrid-models)

## How to Use This File

Name your primary business model, install that model's metric tree, write a definition doc for each metric before building dashboards, and watch the failure modes — most analytics disasters are measurement errors, not data errors. The metrics below are the canonical set; your OMTM at any moment is one of them (chosen by stage), and the rest are supporting or counter-metrics.

## E-commerce

**Core question:** do visitors buy, and do buyers come back?

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| Conversion rate | orders ÷ unique visitors | The fundamental efficiency of the store |
| Average order value (AOV) | revenue ÷ orders | Second lever on revenue besides traffic |
| Annual repurchase rate | % of buyers purchasing again within 12 months | Decides your mode (below) |
| Cart abandonment | 1 − (orders ÷ carts created) | Where intent dies; checkout friction signal |
| Revenue per customer (RPC) | revenue ÷ customers in period | Conversion × AOV × repurchase in one number |
| Customer acquisition cost (CAC) | acquisition spend ÷ new customers | Must sit far below RPC over the customer's life |

**The mode decision.** The annual repurchase rate determines what kind of e-commerce business you are, and the playbooks differ sharply. Under roughly 40% of buyers repurchasing in a year, you're in **acquisition mode**: the game is top-of-funnel efficiency, conversion, and AOV — loyalty programs are wasted spend. Above roughly 60%, you're in **loyalty mode**: the game is repeat behavior, recommendations, reorder flows, and share of wallet. Between the two, run a **hybrid**: grow acquisition while nudging the repurchase rate up. Misdiagnosing the mode is the most expensive e-commerce metric mistake — building loyalty infrastructure for a one-and-done product (mattresses) or burning ad spend where retention should compound (consumables).

**Instrumentation notes:** instrument the full funnel as distinct events (product view → add-to-cart → checkout start → payment → confirmation) so abandonment localizes to a step; tie every order to an acquisition source at the *customer* level, not the session level; deduplicate customers across devices and guest checkouts (email is the usual join key); record refunds and returns as first-class events.

**Measurement failure modes:** celebrating traffic while conversion slides; reporting one blended conversion rate across channels with wildly different intent (brand search converts 10x display); ignoring returns, refunds, and shipping costs so "revenue" overstates reality; comparing holiday weeks to ordinary ones instead of year-over-year; and counting sessions as shoppers, which double-counts the same person comparison-shopping on two devices.

## SaaS

**Core question:** do trials become long-lived, expanding subscriptions?

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| MRR / ARR | sum of active subscription value per month/year | The growth headline, normalized |
| Customer churn | customers lost ÷ customers at period start | The leak that caps growth |
| Revenue churn (gross/net) | MRR lost (gross); MRR lost − expansion (net) | Net churn below 0% means the base grows itself |
| LTV | ARPA × gross margin ÷ churn rate | What a customer is worth, honestly margined |
| CAC | sales + marketing spend ÷ new customers | What a customer costs, fully loaded |
| LTV:CAC | LTV ÷ CAC | >3 is the standard health line |
| CAC payback | CAC ÷ (ARPA × gross margin) | Months to recover acquisition; <12 is the heuristic |
| Trial-to-paid conversion | paying ÷ trials in cohort | Funnel efficiency; watch by channel |
| Time-to-value | median time from signup to first core value | The strongest onboarding lever on conversion |
| Expansion/upsell | MRR added from existing accounts | Cheapest growth; drives net churn negative |

**Instrumentation notes:** revenue numbers must come from the billing system, not the analytics tool — analytics events drop, double-fire, and miss dunning; model the subscription as a state machine (trial → active → past_due → paused → churned, plus upgrade/downgrade transitions) and emit an event per transition; define "active use" by core action so you can see *engagement churn* — accounts that stopped using but haven't stopped paying — which is next quarter's revenue churn, visible today.

**Measurement failure modes:** conflating MRR with cash collected (annual prepays inflate cash now and create a renewal cliff later — track both, label both); reporting gross churn as if it were net, or hiding gross churn behind healthy expansion; computing LTV without gross margin (an LTV of revenue, not profit); survivor-biased LTV from your oldest, happiest cohort; counting paused or downgraded accounts inconsistently across reports; and blending churn across plan tiers when enterprise and self-serve behave like different species.

## Free Mobile App

**Core question:** do downloads become engaged users, and does a small slice pay enough to carry everyone?

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| Launch/activation rate | users reaching first value ÷ installs | Installs are shelf-ware until first value |
| D1 / D7 / D30 retention | % of install cohort active N days later | The shape of the leak |
| DAU/MAU | daily actives ÷ monthly actives | Habit strength; how many days a month users need you |
| % paying | payers ÷ active users | The size of the monetized slice |
| ARPDAU | daily revenue ÷ DAU | Revenue intensity, comparable across days |
| ARPPU | revenue ÷ paying users | Depth of monetization among payers |
| k-factor | invites per user × invite conversion | Organic distribution multiplier |
| Churn | users inactive >N days ÷ actives | Defines the ceiling on MAU growth |

**Instrumentation notes:** define "active" as performing the core action, not opening the app (push-notification-driven opens flatter DAU without value); fix your retention convention — calendar-day vs rolling 24-hour windows produce different numbers, and mixing them invalidates trends; expect platform/store reporting lag and reconcile attribution SDK installs against store-reported installs; track the revenue distribution, not just the mean — monetization usually concentrates in a small cohort of high spenders, so medians and deciles tell the truth that ARPPU hides.

**Measurement failure modes:** treating downloads as the growth metric (it's the top of a funnel that loses ~80%+ by week one); averaging revenue across all users when a tiny whale cohort dominates it; forgetting the platform's ~30% cut so "revenue" overstates net by nearly a third; comparing retention across cohorts acquired from incentivized installs vs organic (they're different populations); and celebrating DAU spikes caused by notification blasts that simultaneously spike opt-outs — the engagement equivalent of a payday loan.

## Media Site

**Core question:** can you grow attention and monetize it without destroying the reason it exists?

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| Audience growth | unique visitors, trended + return-visitor rate | Reach, qualified by loyalty |
| Engaged time | actively-measured time on content | Honest attention; raw time-on-page lies |
| CTR | ad clicks ÷ ad impressions | What advertisers ultimately buy |
| RPM | revenue ÷ 1,000 pageviews (or sessions) | Monetization efficiency of attention |
| Ad inventory | impressions available per period | The supply you sell |
| Content-to-ad balance | ad density per page/session | The tradeoff dial between revenue and trust |

**Instrumentation notes:** measure engaged time with activity signals (scroll, focus, pointer movement), not last-page timestamps — a tab open in the background is not attention; attribute traffic by source and content type so you can see which content earns loyal readers vs drive-by social spikes; track the *return* rate of new visitors per content category — it tells you what to commission next.

**Measurement failure modes:** pageview inflation via pagination and slideshows — it manufactures ad inventory while destroying engaged time and reader trust, a vanity trade that monetizes the brand to death; counting bounce-heavy viral traffic as "audience" when it never returns; chasing CTR with clickbait that raises short-term clicks and long-term unsubscribes; and reporting RPM gains that came entirely from ad density increases (the counter-metric — return-visitor rate — catches this).

## User-Generated Content

**Core question:** do visitors climb the engagement funnel and create content that brings others back?

The defining tool is the **engagement funnel** — a ladder of deepening participation: **visitor → voyeur** (consumes content) **→ commenter/voter** (lightweight interaction) **→ creator** (posts original content) **→ sharer** (distributes it outward). Participation is radically unequal — in the spirit of the 90-9-1 rule, lurkers vastly outnumber contributors, who vastly outnumber creators — so the metrics that matter are the **tier sizes and the transition rates between tiers**, not the total account count.

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| Tier transition rates | users moving up a tier ÷ tier population | The health of the participation ladder |
| Content per active user | items created ÷ active users | Density of the content economy |
| Time between contributions | median gap per creator | Creator habit strength |
| Notification effectiveness | re-engagement CTR ÷ opt-out rate | Your main lever, and its cost |
| Spam/fraud rate | bad content ÷ total content | The tax on everything else |

**Instrumentation notes:** define each tier by concrete actions and make tiers mutually exclusive per period so funnel math adds up; instrument content *quality* signals (votes, reports, removals) alongside volume; measure notification effects as a pair — every re-engagement campaign gets its opt-out cost attached.

**Measurement failure modes:** counting registered accounts when creators are what the system runs on; celebrating engagement minutes that are pure passive scroll while creation flatlines (the voyeur tier grows, the ladder is broken); excluding spam from no reports so content volume looks healthy while the real feed rots; and over-notifying — DAU rises for a month, then the opt-out wave caps your re-engagement channel permanently.

## Two-Sided Marketplace

**Core question:** liquidity — do listings meet buyers fast enough that both sides come back?

| Metric | Formula | Why it matters |
|--------|---------|----------------|
| Fill rate / sell-through | listings transacting within window ÷ listings | The supply side of liquidity |
| Search-to-fill | searches ending in a transaction ÷ searches | The demand side of liquidity |
| Time-to-transaction | median time from listing (or search) to deal | Liquidity's speed dimension |
| Buyer/seller ratio | active buyers ÷ active sellers | Which side is the constraint |
| Take rate | platform revenue ÷ GMV | How much of the flow you capture |
| GMV | total transaction value | Context only — vanity until × take rate |
| Repeat rate per side | % of each side transacting again in period | Whether liquidity converts to habit |
| Fraud/dispute rate | disputed transactions ÷ transactions | Trust, the marketplace's real product |

**Instrumentation notes:** define the transaction window per category — 30 days is meaningless if cars take 60 and concert tickets take 2; instrument both sides' funnels separately (seller: list → inquiry → transact; buyer: search → view → contact → transact) because the constraint side changes over time; measure liquidity *per market* (city, category), never as a global blend — a marketplace is a portfolio of local liquidity pools.

**Measurement failure modes:** GMV as the headline while take-rate revenue stays trivial; subsidized transactions (coupons, free credits) counted as organic liquidity; concentration blindness — one power seller or one corporate buyer making aggregate liquidity look healthy while the long tail gets nothing; growing the easy side (usually supply) while the constraint is demand, so listings balloon and fill rate collapses; and blended liquidity across markets hiding the fact that you have one working city and five dead ones.

## Hybrid Models

Most real businesses mix archetypes: a subscription box is e-commerce acquisition with SaaS retention economics; a marketplace may sell SaaS tools to its sellers; a media site may run a UGC community. The rule: **pick ONE primary model — the one whose failure kills the company — and let it own the OMTM.** The secondary model contributes supporting metrics and counter-metrics, not a second north star.

Deciding the primary: ask where the riskiest economics live. A subscription box dies from churn, not from cart abandonment → primary model SaaS, with AOV and cart metrics as supporting. A marketplace with seller tools dies if liquidity fails, no matter how good tool attach rates look → primary model marketplace until liquidity is proven, then revisit. If you'd describe yourself to an investor as "X with a bit of Y," X is the primary.

Two failure patterns to avoid: **dual-OMTM paralysis**, where two teams optimize two north stars and trade wins back and forth invisibly (the counter-metric structure exists precisely so the secondary model constrains rather than competes); and **model drift**, where the company quietly becomes the other model — the day your marketplace's SaaS-tool revenue exceeds take-rate revenue and retains better, re-run the model choice deliberately instead of letting the dashboard decide by inertia.
