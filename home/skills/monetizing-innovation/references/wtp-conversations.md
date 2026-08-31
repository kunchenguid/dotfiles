# Running Willingness-to-Pay Conversations

## Table of Contents

- [Why Talk Price Early](#why-talk-price-early)
- [Ground Rules](#ground-rules)
- [The Question Toolkit](#the-question-toolkit)
- [Simplified Conjoint for Practitioners](#simplified-conjoint-for-practitioners)
- [Interpreting the Answers](#interpreting-the-answers)
- [Sample Sizes and Logistics](#sample-sizes-and-logistics)
- [B2B vs B2C Differences](#b2b-vs-b2c-differences)
- [From WTP Data to Product Specs](#from-wtp-data-to-product-specs)

## Why Talk Price Early

The willingness-to-pay (WTP) talk is the single highest-leverage conversation in product development, and it belongs at the concept stage — when the product is a one-page description, not a beta. At that point, every answer can still change the design: which features make the cut, which segment you build for, whether the business case clears the bar, whether the product should exist at all.

Teams avoid the conversation for predictable reasons: "customers can't know what they'd pay for something that doesn't exist," "we don't want to anchor them low," "we'll figure out pricing closer to launch." All three are wrong in the same way — they treat WTP research as setting a price. It is not. It is measuring value. You are not asking customers to commit to a number; you are reading how much the problem matters to them, which parts of your solution carry that value, and how the answers differ across customers. The final price comes later. The signal is available now.

A useful reframe for the team: if customers will not tell you what the product is worth, the market will — at launch, expensively, in public.

## Ground Rules

1. **Talk to people who control budget.** Users tell you about value in use; buyers tell you about willingness to pay. In B2B you need the economic buyer in the sample, not only champions. In B2C, the user usually is the buyer — but confirm it (parents pay for teens; one partner pays for the household).
2. **Frame it as a value conversation.** Open with: *"We're deciding what to build, and I'd like to understand what this would be worth to you — there's no price list and I'm not selling anything today."* This lowers the negotiation guard that otherwise corrupts every answer.
3. **Never rely on one question.** Single answers are noise. Triangulate with at least three of the methods below and look for convergence.
4. **Treat answers as relative, not absolute.** A stated "$50" is not a price you can charge; it is a point on a curve you compare across features, concepts, and respondents.
5. **Describe the concept in value terms before any price question.** One paragraph: who it is for, the problem, the outcome. If respondents misunderstand the concept, their WTP answers are about something else.
6. **Never promise the researched price.** Make explicit that this is research; otherwise early interviewees become aggrieved negotiators at launch.
7. **Record the "why" behind every number.** The reasons reveal segments; the numbers alone do not.

## The Question Toolkit

### Direct value questions

Start broad, then narrow:

- *"What would you say this is worth to your team?"*
- *"What do you pay today to solve this problem, in tools, people, or workarounds?"*
- *"If this saved you the four hours a week you described, what would that be worth?"*

Direct questions are the weakest single instrument but the best conversation starters — they surface the customer's value logic and their reference points (what they compare you to), which you need to interpret everything else.

### The three-point price probe

Ask, in this order:

1. *"What do you think would be an **acceptable** price for this?"* — a price they would consider a good deal and pay without hesitation.
2. *"What would be an **expensive** price — where you'd hesitate, but might still pay if the value is there?"*
3. *"At what price does this become **prohibitively expensive** — out of the question, no matter how good it is?"*

Interpretation:

| Answer | What it tells you |
|--------|-------------------|
| Acceptable | The comfortable floor — pricing here means money left on the table |
| Expensive | The value zone — most healthy prices live between acceptable and expensive |
| Prohibitive | The ceiling — pricing at or above this needs a different segment, not persuasion |

The gaps matter as much as the numbers. A narrow acceptable-to-prohibitive range signals a commodity perception; a wide range signals differentiated value or a confused concept — the "why" follow-ups tell you which.

### Purchase-probability scale

After showing the concept at a specific price: *"On a scale of 1 to 5, where 5 is 'I would definitely buy this,' how likely would you be to buy at $X?"*

Scoring discipline:

- Count 5s as real interest — then discount, because stated intent overstates behavior
- Count 4s as soft maybes — worth at most a fraction
- Treat 1-3 as no

Use the scale comparatively rather than absolutely: ask it at two or three price points (across different respondents or rotated orders) and watch how the top-box percentage decays as price rises. The decay curve is the finding; the raw percentages are not forecasts.

### Trade-off forcing

The most honest answers come when respondents must give something up:

- **Ranking:** *"Rank these eight capabilities from most to least important to your purchase decision."*
- **Point allocation:** *"You have 100 points. Spread them across these features in proportion to the value of each."* Features that average under ~5 points are filler or killer candidates.
- **Would-you-rather pairs:** *"Version A has the integrations but no analytics at $79. Version B has analytics but no integrations at $79. Which do you pick?"*
- **Build-your-own:** Give a base product at a base price and a menu of priced add-ons; ask them to build the package they would actually buy. Watch what they skip — skipped-at-any-price items are killer candidates.

## Simplified Conjoint for Practitioners

Full conjoint analysis is a statistical method agencies run with specialized software. The logic, however, is simple enough to run "good-enough" versions yourself:

1. **Pick 3-4 attributes plus price.** For a SaaS tool: integrations (3 vs 20), analytics (basic vs advanced), support (email vs dedicated), price ($29 / $79 / $149 per seat).
2. **Compose 8-12 choice tasks.** Each task shows 2-3 product profiles with different attribute combinations and prices, plus a "none of these" option. Vary attributes systematically so each level appears across tasks roughly equally often.
3. **Ask respondents to choose one profile per task.** Choosing is easy and honest — it mirrors buying. No respondent sees the underlying design.
4. **Count.** Across all respondents and tasks, compute each attribute level's win rate: how often profiles containing it were chosen versus shown. Large gaps between levels = that attribute drives choice (leader). Small gaps = filler. A level whose presence *lowers* win rate = killer signal.
5. **Read price sensitivity from the choice shifts.** How much choice share does the same package lose moving from $79 to $149? That elasticity, even roughly measured, beats any direct question.

This simplified version sacrifices statistical rigor for speed. Use it to rank features and bracket price ranges; commission a proper conjoint (or use survey tools with built-in conjoint modules) when a major launch hangs on the result.

## Interpreting the Answers

**Build the WTP curve, not the WTP average.** Plot what share of respondents accepts each price point:

| Price per seat | % calling it acceptable or better |
|----------------|-----------------------------------|
| $20 | 90% |
| $40 | 72% |
| $60 | 38% |
| $80 | 31% |
| $120 | 24% |
| $160 | 6% |

Read the cliffs and plateaus. Here the cliff between $40 and $60 plus the plateau from $60-120 suggests two populations: a price-sensitive majority near $40 and a smaller group comfortable to ~$120. That is a segmentation finding — two offers — not an averaging problem ("charge $68") to solve.

**The average trap.** The mean of a bimodal market describes a customer who does not exist. Always look at distribution shape before computing anything.

**Haircut stated numbers.** Stated WTP runs optimistic: respondents are agreeable, spend imaginary money, and ignore switching costs. Treat stated numbers as the ceiling of the realistic range, validate with behavioral evidence (pilot offers, pre-orders, signed letters of intent at a named price), and watch early sales against the research before trusting it fully.

**Red flags that invalidate the data:**

- Answers clustered exactly on your current price or a competitor's list price — respondents are quoting the market back at you, not valuing the concept
- Identical answers across very different customers — your concept description is leading them
- Refusal to engage with price at all — you are interviewing users with no buying authority
- Politeness pattern: every feature "very valuable," every price "fair" — switch to trade-off forcing immediately

## Sample Sizes and Logistics

**B2B:** 15-25 interviews per target segment, done as 30-45 minute conversations. Saturation arrives quickly — when three consecutive interviews produce no new value logic, you have enough for design decisions. Below 10 per segment, treat findings as directional only.

**B2C:** Interviews (10-15) to learn the value language first, then a survey of 150-300 respondents per segment for the price probes and purchase-probability questions. Simplified conjoint needs roughly 200+ completed responses to be readable; below that, stick to ranking and the three-point probe.

**Cadence:** A competent WTP study — recruit, interview, survey, synthesize — fits in 3-6 weeks. That is shorter than one development sprint cycle wasted building a filler feature.

**Who runs it:** Product plus one finance- or pricing-minded person. Founders should attend B2B interviews but not lead the price questions — customers negotiate with founders reflexively.

## B2B vs B2C Differences

| Dimension | B2B | B2C |
|-----------|-----|-----|
| Primary method | Depth interviews with the buying unit | Surveys and panels, interviews for language |
| Who answers | Economic buyer, champion, procurement (separately) | The end consumer |
| Value logic | Quantifiable: hours saved, revenue gained, risk avoided | Perceived: convenience, identity, enjoyment |
| Distortion | Procurement gamesmanship — buyers underquote on purpose | Agreeableness — respondents overquote to be nice |
| Validation | Pilot agreements, LOIs at a named price | Pre-orders, fake-door tests, A/B price tests on real traffic |
| Sample | 15-25 per segment | 150-300+ per segment |

**B2B extra: quantify economic value.** Anchor interviews with an economic value estimate: start from the customer's next-best alternative (current tool, manual process, doing nothing), then add the monetized differentiation value your product provides (time saved × loaded cost, error rate reduction × cost per error, revenue lift × margin). WTP normally lands at a fraction of provable economic value; if your interviews report WTP *above* your economic value math, your model is missing a value driver — find it before pricing.

**B2C extra: test behavior, not just words.** Landing pages with different price points, waitlists with deposit options, and purchase-intent tests on ads give behavioral WTP signals cheaply. Keep price experiments honest: test prices on genuinely available offers and honor the best price seen by any cohort if challenged — fairness complaints travel fast.

## From WTP Data to Product Specs

The research only pays off when it changes what gets built. Three mechanisms:

**1. The feature-WTP table.** Every roadmap candidate gets a row before it gets a sprint:

| Feature | Evidence | WTP signal | Classification | Decision |
|---------|----------|-----------|----------------|----------|
| Slack integration | 18/20 rank top-3; +9 pts win rate | Drives choice, low standalone WTP | Leader | Build, all tiers |
| Advanced analytics | High WTP in 1 of 3 segments | $30-50/seat in agencies segment | Segment leader | Build, top tier |
| AI summaries | "Nice," never ranked top-5 | ~0 incremental WTP | Filler | Defer |
| Mandatory onboarding training | 6/20 said would block purchase | Negative | Killer | Make optional, unbundle |

**2. WTP gates in the development process.** Add one question to every spec review: *"What is the willingness-to-pay evidence for this?"* Accepted answers: interview data, conjoint win rates, pilot commitments. Not accepted: "competitors have it," "sales asked," "it's cool." Features can still ship without WTP (strategic, defensive, compliance) — but then the document says so explicitly, and the cost is visible.

**3. The living business case.** Maintain one page linking the chain: target segment → validated WTP range → chosen price metric and level → expected volume at that price (from the WTP curve) → cost to build and serve → margin. Update it whenever scope, segment, or price assumptions change — a business case written once at kickoff and never touched is a prop, not a plan. At launch, this page becomes the monitoring baseline: actual conversion and ARPU versus the curve you researched.
