# The Three Interaction Modes in Practice

Team Topologies allows exactly three ways for two teams to interact: collaboration, X-as-a-Service, and facilitating. Everything else — "alignment", "syncing", "working closely with" — is an undeclared mode, and undeclared modes are where organizational friction breeds. This reference covers the mechanics of each mode, how to declare modes explicitly, how to time-box collaboration, how to design service interfaces, a facilitation playbook for enabling teams, and the patterns and triggers for evolving modes over time.

## Mode 1: Collaboration

Two teams work closely together for a defined period to discover something neither could discover alone: a new technology approach, a missing interface, a novel product capability.

**Use when:**

- The boundary between the teams' responsibilities is genuinely unknown
- High-stakes discovery requires both teams' expertise simultaneously (e.g., a stream team and a platform team designing a new deployment model)
- Rapid innovation matters more than predictable delivery, for a bounded period

**Mechanics:**

- Define a joint goal and a hard end date before starting (see time-boxing below)
- Create one shared channel and, ideally, shared working sessions several times a week; partial overlap (a few people from each team) is the common form — full-team merging is rare and costly
- Make decisions jointly within the collaboration scope; do not route them up two management chains
- Capture what is being discovered continuously — especially any interface taking shape — because the artifact of a good collaboration is usually the contract that lets the teams stop collaborating

**Costs to budget for:** Both teams' cognitive load rises (each must absorb part of the other's context). Delivery predictability drops for both. Boundary blur means mistakes in either domain temporarily belong to both teams. This is why collaboration is powerful and why it must be rationed: one collaboration at a time per team, as a hard rule of thumb.

## Mode 2: X-as-a-Service

One team consumes something another team provides — a platform capability, a complicated subsystem's API, a data product — with minimal coordination. The provider owns the "X"; the consumer uses it without needing to know its internals.

**Use when:**

- The interface is well understood and reasonably stable (often the *output* of an earlier collaboration phase)
- Many teams need the same thing and per-consumer coordination would not scale
- Predictable delivery matters more than joint innovation

**Mechanics:**

- The provider treats the service as a product: documented, versioned, supported, with a feedback channel
- The consumer files no tickets for routine use — self-service is the defining property
- Coordination is limited to roadmap-level signals (what consumers need next) and incident-level communication

**Designing the service interface.** The interaction only stays cheap if the interface absorbs the coordination. Checklist for the provider:

- [ ] Quick-start that gets a new consuming team to "hello world" in under a day
- [ ] Reference docs generated from the source of truth (API spec, schema), not hand-maintained
- [ ] Versioning policy with explicit deprecation windows (e.g., N-1 supported for 6 months)
- [ ] Error messages that tell the consumer what to do, not just what failed
- [ ] Status page or equivalent, plus an incident communication channel
- [ ] A single, well-known request path for new needs — and a published triage SLA for it
- [ ] Usage metrics per consumer, so the provider can see adoption and pain without asking

**Failure smell:** if consuming the service routinely requires meetings with the provider, you do not have X-as-a-Service; you have collaboration with worse hygiene. Either invest in the interface or formally switch modes.

## Mode 3: Facilitating

One team (almost always an enabling team) helps another acquire a capability: a practice, a technology, a way of working. The facilitator's output is the other team's increased ability, not delivered software.

**Use when:**

- A stream-aligned team has a capability gap that would be slow or wasteful to close alone
- The organization is rolling out a new practice (observability, test automation, threat modeling) across many teams
- A team is about to take ownership of something new (e.g., absorbing a component) and needs a bridge

**Facilitation playbook** (for the enabling team):

1. **Assess (week 0):** observe the team's actual workflow; agree on the gap in the team's own words. Output: a one-page engagement brief — current state, target capability, exit criteria, end date.
2. **Agree the working pattern:** typically 2-3 pairing sessions per week plus one workshop, embedded in the team's real work. Never a parallel side project.
3. **Work on real tasks:** the stream team's backlog items are the training material. The facilitator pairs and coaches; the stream team's hands stay on the keyboard.
4. **Transfer artifacts deliberately:** templates, checklists, starter repos, runbooks — things that outlive the engagement.
5. **Taper:** halve facilitator involvement in the final third; the team runs the practice alone while support is still nearby.
6. **Exit and verify:** end on the agreed date. Four to six weeks later, check the exit criteria again (is the team still doing it unaided?). Publish what was learned for other teams.

**Hard rules:** the facilitator does not own deliverables, does not appear on the stream team's on-call, and does not extend the engagement without a new, explicit brief. Extensions by inertia are how enabling teams decay into dependencies.

