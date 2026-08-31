# The Four Team Types in Depth

Team Topologies restricts organizations to four fundamental team types. The restriction is the point: when every team is one of four well-understood types, every other team knows what to expect from it, gaps and overlaps become visible, and "miscellaneous" teams that quietly accumulate unowned work cannot hide. This reference covers each type's responsibilities, staffing, success metrics, and failure modes, then gives procedures for converting existing teams and a decision guide for classifying ambiguous ones.

## Stream-Aligned Teams

A stream-aligned team is aligned to a single, valuable stream of work: a product, a service, a user journey, a user persona, or a market segment. It is the primary team type — the other three exist only to reduce its load. In a healthy organization, the large majority of teams are stream-aligned (rough guide: six to nine stream-aligned teams for every other-type team).

**Responsibilities:**

- Own a slice of business change end to end: discovery, design, build, test, deploy, operate, support, and retire
- Ship safely, independently, and frequently without requiring handoffs to other teams
- Stay close to users: consume usage data, run experiments, talk to customers
- Carry the on-call rotation for what they build ("you build it, you run it")
- Continuously improve their own flow: reduce batch size, shorten feedback loops

**Staffing:** Cross-functional by definition. The team must contain — not have access to, contain — the capabilities its stream requires: application development, design/UX where relevant, testing and quality, operability and infrastructure literacy, security awareness, and product/metrics literacy. Typical size 5-9 people. Not every member is a specialist in everything; the team as a whole covers the set.

**Success metrics:** Flow of change. The four key metrics from *Accelerate* work well: deployment frequency, lead time for changes, change failure rate, and time to restore service. Add team health (regular survey) and the cognitive-load check ("can you respond effectively and in a timely fashion to the work you are asked to do?").

**Failure modes:**

- **Feature team in disguise** — builds features but throws them over a wall to ops or QA; the handoff makes it a component team with extra steps
- **Too many domains** — three products and a legacy system on one team; ownership goes shallow and reactive
- **Starved of operability skills** — "cross-functional" on paper, but no one can debug production, so an ops team gets pulled in for every incident
- **Backlog colonization** — other teams or stakeholders inject work directly, destroying the team's ability to manage its own flow

## Enabling Teams

An enabling team grows capabilities in stream-aligned teams. It is composed of specialists in a given technical or product domain who actively research ahead of need, then bridge the gap — through pairing, coaching, and short engagements — so stream-aligned teams acquire the capability without halting delivery to learn it from scratch.

**Responsibilities:**

- Understand the obstacles and missing capabilities of stream-aligned teams (by asking and observing, not by audit)
- Research new methods, tools, and practices before streams need them
- Run time-boxed engagements that transfer capability: pairing, workshops, starter kits, curated guidance
- Promote learning across teams: write up findings, maintain internal guidance, connect teams with similar problems
- Disengage on schedule and verify the capability stuck

**Staffing:** Senior practitioners with strong coaching instincts. The job is making other teams better, not being the best in the room. Small teams (2-5) are typical. People who need to own production systems to feel useful are a poor fit.

**Success metrics:** Capabilities transferred and engagements exited on time. Concretely: the stream team performs the practice unaided N weeks after exit; engagement NPS from the stream team; lead-time or quality improvement in the streams served. Never tickets closed, and never lines of code delivered into stream codebases.

**Failure modes:**

- **Permanent dependency** — the engagement never ends; the enabling team becomes a shared-services bottleneck wearing a nicer name
- **Doing instead of teaching** — the specialists implement the capability themselves; the stream learns nothing and the work decays after exit
- **Ivory tower** — produces standards documents and tech radars no stream asked for; measured by output, not uplift
- **Gatekeeping** — drifts into approval workflows ("all designs must be reviewed by..."), which inverts its purpose

## Complicated-Subsystem Teams

A complicated-subsystem team owns a part of the system that depends on deep specialist knowledge — heavy mathematics, machine learning, audio/video codecs, real-time trading logic, low-level hardware interfacing. The split exists to spare stream-aligned teams from having to grow and retain rare expertise, not to centralize anything that merely looks hard.

**Responsibilities:**

- Build and run the specialist subsystem behind the simplest possible interface
- Hide internal complexity: consumers should integrate in days, not quarters
- Prioritize according to the needs of the streams that consume the subsystem
- Keep the subsystem's scope tight; resist absorbing adjacent "hard" work

**Staffing:** A small number of genuine specialists (often PhD-level or long-tenured domain experts) plus engineers who productize their work. This is the rarest type — most organizations need zero or one.

**Success metrics:** Subsystem quality and the integration experience of consuming teams: correctness/performance of the subsystem, time for a stream team to integrate, and absence of the subsystem from stream teams' incident causes.

**Failure modes:**

- **Scope creep** — becomes "the hard problems team" and accumulates unrelated complexity, recreating a component-team bottleneck
- **Genius silo** — knowledge concentrated in one or two heads; no productization, so every consumer needs a meeting
- **Created by vanity** — formed because the technology is fashionable, not because the cognitive load is real; the test is whether stream teams could plausibly own it themselves

