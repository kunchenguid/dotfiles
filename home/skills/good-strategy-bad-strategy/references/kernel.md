# Writing the Kernel

## Table of Contents

- [What the Kernel Is](#what-the-kernel-is)
- [Diagnosis Craft](#diagnosis-craft)
- [Formulating the Guiding Policy](#formulating-the-guiding-policy)
- [Designing Coherent Actions](#designing-coherent-actions)
- [The Kernel Template](#the-kernel-template)
- [Worked Example 1: Seed-Stage Startup](#worked-example-1-seed-stage-startup)
- [Worked Example 2: Established Product](#worked-example-2-established-product)
- [When Is a Kernel Done](#when-is-a-kernel-done)

## What the Kernel Is

The kernel is the minimum viable structure of a strategy: a **diagnosis** that defines the nature of the challenge, a **guiding policy** that commits to an overall approach for dealing with it, and a set of **coherent actions** that carry the policy out. Everything else in a strategy document — market sizing, vision statements, financial projections — is either input to the kernel or decoration around it.

The kernel deliberately excludes things most strategy documents lead with:

| Common plan artifact | What it actually is | Kernel replacement |
|---------------------|--------------------|--------------------|
| Vision statement | A description of a desired future | Diagnosis of what stands between you and any future |
| Mission and values | Identity and conduct norms | Nothing — they are fine, but they are not strategy |
| Goals and targets ("$10M ARR") | Ambitions; outputs of strategy | Guiding policy: the approach that could produce them |
| List of initiatives | Department wish lists | Coherent actions that reinforce one another |
| SWOT grid | Raw material | A judgment about which item on the grid is *the* challenge |

A kernel fits on one page. If it does not, you have not finished choosing.

## Diagnosis Craft

The diagnosis is the most skipped and most valuable element. It is a judgment — a simplification of messy reality that names the critical challenge and, implicitly, what kind of situation you are in. Get it wrong and everything downstream is coordinated effort aimed at the wrong target.

### Finding the critical challenge

1. **Collect the raw mess.** List every problem, threat, complaint, and stalled ambition: churn numbers, lost-deal notes, competitor moves, team frustrations. Do not filter yet. Aim for 15-30 items.
2. **Cluster into candidate challenges.** Group items that share a cause. "Sales cycle lengthening," "champions ghosting," and "more stakeholders per deal" might all cluster into "our buyer changed."
3. **Apply the unlock test.** For each candidate ask: *if this were solved, how much of the rest of the list gets easier?* The critical challenge is upstream of many symptoms.
4. **Apply the addressability test.** Ask: *can we act on this with resources we have or can realistically get?* "The macro economy" fails; "our onboarding loses technical buyers" passes.
5. **Choose one.** The candidate scoring highest on unlock × addressability is your critical challenge — the crux. Naming two is allowed only if one is clearly sequenced behind the other.

### Simplification and the courage to judge

A diagnosis is not a list of facts; it is a claim about which facts matter. "We have 14 problems" is an inventory. "We are a chain-link system stuck at the activation link" is a diagnosis. The simplification feels risky — you are discarding real complexity — but an un-simplified situation cannot be acted on. Write the diagnosis as one falsifiable paragraph, not a slide of bullets.

### Diagnosis by analogy

Experienced strategists diagnose by pattern-matching the situation to known structures. Useful patterns:

| Pattern | Signature | What it implies |
|---------|-----------|----------------|
| Chain-link stuck | Several functions adequate, one weak; global metrics frozen | Fix the weakest link first; ignore global metrics meanwhile |
| Wave of change | Cost structures or rules shifting industry-wide | Position for the attractor state; exploit incumbent inertia |
| Entropy / blur | Overlapping products, drifting prices, fuzzy ownership | Clean house before seeking new advantage |
| Strength-on-strength | You compete head-on where the rival is strongest | Re-segment; find ground where their strength is irrelevant |
| Threshold shortfall | Effort spread thin; nothing reaches visible results | Concentrate; accept being absent elsewhere |

### Tests of a good diagnosis

- Names a cause or structure, not a symptom ("activation is broken," not "growth is slow")
- Falsifiable — specific enough that evidence could prove it wrong
- An informed skeptic would accept that the facts support it
- Points toward action without dictating it
- One paragraph, plain language, no fluff

## Formulating the Guiding Policy

The guiding policy is the overall approach for overcoming the diagnosed obstacles. It is not a goal (an outcome you want) and not an action (a step you will take). It is a method — guardrails that rule out vast realms of possible action and channel effort toward your sources of power: leverage, asymmetric advantage, a wave you can ride, a rival's inertia.

**Drafting procedure:**

1. Write three to five candidate policies in this form: *"We will [approach] by [where/how we concentrate], because [the asymmetry or leverage that makes it work for us specifically]."*
2. For each candidate, list at least three significant things it **rules out**. If you cannot, the candidate is a platitude — discard it.
3. Check each against the diagnosis: does it actually address the named obstacle, or just sound strategic near it?
4. Pick one. Two guiding policies means you have not chosen.

**Tests of a good guiding policy:**

- Rules out real options people currently want to pursue
- Exploits a named asymmetry — it would be a *bad* policy for your nearest competitor
- Short enough to repeat in meetings from memory
- Stable for quarters, not days — actions change faster than policy

## Designing Coherent Actions

Actions are where strategy becomes visible — and where most documents collapse into a list of independent department initiatives. Coherence means the actions are coordinated: each one makes the others more effective, and none works against another.

**Design steps:**

1. **Derive, don't collect.** Generate actions only from the guiding policy. Do not import the existing roadmap and relabel it.
2. **Run the coherence check.** For each pair of actions ask: does A make B easier, harder, or neither? A strategy whose actions are all "neither" is a list; any "harder" pair must be resolved now, not discovered in Q3.
3. **Back each action with resources.** Owner, people, budget, start date, done-test. An action nobody is staffed for is a hope.
4. **Write the stop-doing list.** Coherent action includes withdrawal: name the projects, segments, or features being stopped to fund the strategy. If nothing stops, nothing was chosen.
5. **Make the first step proximate.** Something concrete starts within two weeks. Distant-future actions are goals wearing costumes.

## The Kernel Template

```
KERNEL: [name / date / author]

DIAGNOSIS (one paragraph)
The critical challenge is [cause/structure, not symptom].
Evidence: [2-4 facts that support it].
This is a [pattern/analogy] situation.
What would prove this wrong: [signal].

GUIDING POLICY (one or two sentences)
We will [approach] by [concentration], because [our asymmetry].
Therefore we will NOT: [3+ ruled-out options].

COHERENT ACTIONS (3-5, each resourced)
1. [Action] — owner, resources, start, done-test, reinforces #__
2. ...
STOP DOING: [projects/segments/features being withdrawn]

REVIEW: re-test diagnosis on [date / metric trigger].
```

## Worked Example 1: Seed-Stage Startup

**Situation:** Eight-person startup selling an AI code-review tool. $35K MRR, flat for five months. Self-serve signups convert at 9%; the team is split across building IDE plugins, a GitHub app, and an enterprise pilot. Two competitors are better funded.

**Diagnosis:** "Growth is flat" is the symptom. The cluster analysis shows: trials stall before the tool sees a real pull request; setup requires CI changes most users abandon; the enterprise pilot consumes 40% of engineering for one logo. The critical challenge: **time-to-first-value is ~2 days in a market where rivals demo value in minutes — and our effort is spread across three motions, none past the visibility threshold.** Pattern: threshold shortfall plus a weak activation link.

**Guiding policy:** *Win the GitHub-native mid-size team by being the only reviewer that shows a high-quality review on the customer's own code within 10 minutes of install, concentrating everything on that single motion.* Therefore we will NOT: pursue enterprise pilots this year, build IDE plugins, or support GitLab/Bitbucket.

**Coherent actions:**

1. Rebuild onboarding to run on a repo's last 20 merged PRs at install — no CI changes (2 engineers, starts Monday; done when median time-to-first-review < 10 min)
2. End the enterprise pilot; refund and refer (founder, this week) — frees the 40% that funds action 1
3. Retarget all marketing to "first review in 10 minutes," with live public benchmark repos (1 marketer, 2 weeks)
4. Instrument the activation funnel install → first review → first comment accepted (1 engineer, 1 week) — the lab for testing the diagnosis

Each action reinforces the others: the pilot's end staffs the rebuild; instrumentation proves or kills the diagnosis; marketing's promise is the product's new behavior.

## Worked Example 2: Established Product

**Situation:** Twelve-year-old field-service management platform, $28M ARR, serving HVAC, plumbing, landscaping, and cleaning companies. Renewals slipping (NRR 96%); a vertical-only HVAC rival wins on "built for HVAC" despite fewer features. Three pricing plans overlap; the roadmap is a union of the four industries' requests.

**Diagnosis:** Not "the rival is cheaper" — win/loss notes show price is rarely decisive. Twelve years of serving four verticals created **entropy and below-threshold quality everywhere**: the product is 70% right for each industry while the rival is 95% right for one. Each vertical's requests dilute the others. Pattern: entropy plus strength-on-strength against a focused attacker.

**Guiding policy:** *Re-concentrate as the system of record for mechanical trades (HVAC + plumbing), matching the vertical rival's fit while exploiting our one real asymmetry — ten years of job-cost data — to ship benchmarking no startup can copy.* Therefore we will NOT: build for landscaping/cleaning beyond maintenance mode, chase feature parity horizontally, or discount to save renewals.

**Coherent actions:**

1. Split the roadmap: 80% of engineering to mechanical-trades workflows; landscaping/cleaning enter maintenance mode with a 12-month support promise (VP Product, this quarter)
2. Ship job-cost benchmarking ("your margin vs. 4,000 mechanical contractors") as the renewal anchor (data team, 2 quarters; done at 30% renewal-conversation usage)
3. Collapse three overlapping plans into one mechanical-trades ladder; grandfather others (pricing lead, 6 weeks)
4. Retrain sales on a "built for mechanical trades" narrative with benchmark proof (sales enablement, parallel with 2)

The stop-doing list is the strategy: maintenance mode funds the concentration, and the data asymmetry — not nostalgia for breadth — is what the rival cannot follow.

## When Is a Kernel Done

- Diagnosis: one falsifiable paragraph a skeptic would sign
- Guiding policy: one approach, three-plus ruled-out options, anchored in a named asymmetry
- Actions: 3-5, mutually reinforcing, each with owner/resources/date/done-test
- Stop-doing list exists and actually frees the resources the actions need
- The whole kernel fits on one page and can be explained aloud in five minutes
- A review trigger is set — date or metric — at which the diagnosis gets re-tested

If the kernel passes all six, you have a strategy. If it fails any one, you have a draft — keep choosing.
