# Fracture Planes: Splitting Software for Team Ownership

A fracture plane is a natural seam along which a software system can be split so that each resulting piece fits one team's cognitive load and can be owned outright. Splitting along natural seams keeps most changes inside a single team; splitting along arbitrary ones (or technology layers) converts every feature into a cross-team project. This reference catalogs the planes with selection criteria, walks through a monolith-to-team-ownership mapping exercise, shows how to align with DDD bounded contexts, covers the options for shared code, and gives a sequencing plan for an inverse Conway reorg.

## The Fracture-Plane Catalog

**1. Business domain (bounded context) — the default.** Split along the business's own conceptual seams: ordering, payments, fulfillment, identity. Changes cluster within domains because business requests arrive in domain language, so domain-aligned pieces localize change best. *Choose when:* almost always, as the starting hypothesis. *Watch out for:* contexts drawn from the current database schema rather than from the business — schema reflects yesterday's org (Conway in reverse).

**2. Regulatory compliance.** Isolate the parts subject to a heavy regime (PCI-DSS, HIPAA, SOX, medical-device class rules) so audits, change controls, and sign-offs apply to a small surface instead of the whole system. *Choose when:* compliance overhead measurably slows unregulated work. *Watch out for:* the regulated piece still needs a clear domain identity, or it becomes a dumping ground "because it's already audited."

**3. Change cadence.** Separate parts that change weekly from parts that change yearly so the slow part's caution stops throttling the fast part. *Choose when:* release trains exist mainly because one stable subsystem demands heavyweight verification. *Watch out for:* cadence differences that are actually symptoms of missing tests — fix the tests before fracturing.

**4. Team location / time zone.** Split so that each piece is owned within one time zone band; follow-the-sun handoffs inside a single codebase produce miscommunication at the seam. *Choose when:* the org is genuinely multi-site and intends to stay so. *Watch out for:* using geography to avoid fixing a domain split that is wrong everywhere.

**5. Risk.** Separate high-risk-tolerance surfaces (experimental features, growth experiments) from low-risk-tolerance ones (billing, ledger), letting each run an appropriate change process. *Choose when:* one risk regime is imposing its ceremony on everything. *Watch out for:* "risky" used as a euphemism for "untested."

**6. Performance isolation.** Carve out the part with extreme performance or scale needs (a matching engine, a real-time bidder) so it can use specialized technology and tuning. *Choose when:* a hot spot's requirements differ by an order of magnitude. *Watch out for:* premature extraction before a profile proves the hot spot.

**7. Technology.** Split where a genuinely different technology demands different expertise — firmware vs. cloud backend, native mobile vs. web. *Choose when:* the skill sets barely overlap and hiring confirms it. *Watch out for:* this is the most abused plane — frontend/backend/database splits create handoff chains through every feature. Treat technology as a last resort, not a habit.

**8. User personas.** Split by who is served — consumer app vs. enterprise admin vs. internal back-office — when each persona's needs evolve independently. *Choose when:* personas have distinct pace, compliance, or support profiles. *Watch out for:* shared underlying capabilities (identity, billing) still need a home; expect a platform team to emerge.

**Selection summary:**

| Plane | Choose when | Primary risk |
|-------|-------------|--------------|
| Business domain | Default — start here | Contexts drawn from schema, not business |
| Regulatory | Compliance taxes everything | Regulated piece becomes a dumping ground |
| Change cadence | Slow part throttles fast part | Masking a testing gap |
| Location/time zone | Multi-site is permanent | Avoiding the real domain question |
| Risk | One risk regime taxes all | "Risky" = untested |
| Performance | 10x divergent requirements | Premature extraction |
| Technology | Truly disjoint expertise | Recreating layer silos |
| User personas | Independent persona evolution | Shared capabilities left homeless |

**The litmus test for any candidate split:** *could this piece plausibly be offered as a separate service or SaaS, with its own API, docs, and on-call?* If imagining that exposes a tangle of shared state and chatty calls, the seam is wrong — keep looking.

## Exercise: Monolith-to-Team-Ownership Mapping

A one-to-two-day workshop, repeated as needed. Participants: tech leads of affected teams, an architect, a product lead, someone with git-history tooling.

**Step 1 — Inventory capabilities (2-3 hours).** List what the system *does* in business terms (event storming or a capability map both work): "quote a policy", "settle a payment", "generate the picking list". Aim for 20-60 capabilities, written on cards. Ignore module names; they encode the old org.

**Step 2 — Cluster into candidate contexts (1-2 hours).** Group capabilities that share language and change together into 4-10 candidate bounded contexts. Name each in business language. Disagreements about where a card belongs are data — park them on a "contested" list; they usually mark the real seams.

**Step 3 — Score the seams with evidence (2-3 hours, partly offline).** For each pair of adjacent candidate contexts, measure coupling:

- **Change coupling:** from 6-12 months of git history, how often do commits touch both candidates? (Tools: `git log` co-change analysis, CodeScene-style hotspots.) High co-change across a proposed seam = wrong seam or missing third context.
- **Data coupling:** which tables/collections would both sides need? Every shared table is future API or future pain.
- **Runtime coupling:** would a request routinely cross the seam synchronously more than once?

Score each seam red/amber/green. Only green and amber seams are viable near-term splits.

