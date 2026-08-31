# Demo Culture: Creative Selection and the Demo-Driven Review

How Apple's software was actually decided — working demos shown to a decisive reviewer, iterated until great — and how to install that loop in any team or agent workflow.

## Contents

- [Where this comes from](#where-this-comes-from)
- [The creative selection loop](#the-creative-selection-loop)
- [Why demos beat documents](#why-demos-beat-documents)
- [What counts as a demo](#what-counts-as-a-demo)
- [The decider](#the-decider)
- [The demo derby](#the-demo-derby)
- [The keyboard derby story](#the-keyboard-derby-story)
- [Honest-demo rules](#honest-demo-rules)
- [Demo review mechanics](#demo-review-mechanics)
- [Prototyping the riskiest moment first](#prototyping-the-riskiest-moment-first)
- [Real artists ship](#real-artists-ship)
- [Installing demo culture](#installing-demo-culture)
- [Demo culture for AI agents](#demo-culture-for-ai-agents)

## Where this comes from

Ken Kocienda spent fifteen years as an Apple engineer — Safari, the original iPhone keyboard, iPad autocorrect — and wrote *Creative Selection* to document how the sausage was actually made. His answer is striking for what's absent: no grand design phase, no thick specs, no consensus workshops. Instead:

> A small team builds a **demo**, shows it to a **decision-maker**, receives **specific feedback**, and builds the next demo. Repeat until insanely great or killed.

He calls the process "creative selection" — variation and selection, like evolution, except the selection pressure is a person with taste and authority reacting to a concrete artifact. Jobs sat at the top of a demo pyramid: work was demoed up through layers (team lead → Henri Lamiraux/Scott Forstall → Jobs), getting selected and refined at each level before reaching him.

## The creative selection loop

```
make a demo → show the decider → get concrete feedback → decide (pursue / change / kill) → next demo
```

Properties that make the loop work:

- **Cadence over ceremony.** Demos happen weekly or faster. The loop's value is its iteration count, not any single review's brilliance.
- **Concrete over abstract.** Discussion is about the thing on the screen — this animation, this key layout — never about hypothetical users or imagined architecture.
- **Selection over accumulation.** Each round explicitly kills options. The output of a demo review is a *decision*, not a list of considerations.
- **Small teams, named authors.** A demo has an author who owns it and can change it by tomorrow — at Apple this crystallized as the DRI, the Directly Responsible Individual.

## Why demos beat documents

A spec is a promise about a product; a demo *is* the product, in miniature. The differences that matter in review:

| | Spec / slide review | Demo review |
|---|---|---|
| What each person approves | Their own imagined product | The same artifact |
| Hard problems | Deferred ("implementation detail") | Exposed immediately |
| Feel, latency, awkwardness | Invisible | The first thing everyone notices |
| Feedback | Abstract ("consider the user journey") | Specific ("that key is too small") |
| Politics | Rewards good writers/presenters | Rewards good products |
| Convergence | Endless comment rounds | A decision per session |

Documents still have a job — analysis, constraints, API contracts. But the *decision* about whether something is good must be made against an artifact someone can touch. Jobs' allergy to slideware made the general point: "People who know what they're talking about don't need PowerPoint."

## What counts as a demo

A demo is anything a reviewer can directly experience that honestly represents the decision being made:

- Clickable prototype with realistic content (for flow decisions)
- A real build behind a flag, on the target device (for feel/latency decisions)
- A single working screen with hardcoded everything *except* the thing being decided
- For an algorithm: the real algorithm on real data, even with a throwaway UI
- For copy/voice: the actual screens with the actual words, read aloud in context

What does *not* count: static mockups for an interaction decision, lorem ipsum for a content-density decision, a video recorded on the one path that works (unless labeled as such), "imagine that this button…" — if the reviewer must imagine it, it isn't a demo.

Match fidelity to the decision: deciding navigation feel needs animation and latency; deciding information hierarchy needs real content; deciding visual direction can be a flat image. The sin is fidelity *below* the decision, not low fidelity per se.

## The decider

Creative selection requires someone empowered to say "this one, not that one" and make it stick. Without a decider, demo reviews degrade into feedback-collection sessions where all options survive.

What the role demands:

- **Taste** — a developed, articulable sense of what great looks like in this domain (taste is trainable: exposure to great work + the habit of articulating *why* it's great)
- **Consistency** — the team can predict the standard well enough to pre-filter their own work
- **Decisiveness** — every demo session ends with pursue / change-this-specific-thing / kill
- **Presence** — the decider attends; delegated verdicts via notes kill the loop's bandwidth

Wide input, narrow decision: anyone can speak in the review; one person owns the verdict. This is the antidote to design-by-committee, which Jobs treated as the default failure mode of large companies.

## The demo derby

When a problem has several plausible approaches and argument isn't resolving it, stop arguing and run a derby: multiple authors (or one author, multiple approaches) each build a working demo of their answer; the decider experiences all of them side by side and picks one.

Rules that keep derbies healthy:

1. Same brief, same constraints, same deadline for all entrants.
2. Working demos only — the derby judges products, not pitches.
3. One winner. The verdict may graft an idea from a loser onto the winner, but you ship *one* approach, not a compromise blend of all of them.
4. Losing is normal and cheap. The point of the derby is to make killing ideas feel like process, not punishment.

Derbies cost duplicate effort by design — that's the price of replacing weeks of abstract argument with an afternoon of evidence.

## The keyboard derby story

The canonical derby, from *Creative Selection*: typing on glass was the iPhone project's scariest unsolved problem — keys far smaller than fingertips, no tactile feedback. Rather than spec the answer, the team held a derby. Every engineer on the project built a complete working keyboard — zoomed keys, multi-letter keys with word disambiguation, gesture schemes — and the leadership typed on each one.

Kocienda's entry, with keys carrying multiple letters and a dictionary-backed algorithm guessing the intended word, won. He became DRI for the keyboard, and the multi-letter layout was later simplified back to single letters — but the *autocorrect engine* the derby had selected became the thing that made glass typing work at all.

What reviewers should take from the story: the derby surfaced that the real product wasn't the key layout (the visible thing everyone argued about) but the correction algorithm (the invisible thing only working demos could reveal). Specs argue about layouts; demos discover algorithms.

## Honest-demo rules

Demo culture has a known failure mode: the staged demo that hides the truth. Guard rails:

- **Declare the seams.** Author states upfront what's real, what's hardcoded, what's faked. Faking the *undecided* part voids the demo.
- **Real data scale.** Three tidy rows lie about three thousand. Demo with realistic volume, lengths, and ugliness (long names, empty fields, slow networks).
- **Target device, target conditions.** A phone UI on a projector, a latency-sensitive flow on localhost — both lie.
- **Let the reviewer drive.** A driven demo follows the rehearsed path; handing over the input device is the honesty test. The reviewer will immediately tap the thing that doesn't work — that's the data.
- **Known breakage is disclosed, not discovered.** Finding out later that the demo's "minor caveat" was load-bearing destroys the trust the loop runs on.

## Demo review mechanics

The weekly demo review, concretely:

- 30 minutes, standing decider, working artifacts only; anything without a demo waits a week.
- Author gives one sentence of intent ("this demo decides whether inline editing feels better than modal editing"), then hands over the controls.
- Feedback follows the candor rules ([review-protocol.md](review-protocol.md)): about the work, specific, with direction.
- Session ends with a verdict per demo: **pursue** (next demo refines), **redirect** (next demo changes X), or **kill** (write one line about why, so the lesson persists).
- Keep a demo log — date, demo, verdict, reason. The log *is* the design history; specs go stale, the log doesn't.

## Prototyping the riskiest moment first

A demo of the easy 80% proves nothing and burns the team's credibility on polish. Sequence demos by risk:

1. Name the assumption that, if false, kills the project (glass typing can work; sync can be conflict-free; the AI's latency is tolerable).
2. Demo *that* first, ugly everywhere else.
3. Only after the scary demo passes does polish enter the loop.

This is also the right read of Jobs' product instincts: the iPhone bet was decided by whether multitouch scrolling could feel right — the demo that made executives' jaws drop — not by renders of the industrial design.

## Real artists ship

The Macintosh team's 1983 motto — "Real artists ship" — is demo culture's deadline clause. The loop iterates *toward a date*, and the decider's job includes calling "done." Signs the loop is being abused as procrastination: demos refine the same decided thing for weeks; verdicts are all "pursue" with no kills; the riskiest assumption still has no demo while the easy parts gleam. Iteration is a tool for converging, not a license to avoid the verdict.

(The companion motto — shipping junk is also not artistry — is the binary verdict in [review-protocol.md](review-protocol.md).)

## Installing demo culture

Adoption order for a team that currently reviews documents:

1. Declare one recurring 30-minute demo slot. Working artifacts only; no slides allowed in the room.
2. Name the decider (per product area). Announce that demo sessions end in verdicts.
3. Convert the next contested design debate into a derby instead of a meeting series.
4. Start the demo log.
5. Add honest-demo rules to the team's definition of "ready for review."

Expect two weeks of discomfort: demos feel exposing, verdicts feel harsh, and the first kills sting. The compensation is that arguments end, and the product — not the deck — becomes the unit of progress.

## Demo culture for AI agents

When an agent builds or reviews software, the same physics apply:

- **As builder:** produce the running artifact early (screenshot, preview URL, executed test) and review your own work against it — never declare a UI change done from code alone. The demo is the verification.
- **As reviewer:** refuse to verdict from descriptions. Run the app, drive the flow, screenshot the states, *then* apply the review protocol.
- **As derby runner:** when approaches genuinely compete, build both cheaply, compare the artifacts, pick one — and say which and why, rather than presenting both to the user as a menu.
