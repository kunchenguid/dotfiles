# Simplicity and Focus: The Subtraction Disciplines

How to audit a product for simplicity the way Jobs did, and how to enforce focus with the no list, the 2×2 matrix, and steps-to-value measurement.

## Contents

- [Simplicity is conquered complexity](#simplicity-is-conquered-complexity)
- [The simplicity audit](#the-simplicity-audit)
- [Steps-to-value: the core metric](#steps-to-value-the-core-metric)
- [The defaults discipline](#the-defaults-discipline)
- [Deep simplicity vs. surface simplicity](#deep-simplicity-vs-surface-simplicity)
- [The Simple Stick](#the-simple-stick)
- [Focus: the 1997 lesson](#focus-the-1997-lesson)
- [The 2×2 product matrix](#the-22-product-matrix)
- [The no list](#the-no-list)
- [Killing shipped features](#killing-shipped-features)
- [Focus failure modes](#focus-failure-modes)
- [Applying subtraction to common surfaces](#applying-subtraction-to-common-surfaces)

## Simplicity is conquered complexity

Apple's first marketing brochure (1977) carried the line "Simplicity is the ultimate sophistication." Jobs' mature articulation, from the Isaacson biography, is more precise about the cost:

> "Simple can be harder than complex: You have to work hard to get your thinking clean to make it simple. But it's worth it in the end because once you get there, you can move mountains."

And the operational version:

> "It takes a lot of hard work to make something simple, to truly understand the underlying challenges and come up with elegant solutions."

The key word is *underlying*. Simplicity that comes from understanding the problem deeply produces products that need no manual. Simplicity that comes from hiding complexity produces products that feel broken the moment a user steps off the happy path. A reviewer's job is to tell these apart.

## The simplicity audit

Run these checks against any screen, flow, or product:

1. **The one-sentence test.** Can the team state what this screen/feature/product does in one sentence? If the sentence contains "and also," it's two things wearing one UI.
2. **The element census.** List every element a user can see or interact with. For each: which intent does it serve? Elements serving no intent get cut; elements serving a *different* intent move elsewhere.
3. **The explanation test.** What requires a tooltip, a tutorial, an onboarding coachmark, or a docs link? Each is an apology for a design decision. Some are unavoidable (genuinely novel interactions); most are deferrable complexity that leaked to the user.
4. **The decision count.** How many decisions must a user make before getting value? Every modal, option, and "choose your plan" gate is a decision tax. (See [The defaults discipline](#the-defaults-discipline).)
5. **The deletion pass.** For each element, ask: if we removed this, what breaks? "Nothing" — cut it. "An edge case for 2% of users" — consider cutting it and solving the edge case elsewhere. Only "the core promise breaks" earns a place.

The audit's spirit is the famous iPod constraint: it shipped without an on/off switch. Not because the button was hidden, but because deep understanding (the device sleeps and wakes instantly) made the need itself disappear. The best subtraction removes the *need*, not the control.

## Steps-to-value: the core metric

Jobs gave the original iPod team a hard constraint: any song, reachable in three presses. The iDVD pitch was the same instinct — Mike Evangelist prepared detailed feature mockups, and Jobs walked to the whiteboard, drew a single window, and said: *"Here's the new application. It's got one window. You drag your video into the window. Then you click the button that says 'Burn.' That's it."*

Measure it literally in every review:

1. Define "value": the moment the user has the thing they came for (song playing, file exported, invoice sent — not "dashboard viewed").
2. Count every step from entry: each click, field, screen, decision, and wait counts as one.
3. Record the count in the review artifact, and track it across reviews like a performance budget.

Reduction tactics, in order of preference: remove the step entirely → make it a default → defer it until after first value → combine it with another step. Reordering steps is cosmetic; the count is what matters.

Typical findings: registration before value (defer it), plan selection before product experience (default to trial), configuration screens on first run (opinionated defaults), confirmation dialogs guarding recoverable actions (make actions undoable instead).

## The defaults discipline

Every setting is a decision the team failed to make. Settings feel generous — "let users choose!" — but each one:

- Moves a design decision onto someone with less context than the team
- Doubles the QA surface (every option × every other option)
- Becomes a place where bugs hide and back-of-fence neglect accumulates

The review questions: *Which of these settings would we remove if we had to defend each one? What's the right answer for 95% of users — and why isn't that just the behavior?* A setting earns its place only when user contexts genuinely diverge (timezone, language, accessibility) — not when the team couldn't agree.

## Deep simplicity vs. surface simplicity

Ken Segall's distinction, sharpened for reviews:

| | Surface simplicity | Deep simplicity |
|---|---|---|
| Method | Hide controls in menus, "advanced" panels | Remove the underlying need |
| First impression | Clean | Clean |
| 100th use | Frustrating — everything is two levels deep | Still effortless |
| Failure states | Confusing — hidden complexity erupts | Graceful — complexity was actually solved |
| Example | Burying sync conflicts in a settings pane | Sync that resolves conflicts correctly without asking |

Surface simplicity is how teams game a simplicity review. Catch it by auditing the 100th-use experience and the failure states, not the first-run screenshots — minimalism is how it looks; simplicity is how it works.

## The Simple Stick

Inside Apple's marketing org, Segall reports, people described being "hit with the Simple Stick" — Jobs rejecting work for being too complicated: too many words, too many ideas, too many products in one ad. The Simple Stick applies one idea per artifact:

- One message per ad, one idea per slide, one intent per screen, one primary action per view
- Naming: products got names a person can say aloud ("iMac", not "MacMan 3000 Pro DX")
- Copy: if a sentence can lose a word, it loses it

In reviews, the Simple Stick is the moment the reviewer says: "This is three ideas. Pick one." It is the most common and most resisted verdict — every idea has an internal advocate — which is exactly why the review must deliver it.

## Focus: the 1997 lesson

When Jobs returned in 1997, Apple sold dozens of overlapping products — multiple Performa lines, Quadras, printers, the Newton — and was weeks from insolvency. His diagnosis, delivered to the product teams, was that he couldn't tell his friends which Mac to buy; his fix was to cancel ~70% of the product line. Thousands of engineers' work, killed — not because it was bad, but because it was *unfocused*.

The documented principle, from WWDC 1997:

> "Focusing is about saying no."

And later, expanded:

> "People think focus means saying yes to the thing you've got to focus on. But that's not what it means at all. It means saying no to the hundred other good ideas that there are. You have to pick carefully. I'm actually as proud of the things we haven't done as the things I have done. Innovation is saying no to 1,000 things."

The review insight: focus problems never look like focus problems from inside. They look like "serving more customer segments," "competitive parity," and "quick wins." The reviewer's job is to ask what the hundred good ideas currently in the product are costing the three great ones.

## The 2×2 product matrix

Jobs' replacement for Apple's sprawl was a grid on a whiteboard:

| | Consumer | Pro |
|---|---|---|
| **Desktop** | iMac | Power Mac |
| **Portable** | iBook | PowerBook |

Four products. Every project mapped to a cell or died.

Generalize it in reviews of product lines, pricing tiers, and plan structures:

1. Find the two axes that actually distinguish your customers (not the ones that distinguish your teams).
2. Draw the grid. Place every product/tier/SKU in a cell.
3. Two things in one cell → merge or kill one. A thing in no cell → kill it. An empty cell → that's the roadmap.

If the team needs more than four cells, make them defend each axis. Usually one "axis" is an internal org boundary leaking into the catalog.

## The no list

Focus is invisible unless you write it down. Maintain a **no list**: things the product deliberately does not do, with one-line reasons. Review it alongside the roadmap.

- "We don't do per-seat permissions — we serve small teams who trust each other."
- "We don't have an API — we are the integration, not the platform."
- "No dark mode until the core flow is 10/10."

The no list converts saying no from a per-meeting fight into standing policy. New requests get checked against it; changing it requires a deliberate decision, not attrition. In reviews, ask to see the no list. A team that can't produce one isn't focused — it just hasn't been asked for everything yet.

The companion ritual is the **top-3 cut** from Jobs' "Top 100" retreats: rank the ten best ideas, then cross out seven. Three priorities is a strategy; ten is a wish list. (Session mechanics: [review-protocol.md](review-protocol.md).)

## Killing shipped features

The hardest subtraction is retroactive. Shipped features have users, internal advocates, and sunk-cost gravity. But a product that only adds becomes the complexity it once disrupted.

Review questions for every existing feature, annually: What % of users touched this in 90 days? What does it cost (code, QA, UI surface, support, onboarding attention)? Would we build it today? If "no" — schedule the deprecation, communicate honestly, and take the one-time pain over the permanent tax.

Jobs' versions were famously abrupt — killing the floppy drive (iMac, 1998), the optical drive, Flash support, and eventually whole product lines like the iPod mini at its sales peak, to make room for the nano. The lesson isn't the abruptness; it's that he treated removal as a *product feature* that buys simplicity, speed, and room for the next thing.

## Focus failure modes

| Failure mode | Symptom | Subtraction fix |
|---|---|---|
| Stakeholder accretion | Features traceable to internal requests, not user jobs | Every feature names the customer job it serves, or dies |
| Competitive checklist | Roadmap mirrors competitor's feature page | Compete on the One Thing, not on parity |
| Segment greed | "Enterprise needs X, prosumers need Y, students need Z" | Pick the 2×2; serve cells you can win |
| Quick-win addiction | Many small ships, core flow unchanged for quarters | Cap quick wins; reserve majority capacity for the One Thing |
| Roadmap as archive | Nothing has been cut in living memory | Quarterly top-3 cut; visible kill log |

## Applying subtraction to common surfaces

- **Landing page:** one message, one CTA. Every additional section must defend itself against scroll-depth data.
- **Onboarding:** defer every question that can be answered with a default. Aim: value before account where legally possible.
- **Navigation:** if it needs a "More" overflow, the IA has failed the one-sentence test per section.
- **Pricing:** tiers map to the 2×2; if customers need a comparison table with 30 rows to choose, the structure is the problem.
- **Settings page:** treat as a defect backlog — each entry is a decision to revisit, not a feature.
- **Feature flags / experiments:** expiry dates mandatory; flags older than two quarters are unmade decisions compounding.