## Platform Teams

A platform team provides internal services and tooling that reduce the cognitive load of stream-aligned teams: deployment pipelines, environment provisioning, observability, identity, data infrastructure. The defining stance is *platform as a product*: internal teams are customers who choose to adopt it because it is the easiest, safest path — a paved road, not a toll gate.

**Responsibilities:**

- Provide self-service capabilities with clear APIs, docs, and onboarding — consumable without filing a ticket
- Treat developer experience as the product's UX: research user needs, watch teams use the platform, fix friction
- Publish a roadmap, SLAs, versioning and deprecation policies; support what is shipped
- Curate as much as build: a Thinnest Viable Platform can be a wiki page of vetted services and how to use them
- Measure adoption and load removed, not features shipped

**Staffing:** Engineers with strong product sensibility plus an actual product manager (this role is routinely skipped and routinely fatal to skip). Platform groups in larger orgs are themselves composed of stream-aligned-style teams per platform capability, fronted by one coherent platform experience.

**Success metrics:** Voluntary adoption rate; time-to-X for streams (time to first deploy, time to new environment, time to onboard a service); developer experience survey scores; reduction in stream-team extraneous load (fewer tools each stream must master); platform reliability against published SLAs.

**Failure modes:**

- **Mandate instead of merit** — adoption enforced by policy; quality feedback disappears and the platform decays into bureaucracy
- **Ops rebadged** — the old ticket queue with a new name; nothing is self-service
- **Build-it-and-they-will-come** — a year of platform construction with no internal user research; streams keep their shadow tooling
- **Bottomless scope** — the platform tries to serve every conceivable need; cognitive load moves into the platform team instead of being removed from the system

## Converting Existing Teams

Most adoptions of Team Topologies start from an existing org chart, not a blank page. Common conversions:

### Component team → stream-aligned team

1. **Identify the streams** the component currently serves and the change types it receives (use 6-12 months of ticket/PR history)
2. **Choose a destination per person, not per team** — component specialists usually disperse into the stream-aligned teams that consumed their component most
3. **Re-home the component itself:** give it one owning team (the stream that changes it most), extract it to the platform if several streams genuinely share it, or schedule it for absorption/deletion
4. **Run a transition period** with an explicit collaboration mode between old members and receiving teams (4-8 weeks), then dissolve the old channel and queue
5. **Verify with flow metrics:** cross-team tickets touching the old component should approach zero

### SRE/ops team → platform team or enabling team

Decide which based on what the org needs removed: if streams need *services* (pipelines, environments, observability), convert to a platform team; if streams need *skills* (operability, incident response, SLO thinking), convert to an enabling team. Often it is both, in sequence — enable first, productize the recurring needs second.

1. Inventory the ticket queue; classify each recurring request as automate (platform candidate), teach (enabling candidate), or stop doing
2. Stand up self-service for the top two or three request types before closing the queue
3. Move stream on-call responsibility to streams gradually, with facilitating support
4. Assign a product manager and publish the platform's team API
5. Track queue volume: it should trend toward zero as self-service and capability take over

### QA team → embedded + enabling

Disband the central gate; embed test-minded engineers into stream-aligned teams; keep a small enabling team that raises testing capability across streams for a few quarters, then re-evaluate whether it is still needed.

### Architecture team → enabling (mostly)

Standing architecture boards that approve designs are queue-based gatekeepers. Convert architects into a small enabling group that works *with* teams part-time, plus participation in topology design itself — deciding team boundaries is now a core architecture activity.

## Decision Guide: Which Type Is This Team Really?

Ask in order; the first "yes" usually classifies the team:

1. **Does the team own a slice of business value end to end, with its own users?** → Stream-aligned
2. **Do other teams consume what this team provides via self-service or an API?** → Platform (if via tickets and meetings instead: a shared-services team that needs converting)
3. **Is the team's main output other teams getting better at something, with engagements that end?** → Enabling (if engagements never end: a dependency, not an enabler)
4. **Does the team own a subsystem that genuinely requires rare specialist knowledge?** → Complicated-subsystem (if the knowledge is ordinary: a component team that should dissolve into streams)
5. **None of the above?** → It is a coordination artifact (project team, "alignment" team, ticket router). Plan its conversion or dissolution.

Cross-checks that catch common misclassifications:

| The team says | It is probably | Because |
|---------------|----------------|---------|
| "We build features, another team deploys them" | Component team, not stream-aligned | End-to-end ownership is missing |
| "We're the platform team" (but work arrives as tickets) | Shared services, not platform | No self-service product exists |
| "We help other teams" (engagement has lasted 2 years) | Dependency, not enabling | Capability transfer never completes |
| "Our system is too complex for normal teams" | Possibly component team | Test the specialism claim against hiring reality |
| "We own the API layer / the database / the frontend" | Component team | Technology layer, not a stream or true subsystem |

When in doubt, classify by *cognitive load effect*: a team that reduces other teams' load while staying out of their critical path is platform or enabling; a team that sits in other teams' critical path is either stream-aligned (fine) or a bottleneck (fix).
