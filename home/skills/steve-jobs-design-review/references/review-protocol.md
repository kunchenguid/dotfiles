# The Jobs-Style Review Protocol

A complete, repeatable structure for running design and product reviews to Steve Jobs' standard: customer experience first, working demos only, brutal specificity, binary verdicts.

## Contents

- [Why a protocol at all](#why-a-protocol-at-all)
- [Before the review: experience it cold](#before-the-review-experience-it-cold)
- [The agenda](#the-agenda)
- [Step 1: State the promise](#step-1-state-the-promise)
- [Step 2: The cold walkthrough](#step-2-the-cold-walkthrough)
- [Step 3: The principle audit](#step-3-the-principle-audit)
- [Step 4: The cut list](#step-4-the-cut-list)
- [Step 5: The verdict](#step-5-the-verdict)
- [The output format](#the-output-format)
- [Candor rules](#candor-rules)
- [The MobileMe pattern: reviewing against the promise](#the-mobileme-pattern-reviewing-against-the-promise)
- [Saying-no rituals](#saying-no-rituals)
- [Review cadence](#review-cadence)
- [Anti-patterns](#anti-patterns)
- [Adapting the protocol](#adapting-the-protocol)

## Why a protocol at all

Jobs' reviews looked improvised — he'd pick up the device, poke at it, and react. But underneath the theater was a stable pattern: he experienced products as a customer, judged them against their stated promise, demanded working artifacts, gave feedback so specific it doubled as a fix list, and ended with an unambiguous verdict. Most teams' reviews fail on exactly the dimensions his pattern enforced: they review intentions instead of artifacts, soften feedback into vagueness, and end without a decision.

The protocol below makes that pattern repeatable without requiring a Jobs in the room. Any reviewer — including an AI agent reviewing a design, a PR with UI changes, or a product spec — can run it.

## Before the review: experience it cold

The single highest-leverage act: **use the product before anyone explains it to you.** Jobs famously took products home over weekends and returned with reactions formed as a user, not as an executive who'd been walked through the roadmap.

Rules for the cold run:

- No guided tour, no demo script, no "let me just show you where that is." First impressions are unrepeatable; a walkthrough destroys the data.
- Start where a real customer starts: the ad, the App Store page, the signup form, the unboxing — not the feature in question.
- Use real data at realistic scale. An inbox demo with three tidy emails lies about an inbox with three thousand.
- Note every moment of hesitation, every time you had to think, every time you felt stupid. Those notes are the review.
- Time yourself reaching the core value. Write the number down; you'll need it for the steps-to-value audit.

If the product cannot be experienced cold — because it doesn't run, or requires an engineer standing by — that itself is the review finding: there is no demo, so there is nothing to review. Reschedule. (See [demo-culture.md](demo-culture.md).)

## The agenda

A full review runs five steps, in order, typically 30–60 minutes:

1. **State the promise** (2 min) — what does this claim to do?
2. **Cold walkthrough findings** (10 min) — the reviewer's unguided experience
3. **Principle audit** (15–25 min) — simplicity, focus, how-it-works, whole experience, back of the fence
4. **Cut list** (10 min) — what gets removed
5. **Verdict** (5 min) — binary, with ranked fixes

The order matters. Teams instinctively want to open by presenting context, constraints, and effort invested. Don't allow it — context biases the review toward sympathy for the team rather than the customer's reality. Context gets airtime in step 5, when deciding what to do about the findings, not before.

## Step 1: State the promise

Ask the team for one sentence: *"What is this supposed to do?"* Write it down verbatim. Everything else in the review tests that sentence.

If the team can't produce the sentence — if they offer three sentences, or a paragraph with "and also" in it — the review has already found its first defect: the product lacks a One Thing, and no amount of polish fixes a product that doesn't know what it's for. Pause and resolve focus before reviewing execution (see [simplicity-and-focus.md](simplicity-and-focus.md)).

## Step 2: The cold walkthrough

The reviewer presents their unguided experience, chronologically: what they expected, what happened, where they hesitated, what they never found. The team's job in this step is to listen and take notes — not to explain, justify, or troubleshoot.

Every "oh, that's because…" from the team gets the same response: *the customer won't have you standing next to them.* An explanation that's necessary in the room is a redesign requirement in the product.

## Step 3: The principle audit

Walk the five quality lenses in order. For each, the questions to ask:

**Simplicity.** How many steps from entry to core value? What's on this screen that isn't serving its single intent? Which settings should be defaults? What requires explanation? ("If you must explain it, redesign it.")

**Focus.** Does every visible feature serve the promise from step 1? What's here because a stakeholder asked, rather than because the customer needs it? What would we cut if we could only keep three things?

**How it works.** Show the failure states: offline, error, empty, slow. Where does the user wait, and what happens while they wait? How does this feel on the 100th use? Does anything require a manual?

**Whole experience.** Walk the seams: the email that brought them here, the loading screen, the invoice, the support path, the cancellation. Who designed each? "Nobody" is a finding. (Full touchpoint method: [end-to-end-experience.md](end-to-end-experience.md).)

**Back of the fence.** Open the screens nobody demos — 404s, error toasts, settings, account pages. Read the copy aloud. Would the team sign their names inside this? (Case examples: [case-studies.md](case-studies.md).)

## Step 4: The cut list

Before any discussion of fixes or additions, force subtraction: *"What are we removing?"*

A review that ends with only additions has made the product worse — more scope, same deadline, no increase in focus. Healthy reviews remove something nearly every cycle: a redundant option, a low-traffic feature, a tier, a screen. If genuinely nothing can be cut, the team must defend each survivor in one sentence against the promise.

## Step 5: The verdict

End binary. The two allowed verdicts:

- **INSANELY GREAT** — ship-worthy as is. Rare by design; saying it when untrue devalues the standard.
- **NOT DONE** — accompanied by a ranked fix list, each item specific enough to act on without interpretation.

Banned verdicts: "good enough," "ship it and iterate" (without a named iteration), "just needs polish" (polish what, exactly?), and any verdict by vote. One decider owns the call; everyone else informed it.

## The output format

ALWAYS produce this artifact (whether the review is run by a person or an agent):

```
# Design Review: [Product/Feature]
**Verdict:** INSANELY GREAT / NOT DONE (score X/10)
**The One Thing:** [the promise, verbatim from step 1]
**Keeps its promise?** [yes/no + the evidence from the cold run]
**Steps to value:** [count, with the step list]
**Cut list:** [what to remove, why]
**Fix list:** [ranked; each item = what, where, why it fails, fix direction]
**Back of the fence:** [unseen surfaces below the bar]
**Next review:** [date + what must be demoable by then]
```

The fix list is the heart. Each item must pass the specificity test: could a team member start working on it without asking a clarifying question? "The onboarding is confusing" fails. "Step 3 asks for a credit card before showing any value; move payment after the first successful export" passes.

## Candor rules

Jobs' feedback was famously harsh — "this is shit" is the documented phrasing. What made it function was not the harshness but two properties that traveled with it: it was **about the work**, and it was **immediately specific**. Teams could act on it the same afternoon.

Adopt the function, not the cruelty:

- Say "this fails" freely; never say "you failed."
- Every harsh judgment must arrive with its reason and a fix direction in the same breath.
- No sandwiching, no softening into ambiguity — diluted feedback wastes everyone's time and ships mediocrity.
- Praise must be as specific as criticism, and rarer than the team would like. "Be a yardstick of quality. Some people aren't used to an environment where excellence is expected."
- If people leave reviews afraid to demo unfinished work, the review has broken its own feedback loop. Fear is a process defect.

## The MobileMe pattern: reviewing against the promise

When MobileMe launched broken in 2008, Jobs gathered the team and asked one question: *"Can anyone tell me what MobileMe is supposed to do?"* Someone answered correctly. His response: *"So why the f— doesn't it do that?"*

That exchange is the entire review method in two lines. The product was not judged against a spec, a sprint goal, or effort invested — it was judged against its own public promise. The accountability that followed (leadership was replaced on the spot) was severe, but the reviewing logic is universally applicable and kind to no one's ego:

1. State what the product promises.
2. Test whether it does that.
3. The gap is the review.

Use this pattern especially for launch readiness reviews and post-launch quality audits: read the marketing page, then test exactly what it claims, sentence by sentence.

## Saying-no rituals

Focus decays without ritual. Two to institutionalize:

**The top-3 cut.** Jobs' annual "Top 100" retreat ended with the group's ten best ideas on a whiteboard — and Jobs crossing out the bottom seven: "We can only do three." Run the same ritual quarterly: rank everything, draw the line at three, and treat everything below the line as explicitly *not happening*, not "later."

**The add-requires-kill rule.** Any feature added inside a cycle must name the feature, option, or screen it kills. This keeps total complexity flat and forces every addition to argue it's worth more than something that already exists.

## Review cadence

- **Weekly demo review** (30 min): working artifacts only, decider present, verdicts on the spot. This is the creative-selection loop (see [demo-culture.md](demo-culture.md)).
- **Milestone review** (60 min): full five-step protocol, cold run mandatory.
- **Launch readiness**: MobileMe pattern against the marketing copy, plus full back-of-fence audit.
- **Post-launch** (2–4 weeks after): re-run the cold walkthrough on the shipped product; compare against the launch review's promise.

## Anti-patterns

| Anti-pattern | What it looks like | Why it kills the review |
|---|---|---|
| The guided tour | Team drives, reviewer watches | First-impression data destroyed; demos hide what authors avoid |
| Context first | "Before you look, some background…" | Sympathy replaces customer reality |
| Spec review | Slides, mocks, docs — no artifact | Everyone approves a different imagined product |
| Consensus verdict | "Are we all comfortable shipping?" | Averages opinions into mush; nobody owns quality |
| The polish verdict | "Just needs a little polish" | Unactionable; "polish" hides unranked, unnamed defects |
| Effort empathy | "The team worked so hard on this" | Customers don't grade on effort |
| Fear theater | Reviewer performs anger | People stop demoing early work; the loop dies |

## Adapting the protocol

- **Solo founder / agent self-review:** run all five steps against your own work, but do the cold walkthrough after a real break (or have someone uninvolved do it). Write the output artifact anyway — the discipline of the binary verdict is the point.
- **Code review with UI changes:** require a running build or recording, never screenshots alone; apply steps 1–3 to the changed flow; the verdict gates merge.
- **Agency/client reviews:** the promise in step 1 comes from the client's brief; the MobileMe pattern keeps both sides honest about whether the brief was met.
- **AI agent as reviewer:** follow the protocol literally — state the promise, walk the artifact, audit the five lenses, output the artifact format. Never soften the verdict to be agreeable; the user asked for Jobs, not for applause.
