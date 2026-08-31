# Case Studies: Team Topologies in Practice

## Table of Contents

- [Case Study 1: A Scale-Up Drowning in Cross-Team Dependencies](#case-study-1-a-scale-up-drowning-in-cross-team-dependencies)
- [Case Study 2: Converting a Bottleneck Ops Team into a Platform-as-Product Team](#case-study-2-converting-a-bottleneck-ops-team-into-a-platform-as-product-team)
- [Case Study 3: Splitting a Monolith Along Fracture Planes](#case-study-3-splitting-a-monolith-along-fracture-planes)
- [Key Takeaways](#key-takeaways)

## Case Study 1: A Scale-Up Drowning in Cross-Team Dependencies

### Context

A 40-engineer logistics SaaS scale-up serves shippers and carriers. Teams are organized by technology: frontend (8), backend (12), mobile (5), QA (6), data/DBA (4), and a "DevOps team" (5) that owns CI/CD and infrastructure. Product managers coordinate features across all six teams.

### The Problems

**Every feature crossed four to five teams.** A typical feature — "let carriers set availability windows" — needed backend endpoints, frontend screens, mobile screens, QA test cycles, and a DevOps ticket for a new queue. Lead time averaged nine weeks, of which roughly two were active work.

**Coordination had become the main job.** A weekly "dependency sync" with 14 attendees managed a spreadsheet of 60+ open cross-team dependencies. Two delivery managers existed purely to chase blocked tickets.

**Quality was nobody's problem.** Backend considered features done at API merge; QA found integration breaks two weeks later; on-call belonged to DevOps, who could restart services but not fix them. Incident retros assigned actions to four teams and none completed.

**The architecture mirrored the org — exactly.** One shared backend monolith with module boundaries matching backend sub-guilds, one shared mobile app, and a CI system only the DevOps team could change. Conway's law was operating, unmanaged.

### The Redesign

**Step 1: Map streams of change (week 1).** Six months of shipped features were sorted by who they served. Three clear streams emerged: shipper booking experience, carrier operations, and billing/settlement. A fourth cluster of work — pipelines, environments, observability — served other teams, not end users.

**Step 2: Design the target topology (week 2).** Four stream-aligned teams (shipper web, carrier web+mobile, billing, and tracking/visibility — added after change-coupling analysis showed tracking changed independently), each 6-8 people and cross-functional: frontend, backend, and embedded QA together. One platform team formed from DevOps plus two backend infrastructure specialists. The QA team dissolved into streams, with the two most senior testers forming a temporary enabling pair for test automation. Cognitive-load check: each stream got one complicated domain at most.

**Step 3: Declare interaction modes (week 2).** Streams ↔ platform: X-as-a-Service for CI/CD and environments, with one declared exception — an eight-week collaboration between the platform team and the carrier team to co-design the new deployment pipeline, the platform's first product iteration. Enabling pair ↔ each stream: facilitating, six weeks per stream, exit criteria written down.

**Step 4: Move ownership artifacts (weeks 3-4).** Repos re-partitioned with CODEOWNERS per stream; on-call moved to streams ("you build it, you run it") with the platform team providing paved-road observability; the dependency spreadsheet and the 14-person sync were deleted on day one of the new structure — deliberately, to remove the safety net that would have preserved old habits.

**Step 5: Checkpoint (weeks 10 and 18).** Flow metrics reviewed; one boundary corrected (tracking absorbed a notification component originally left with billing, after change-coupling data showed it moved with tracking work).

### Results After 5 Months

| Metric | Before | After |
|--------|--------|-------|
| Lead time (median feature) | 9 weeks | 2.5 weeks |
| Teams touched per feature (median) | 4-5 | 1 |
| Open cross-team dependencies | 60+ tracked | 8, all declared modes |
| Deploys per week (org total) | 3 (batched) | 40+ (per-team) |
| Coordination meetings | 6 hrs/week/lead | 1 hr/week/lead |
| Change failure rate | ~28% | ~12% |

### Lessons Learned

1. **Streams were discovered, not invented.** Sorting six months of actual shipped work revealed the streams; designing from the org chart or the architecture diagram would have reproduced the existing silos.
2. **Embedded QA outperformed the QA gate immediately,** but only because the enabling pair existed — streams lacked test-automation skills, and without facilitation the embedded testers would have become four isolated manual-test bottlenecks.
3. **Deleting the dependency spreadsheet was the highest-leverage act.** While it existed, it legitimized cross-team dependencies; without it, a dependency became an exception requiring a declared interaction mode.
4. **One boundary was wrong, and that was fine.** The checkpoint cadence made correcting it routine rather than an admission of failure.

## Case Study 2: Converting a Bottleneck Ops Team into a Platform-as-Product Team

### Context

A 120-engineer fintech runs a central operations team of nine. All infrastructure work — environments, deployments, DNS, certificates, database changes, monitoring — flows through their ticket queue. The ops team is skilled, overworked, and increasingly resented.

### The Problems

**A three-week ticket queue throttled every stream.** Median time to get a new test environment: 16 days. Teams padded sprints with whatever wasn't blocked, inflating WIP everywhere.

**Shadow infrastructure was spreading.** Two product teams had quietly acquired their own cloud accounts on company cards. Security found out during an audit.

**The ops team was burning out.** Five hundred tickets a month, an oncall that paged nightly for systems they didn't write, and no time for the automation they kept proposing. Two of nine had resigned in the previous quarter.

**Mandates were masking failure.** Use of the central deployment tool was mandatory, so its 40-minute, frequently-flaky pipeline had no competitive pressure to improve — complaints were compliance problems, not product feedback.

### The Conversion

**Step 1: Classify the queue (weeks 1-2).** All tickets from the previous quarter were sorted into: automatable (62% — environments, deploys, DNS, certs), teachable (23% — debugging help, config questions), and should-stop (15% — work for systems that had owners). This became the platform roadmap, the enabling backlog, and a stop-doing list respectively.

**Step 2: Define the Thinnest Viable Platform (week 3).** Not a portal, not a Kubernetes abstraction — a single paved road for the top ticket type: self-service ephemeral environments via one CLI command, documented on one page. The team explicitly deferred everything else.

**Step 3: Staff it like a product (week 3).** A product manager was assigned from the product org — the single most contested decision, and later rated the most important. She ran user interviews with eight teams in the first month. Two ops engineers moved into a temporary enabling duo focused on teaching streams to own their own on-call.

**Step 4: Collaborate with first consumers (weeks 4-10).** Two pilot streams adopted environments-as-a-service in a declared six-week collaboration; their friction reports drove daily fixes. After the pilots, the capability went org-wide as X-as-a-Service — docs, office hours, versioned CLI.

**Step 5: Make adoption optional, visibly (week 11).** The deployment-tool mandate was revoked. Teams could use anything that passed the security baseline. This was the platform team's forcing function: capabilities now survived only if chosen.

**Step 6: Drain the queue (weeks 11-24).** Deploys and DNS followed environments onto the paved road. Stream on-call ownership transferred team by team with facilitation. The should-stop 15% was returned to system owners with management backing.

### Results After 6 Months

| Metric | Before | After |
|--------|--------|-------|
| New test environment | 16 days (ticket) | 25 minutes (self-service) |
| Ops/platform ticket volume | ~500/month | ~90/month |
| Deployment pipeline duration | 40 min, flaky | 12 min, 99% pass |
| Voluntary platform adoption | n/a (mandated) | 14 of 16 teams |
| Ops team pages per week | ~35 | ~9 (platform services only) |
| Shadow cloud accounts | 2 known | 0 (pilots migrated back) |

### Lessons Learned

1. **The ticket queue was the requirements document.** Classifying real demand beat any platform vision exercise; the team built what was already being asked for 500 times a month.
2. **Optional adoption changed the platform team's behavior more than the consumers'.** Within weeks the team was writing release notes, fixing onboarding friction, and deprecating features nobody used — product behaviors no mandate had ever produced.
3. **The product manager mattered more than any technology choice.** User interviews killed two planned capabilities that no team actually wanted and surfaced the certificate-automation need nobody had ticketed (they had given up asking).
4. **Burnout fell when the pager matched ownership.** Ops pages dropped 70% once streams owned their services' on-call — and streams' pages were tolerable because they could actually fix what paged them.

## Case Study 3: Splitting a Monolith Along Fracture Planes

### Context

An insurance company's policy administration system: a 15-year-old monolith, 70 engineers in component teams (policy core, batch, integration, UI, DBA), quarterly release train with a six-week regression phase. The board wants monthly releases and a new usage-based product line the monolith cannot price.

### The Problems

**One release train coupled everything.** A one-line pricing change waited up to four months for the next train. Each release bundled hundreds of changes; each regression phase found cross-component breakage.

**Regulatory scope taxed every change.** Solvency reporting requirements subjected the whole monolith to change-control sign-off, though only a fraction of the code computed regulated figures.

**Pricing actuaries and engineers worked at cross purposes.** Pricing logic — the fastest-changing, most revenue-relevant code — was smeared across policy core and batch components, owned by no one.

### The Split

**Step 1: Capability inventory and clustering (weeks 1-2).** An event-storming workshop produced 47 capabilities, clustered into six candidate contexts: quote & pricing, policy lifecycle, claims intake, solvency & regulatory reporting, document generation, and partner integration.

**Step 2: Choose fracture planes deliberately (week 2).** Business domain was the default plane, with two exceptions argued from evidence: solvency reporting split on the *regulatory* plane (isolating change-control to one context), and quote & pricing justified also by the *change cadence* plane — git history showed it changed 6x more often than policy lifecycle. Seam scoring flagged one red seam (policy lifecycle ↔ document generation shared 31 tables); document generation was deferred to phase two rather than forced.

**Step 3: Inverse Conway — form the team first (week 4).** A pricing team (7 people: engineers from policy core and batch plus two actuarial analysts) was formed *before any code moved*, owning the pricing domain in the monolith. For six weeks they shipped pricing changes within the old structure, building shared language — and the case for extraction.

**Step 4: Extract with declared modes (weeks 10-26).** Pricing was extracted strangler-style behind an internal API. Modes were explicit: pricing ↔ policy-core teams in collaboration for eight weeks to define the quote interface, then X-as-a-Service with a versioned contract; a two-person enabling pair facilitated the policy teams' adoption of consumer-driven contract tests; the DBA team's two members joined pricing and reporting respectively, dissolving the shared-database gate. Each extracted context took its tables with it.

**Step 5: Decouple the trains (week 27 on).** The pricing service moved to weekly releases against its contract-test suite. The regulated reporting context kept formal change control — now scoped to 9% of the codebase. The monolith remainder stayed quarterly, by choice, pending phase two.

### Results After 9 Months

| Metric | Before | After |
|--------|--------|-------|
| Pricing change lead time | up to 4 months | 1-2 weeks |
| Code under regulatory change-control | 100% | ~9% |
| Release cadence | quarterly (everything) | weekly (pricing), quarterly (core, by choice) |
| Regression phase | 6 weeks, all hands | 2 weeks, core only |
| Cross-team commits at pricing seam | n/a | <3% of pricing commits |
| New usage-based product | not feasible | priced and piloted |

### Lessons Learned

1. **Two planes beat one.** Domain alone would not have freed pricing from the audit regime; the regulatory plane carved the change-control boundary, and cadence evidence prioritized which context to extract first.
2. **Forming the team before extracting the code made the extraction pull-based.** The pricing team extracted a service they already owned conceptually — scope debates that normally stall such projects were settled inside one team.
3. **Red seams are schedule information.** Deferring document generation (31 shared tables) avoided spending the first phase on the hardest, lowest-value boundary.
4. **Not everything must speed up.** Leaving the monolith remainder on a quarterly cadence was a legitimate topology decision, not a failure — flow was needed at the pricing seam, not uniformly.

## Key Takeaways

**1. Evidence beats opinion at every step.** Shipped-work sorting, ticket classification, and git change-coupling located streams, platform scope, and seams. Every failed reorg these teams had previously attempted started from an org-chart drawing instead.

**2. The sequence is: team first, then code, then cadence.** All three cases moved ownership and communication paths before (or while) moving software — the inverse Conway maneuver in practice. Code-first splits leave old communication structures intact, and the old architecture grows back.

**3. Declared interaction modes did the quiet work.** Time-boxed collaboration, then X-as-a-Service, appears in all three cases as the mechanism that made new boundaries real — and the deletion of generic coordination rituals (dependency syncs, ticket queues, release trains) is what made the declared modes binding.

**4. Optionality and exit criteria keep supporting teams honest.** The platform survived because adoption was voluntary; enabling engagements worked because they ended. Mandates and permanent helpers would have rebuilt the bottlenecks under new names.

**5. Topologies stayed under review.** Each org corrected at least one boundary within months, cheaply, because checkpoints and sensing signals (friction, wait times, on-call pain) were scheduled from the start. The design assumption was evolution, not a final answer.