**Step 4 — Overlay teams and cognitive load (1 hour).** Map current teams onto the candidate contexts. Classify each context simple/complicated/complex and apply the allocation heuristics (one complicated domain per team, etc.). This yields the target ownership map — and usually exposes one context too big for any team, which must itself be split before assignment.

**Step 5 — Mark the shared code (1 hour).** List code used by multiple candidate contexts: utility libraries, the auth module, the ORM layer, shared test fixtures. Tag each with its disposition (see shared-code options below). Do not leave any item untagged; untagged shared code defaults to shared ownership, which is the thing being eliminated.

**Step 6 — Choose interaction modes per seam (30 min).** For each dependency in the target map, declare the intended mode: which seams become X-as-a-Service (and need an interface invested in), which need a temporary collaboration during extraction, where an enabling team should assist.

**Step 7 — Sequence (1 hour).** Pick the first one or two extractions by: (a) high change rate (payoff is proportional to change frequency), (b) green seam score, (c) a willing, non-overloaded receiving team. Write down the sequence and the checkpoint dates. Resist sequencing more than two moves ahead — later moves should incorporate what the first ones teach.

**Output:** a one-page target map (contexts → owning teams → interaction modes), a shared-code disposition list, and a two-step sequenced plan.

## Aligning with DDD Bounded Contexts

Fracture planes and Domain-Driven Design are mutually reinforcing: a bounded context — the boundary within which a model and its ubiquitous language stay consistent — is the ideal team-sized unit of software. Practical correspondences:

- **One team per bounded context; a team may own more than one small context** (subject to load heuristics), but a context split across teams fractures its language and model
- **Context maps translate directly to interaction modes:** customer-supplier ≈ X-as-a-Service with a roadmap voice for the consumer; partnership ≈ collaboration (time-box it); conformist ≈ X-as-a-Service where the consumer adapts wholesale; anticorruption layer = the consumer protecting its model — a cheap, often-right default at new seams; shared kernel ≈ shared ownership — treat as a temporary state to engineer away
- **Ubiquitous language is a team API concern:** each team's glossary belongs in its team API page; translation happens at the seams, explicitly

If the org has no DDD practice, the mapping exercise above is a sufficient lightweight substitute; if it has one, reuse its context map as Step 2 input and spend the saved time on Step 3 evidence.

## Handling Shared Code

Every monolith split strands code that multiple contexts use. Four dispositions, in default order of preference:

1. **Single owner.** Assign the code to the team that changes it most (git history settles this); other teams become consumers via an internal package with semver releases. Cheap, honest, works for most utility code.
2. **Platform extraction.** When the shared code is infrastructure-shaped (auth, feature flags, messaging adapters) and several streams need it long-term, move it behind a platform team's product surface with docs, versioning, and support. Costs the most; pays off when consumer count is high.
3. **Inner source with a steward.** The code stays open to PRs from any team, but one named steward team reviews, releases, and owns quality. Suits slow-moving code with occasional cross-team needs. Requires real review capacity in the steward team's budget — unfunded stewardship is shared ownership in disguise.
4. **Duplicate and diverge.** Copy the code into each context and let the copies drift. Heretical and frequently right for small, stable code (validation helpers, DTOs): duplication is cheaper than coordination when the code is cheap and the coordination is not.

Decision guide: high change rate + many consumers → platform extraction; high change rate + few consumers → single owner; low change rate + many consumers → inner source; low change rate + few consumers → duplicate.

## Sequencing a Reorg with the Inverse Conway Maneuver

The inverse Conway maneuver means changing the team structure *first* so the desired architecture becomes the path of least resistance. Sequencing that works:

1. **Sketch the target architecture** at context-map granularity — boxes, owners, interaction modes. Resist detail; teams will discover it.
2. **Design the team topology to match:** team types, sizes against cognitive load, declared interaction modes. This is an architecture document and should be reviewed by the same people who review architecture.
3. **Communicate the why before the what.** Teams that understand "we are reshaping teams to get this architecture" cooperate; teams that experience an unexplained reorg resist by routing around it — and their old communication paths will faithfully rebuild the old architecture.
4. **Move one or two teams at a time.** Re-form the first new team (e.g., the future pricing team) *before* extracting its software, and let the team pull the extraction rather than receiving it.
5. **Re-point the supporting systems immediately:** repos and CODEOWNERS, CI pipelines, on-call rotations, dashboards, cost centers, and chat channels must match the new boundaries within days — every system still wired to the old structure is a Conway force pulling backward.
6. **Declare transition modes:** explicit, end-dated collaboration between the old and new owners of any moved code; facilitation from an enabling team where capability gaps would otherwise stall the move.
7. **Checkpoint on flow evidence:** at +6 and +12 weeks, check cross-team change frequency at the new seams, wait times, and the one-question load survey. Adjust the next move based on what these show.

**Pitfalls:** big-bang reorgs (all boundaries change, nothing works, no one can tell which change caused what); renaming teams without changing ownership (the communication paths — and therefore the architecture — stay exactly where they were); splitting the code but keeping one shared database (the monolith survives in the schema and every "service" still coordinates through it); and leaving incentives unmoved (if managers are still rewarded for component throughput, components are what you will get).