## Declaring Modes: Team Interaction Contracts

Every pair of teams that interacts regularly should have a declared mode, recorded where both teams' members will see it (each team's team API page is the natural home). A lightweight contract template:

```markdown
## Team Interaction: <Team A> ↔ <Team B>

- Mode: collaboration | X-as-a-Service | facilitating
- Purpose: <what this interaction exists to achieve>
- Direction: <who provides / who consumes / who facilitates whom>
- Started: <date>    Review/end date: <date — mandatory for collaboration & facilitating>
- Success criteria: <observable outcomes, e.g. "interface v1 published", "team deploys unaided">
- Channels: <shared channel, office hours, request path>
- Escalation: <named person per team>
```

Declaring modes does three things. It sets expectations (a team that knows it is a service consumer stops requesting design meetings). It bounds cost (collaboration has an end date by construction). And it creates a review point — every contract has a date at which the mode is deliberately re-chosen rather than drifting.

A team's full set of declared interactions is also a load check: a stream-aligned team with two collaborations, three service dependencies, and a facilitation underway is over budget regardless of how reasonable each item looks alone.

## Time-Boxing Collaboration

Collaboration without an end date converges on permanent mutual dependency. Defaults that work:

- **Discovery spike between two teams:** 2-4 weeks
- **New platform capability co-design:** 4-8 weeks
- **Major boundary change (component absorption, service extraction):** 6-12 weeks, reviewed at the midpoint

At the end of the box, there are exactly three legitimate outcomes: (1) switch to X-as-a-Service because the interface is now known; (2) end the interaction because the discovery is done; (3) renew the collaboration once, explicitly, with a new goal — renewal by silence is not an option. If a collaboration gets renewed twice, treat it as a topology signal: the team boundary is probably in the wrong place, and the teams may need merging or re-splitting along a different fracture plane.

**Ending well:** the last week of any collaboration is for hardening the artifacts that let the teams separate — the API contract, the runbook, the ownership map. A collaboration that ends without these will quietly restart within a month.

## Mode Evolution: Patterns and Triggers

Modes are temporary by design. The canonical evolution patterns:

**Collaborate → X-as-a-Service.** The standard maturation path. A stream team and a platform team collaborate to discover what a capability must do; once the interface stabilizes, the relationship drops to service mode and coordination cost falls by an order of magnitude. Trigger: change requests to the interface become rare and backward-compatible.

**X-as-a-Service → collaborate (temporarily).** When a consumer needs something qualitatively new from a provider — a new class of capability, a 10x scale change — service mode produces a frustrating ticket ping-pong. Declare a short collaboration to co-design the change, then drop back to service mode. Trigger: a consumer's requests keep being rejected as "not how the API works."

**Facilitating → nothing.** The enabling engagement ends and the teams stop interacting, by design. Trigger: exit criteria met. (If the relationship instead morphs into "just keep helping", return to the playbook's hard rules.)

**Collaboration as adoption accelerant.** When a platform ships a major new capability, briefly collaborating with the first one or two consuming teams beats documentation alone — the platform team learns where the friction is, and the early consumers become references for the rest.

**Triggers to switch, summarized:**

| Signal | Current mode | Move to |
|--------|--------------|---------|
| Interface change requests now rare and compatible | Collaboration | X-as-a-Service |
| Consumer needs are qualitatively new; tickets bounce | X-as-a-Service | Time-boxed collaboration |
| Provider attends consumer's planning every week | "X-as-a-Service" (nominal) | Real collaboration, or fix the interface |
| Exit criteria met; team performs practice unaided | Facilitating | None |
| Collaboration renewed twice | Collaboration | Re-examine the team boundary itself |
| Many consumers ask the provider for the same thing | Many 1:1 interactions | Platform capability + X-as-a-Service |

## Interaction Friction as Organizational Sensing

Treat recurring friction between two teams as data about the design, not about the people:

- **Collaboration feels endless** → the boundary between the teams is wrong; revisit the fracture plane
- **Service feels bureaucratic** → the provider lacks product discipline, or the thing should not be a service at all
- **Facilitation is resented** → the capability was imposed top-down rather than pulled by the team; fix the demand side first
- **No interaction where the architecture says there should be one** → an interface is being designed by accident; expect integration surprises

Review these signals on a regular cadence (a quarterly topology review works for most orgs) and make one deliberate change at a time — modes first, boundaries second, since mode changes are cheaper and often sufficient.
