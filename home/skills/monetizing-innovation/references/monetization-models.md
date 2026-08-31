# Choosing the Monetization Model

## Table of Contents

- [The Model Is a Design Decision](#the-model-is-a-design-decision)
- [Choosing the Price Metric](#choosing-the-price-metric)
- [Subscription](#subscription)
- [Usage-Based](#usage-based)
- [Hybrid: Base Plus Usage](#hybrid-base-plus-usage)
- [Freemium](#freemium)
- [Dynamic Pricing](#dynamic-pricing)
- [Outcome-Based Pricing](#outcome-based-pricing)
- [Migrating Between Models](#migrating-between-models)
- [Model Selection Checklist](#model-selection-checklist)

## The Model Is a Design Decision

*How* you charge is a bigger lever than *how much*. The monetization model decides who carries the risk (you or the customer), when cash flows, how revenue scales with customer success, and how the purchase feels. The same product at the same effective price can thrive as a metered API and die as a flat subscription — or vice versa — because the model either matches or fights the customer's consumption pattern and budget reality.

Choose the model with the same evidence used for price levels: ask in WTP interviews not just "what would you pay?" but "how would you want to pay for this?" and "what would make this an easy line item in your budget?" Buyers have strong, articulate opinions about models — often stronger than about levels.

## Choosing the Price Metric

The price metric is the unit you charge for: per seat, per active user, per gigabyte, per transaction, per 1,000 API calls, per order shipped, per hire made. It is chosen before the price level, because it defines what "expensive" even means. Michelin charging fleets per kilometer driven instead of per tire is the classic move: the metric jumped from the product to the value.

Score candidate metrics against five tests:

| Test | Question | Example failure |
|------|----------|----------------|
| **Value tracking** | Does the metric rise when the customer gets more value? | Per-seat pricing for a dashboard only two people log into |
| **Predictability** | Can the customer forecast their bill? | Per-event pricing where events spike unpredictably |
| **Acceptance** | Does the metric feel fair and familiar to the buyer? | Charging per "workflow execution" nobody can define |
| **Measurability** | Can both sides audit it cheaply and unambiguously? | "Per insight delivered" |
| **Incentive alignment** | Does the metric punish behavior you want? | Per-seat pricing taxing the collaboration that drives retention |

Most metric mistakes fail test 1 or 5: revenue decouples from delivered value, or the metric makes customers ration exactly the usage that would make them stick. When two metrics tie, pick the one the customer's budget already speaks (procurement approves "per seat" without a meeting; "per inference-second" needs a committee).

## Subscription

Recurring flat fee per period, usually per seat or per tier.

**When it wins:** Value is delivered continuously (always-on tooling, storage, monitoring); usage is steady; customers value budget predictability; you value forecastable ARR (and investors price it accordingly).

**Failure modes:**

- Value-usage mismatch: heavy users are subsidized by light users, and light users churn ("we barely used it")
- Per-seat taxing collaboration: teams share logins or restrict invites, gutting network effects inside the account
- Renewal-time scrutiny: a year of flat fees with shallow usage invites the CFO's axe

**Design notes:** Pair seats with a leader-fenced tier ladder so growing accounts upgrade rather than just add seats; consider charging only for *active* users (Slack's fair-billing pattern: credit for inactive seats) to remove adoption fear; annual prepay discounts of 15-20% trade margin for retention and cash.

## Usage-Based

Pay-as-you-go against a metered unit (calls, GB, transactions, minutes).

**When it wins:** Value scales directly with consumption (infrastructure, APIs, communications); usage varies widely across customers; buyers distrust commitments; you want a frictionless, no-negotiation landing motion that expands automatically with customer success.

**Failure modes:**

- Bill shock: one spike, one viral month, one runaway script — and the customer's trust is gone
- Revenue volatility: your ARR inherits every customer's seasonality
- Rationing: engineers optimize away your revenue; teams fear experimenting because the meter is always running
- Invisible value: the bill itemizes consumption, not outcomes, so renewals litigate line items

**Design notes:** Always ship spend alerts, caps, and budgets — protecting the customer from surprise *is* the retention feature; publish volume discounts (declining unit price) so growth feels rewarded, not punished; offer committed-use contracts (12-month commit at a discount) to swap volatility for predictability on both sides.

## Hybrid: Base Plus Usage

A recurring platform fee (which may include a usage allowance) plus metered overage or expansion.

**When it wins:** Most B2B SaaS with variable consumption. The base covers always-on value and keeps revenue forecastable; the metered component lets revenue track success. It is frequently the adult answer when the team is fighting a subscription-vs-usage religious war.

**Failure modes:** Complexity — two numbers to explain, two numbers to forecast; allowances set too high (overage never triggers, you built a flat plan with extra steps) or too low (every invoice has surprise overage, recreating bill shock).

**Design notes:** Set the included allowance around the median customer's usage so roughly half expand; name the overage unit in the customer's language ("extra active contacts," not "units"); review allowance breakpoints yearly as usage drifts.

## Freemium

A permanently free tier feeding a paid product. Treat it as an *acquisition model*, not a pricing model — the free tier is marketing spend with a conversion target, and it must be engineered like one.

**When it wins:** Marginal cost per free user is near zero; the product spreads through usage (collaboration, sharing, network effects); the market is broad and self-serve; paid conversion has a natural trigger (limits, team features, scale).

**Failure modes:**

- The free tier contains the leader feature, so there is no reason to pay — generosity becomes the business model
- Free users impose real costs (support, compute) with a conversion rate that never covers them
- "Free" anchors the category: charging later for what was free triggers revolt
- Vanity-metric management: counting signups while paid conversion stays below 1% with no mechanism to improve it

**Design notes:** Decide the conversion mechanism *before* launch — what exactly will a successful free user hit that makes paying obvious? Cap free at the habit point (just below where engaged users naturally land), keep virality-driving features free (gating the sharing loop starves acquisition to protect conversion — usually a bad trade), and instrument the free-to-paid funnel like a checkout. Healthy self-serve freemium converts roughly 2-5%; below 1% means the fence is misplaced. A time-boxed free *trial* is the better tool when value is deep but narrow and network effects are absent.

## Dynamic Pricing

Prices that move with demand, supply, time, or buyer context (surge pricing, airline seats, spot instances).

**When it wins:** Perishable capacity (seats, rides, compute hours, ad slots); demand swings are large and measurable; transactions are frequent and anonymous enough that buyers compare against the market, not against each other.

**Failure modes:** Fairness backlash — buyers who discover they paid more than a neighbor for the same thing punish the brand (surge pricing survives only because riders see the multiplier *before* booking); complexity costs (pricing infrastructure, support disputes); legal exposure when price varies by personal characteristics rather than market conditions.

**Design notes:** Vary price by transparent, situational factors (time, demand, capacity), never by who the buyer is; show the price before commitment, always; cap the range — a 10x surge generates headlines that cost more than the surge earned.

## Outcome-Based Pricing

Charging against the result delivered: per hire made, per claim recovered, percentage of savings, per resolved ticket.

**When it wins:** The outcome is discrete, attributable, and measurable by both sides; your product demonstrably drives it; buyers are skeptical and risk-shifting closes deals that ROI decks cannot. It is the strongest possible value story: you pay when it works.

**Failure modes:**

- Attribution war: whose CRM decides whether the deal "came from" the tool?
- You inherit the customer's execution risk — their bad process suppresses your revenue
- Gaming on both sides (outcome definitions bend under revenue pressure)
- Long, lumpy cash cycles tied to outcome timing

**Design notes:** Pick outcomes a neutral log can verify (orders shipped, tickets resolved in-system) over contested ones (revenue influenced); pair a modest platform fee with the outcome fee so the lights stay on; pilot with a handful of design partners to calibrate the rate before publishing it; write the measurement protocol into the contract, including the dispute path.

## Migrating Between Models

Model migrations are open-heart surgery: every existing customer is repriced at once, and the loudest reactions come before the value story lands.

1. **Model the winners and losers first.** Re-bill the last 12 months of every account under the proposed model. Know the distribution: who pays more, who pays less, by how much. If the top decile's bill triples, you have a churn plan to write before an email.
2. **Lead with the value story, not the mechanics.** The announcement explains *why the new model matches value better* and what recipients gain (alignment, headroom, fairness) before any table of rates.
3. **Grandfather generously.** 6-18 months of legacy terms for existing customers (or legacy-forever for a closed cohort) converts the angriest segment into a quiet one. The revenue cost is almost always smaller than the churn-and-reputation cost of forced migration.
4. **Sequence: new customers first.** Run the new model for new signups for a quarter or two. It debugs packaging, fences, and billing edge cases on people with no expectations.
5. **Bridge with choice where losers are concentrated.** Offer affected accounts a one-time option: keep legacy terms for N months or switch now with a credit. Choice defuses the fairness reaction even when most pick the default.
6. **Watch cohort metrics, not the average.** Track conversion, expansion, churn, and support volume per cohort (legacy, migrated, new). Averages hide a bleeding segment for months.

## Model Selection Checklist

Work through these in order; the answers usually converge on one or two viable models:

- [ ] **How does value scale?** Continuously with time → subscription. With consumption → usage. With discrete results → outcome-based.
- [ ] **Can the customer predict and control the metric?** If no, add caps/commits or choose a steadier metric.
- [ ] **What does the buyer's budget process accept?** Line items procurement recognizes clear faster than novel metrics.
- [ ] **Where is the risk best carried?** Risk-averse buyers + confident vendor → usage or outcome models close deals; risk-averse vendor → subscription with commits.
- [ ] **Is acquisition or monetization the binding constraint?** Acquisition-bound with near-zero marginal cost → freemium or free trial on top of the model.
- [ ] **Does the model reward the behavior you need?** Check that the metric doesn't tax adoption, collaboration, or experimentation.
- [ ] **Can billing actually implement it?** Metering, proration, alerts, and invoices are product features; a model your billing stack can't explain will leak trust monthly.
- [ ] **Did customers react to the model in research?** If nobody asked "can we pay per X?" and you're inventing an exotic metric, run five more interviews first.
