# Assessing and Managing Team Cognitive Load

Cognitive load is the limiting reagent of team performance: a team can only build and run well what it can collectively hold in its head. Team Topologies makes load a first-class design input — software is sized to teams, domains are allocated against explicit heuristics, and overload is detected early rather than discovered through attrition. This reference covers how to assess load in practice, the team API template that reduces inter-team load, domain-allocation heuristics, and the warning signs of overload.

## The Three Types of Load, Applied to Teams

Borrowed from Sweller's cognitive load theory and reinterpreted at team scale:

- **Intrinsic load** — the skill demands inherent in the work itself: the languages, frameworks, and core technical knowledge needed to do the job at all. *Managed by hiring, training, and pairing — not eliminable, but plannable.*
- **Extraneous load** — the mechanics that surround the work but add no product value: flaky environments, manual deployments, undocumented internal services, ticket queues, six observability tools. *The first target: minimize aggressively via platforms, paved roads, and automation.*
- **Germane load** — the valuable thinking: the business domain, the users, the design trade-offs. *This is what you are buying when you fund a team; protect and maximize it.*

The design goal: spend the team's finite capacity on germane load. Every hour spent fighting environments or deciphering another team's undocumented API is capacity the org paid for and then burned.

## Assessing Team Cognitive Load in Practice

### Start with the one question

The book's simple instrument, asked of the whole team anonymously:

> "Do you feel like you're effective and able to respond in a timely fashion to the work you are asked to do?"

Scale of 1-5. Anything averaging below 4, or with a wide spread, warrants the deeper assessment below. Re-ask quarterly; the *trend* matters more than the absolute number.

### Survey instrument (10 questions, 1-5 agree/disagree)

1. I understand all the parts of the system my team owns well enough to change them confidently.
2. I can get a change to production without waiting on another team.
3. Our tooling and environments mostly stay out of my way.
4. I know who to ask (or where to look) when I need something from another team — without a meeting.
5. On-call for our services feels manageable and fair.
6. I have time to learn the domain, not just close tickets.
7. We rarely context-switch between unrelated domains in the same week.
8. New joiners become productive on our team within a few weeks.
9. The number of technologies our team must master feels reasonable.
10. We have slack to improve our own tooling and pay down debt.

Scores of 1-2 cluster diagnostically: low 1/7/9 → too many or too-complex domains; low 2/4 → boundary/interaction problems; low 3/10 → extraneous load, platform gap; low 5 → on-call scope exceeds team scope.

### Count and classify domains

The most decision-relevant assessment is a structured inventory:

1. List every distinct domain of responsibility the team owns — subsystems, products, significant components, recurring duty areas (e.g., "payments reconciliation", "the legacy reporting stack", "GDPR exports").
2. Classify each as **simple** (well-understood, low change, good docs), **complicated** (needs expertise but is analyzable; most established subsystems), or **complex** (high uncertainty, much experimentation: new products, novel tech).
3. Apply the allocation heuristics (next section) and compute the gap.

Most "underperforming" teams turn out to be over-allocated, not under-skilled.

### Measurable proxies

Pull these from existing systems rather than asking:

- **On-call scope:** services per rotation, pages per week, fraction of pages the responder could actually fix. A team paged for systems it cannot change carries pure extraneous load.
- **Tooling sprawl:** distinct languages, frameworks, and operational tools the team touched in the last quarter (repo + CI history shows this).
- **WIP and interrupt rate:** concurrent workstreams per person; fraction of sprint work that arrived mid-sprint.
- **Wait-time map:** for one representative change, hours of active work vs. days of elapsed time; long waits on other teams indicate boundary or mode problems rather than load per se — but teams compensate for waiting with more WIP, which *becomes* load.

## Domain-to-Team Allocation Heuristics

From the book, used as hard defaults rather than aspirations:

1. **One team per domain.** A domain split across two teams produces shared ownership of the seam; both teams slow down.
2. **A team can hold 2-3 simple domains** alongside its main work — but beware: simple domains still cost context-switches.
3. **At most one complicated domain per team.** Two complicated domains do not fit in one collective working memory, even when each looks "only medium-sized" — and do not split one complicated domain across two teams to compensate; transfer one whole domain instead.
4. **A complex domain gets a dedicated team** — and that team should hold *at most* one simple domain besides, preferably none.
5. **Don't allocate a complex and a complicated domain to the same team.** The complicated domain's deadlines will always win, and the complex domain's experimentation will quietly stop.

**Worked example.** A 4-team group owns 9 domains: checkout (complex — new market), payments (complicated), catalog (simple), search (complicated), promotions (simple), the legacy ERP bridge (complicated), invoicing (simple), notifications (simple), and an internal admin portal (simple).

| Team | Allocation | Check |
|------|-----------|-------|
| Team A | checkout (complex) | OK — dedicated; nothing else |
| Team B | payments (complicated) + invoicing (simple) | OK — one complicated + one simple |
| Team C | search (complicated) + notifications (simple) | OK |
| Team D | ERP bridge (complicated) + catalog, promotions (simple) | At limit — watch the survey |
| Unassigned | admin portal (simple) | Candidate for platform absorption or deletion |

The exercise routinely surfaces a remainder like that admin portal — unowned or everywhere-owned software is itself a load source and should be explicitly re-homed, platformized, or retired.

## The Team API Template

A team API treats the team itself as having an interface: everything other teams need in order to interact without a meeting. It reduces *other* teams' extraneous load and protects this team's focus. Publish it where engineers actually look (repo root, internal wiki) and review it quarterly.

```markdown
# Team API: <team name>

_Last reviewed: <date> · Next review: <date>_

## Identity
- Team type: stream-aligned | enabling | complicated-subsystem | platform
- Mission: <one sentence: the stream of change or capability this team exists for>
- Time zone(s) & working hours: <e.g., CET, core hours 10:00-16:00>

## What we own
- Domains: <list, each tagged simple/complicated/complex>
- Services & repos: <name → link, one line each, incl. production status>
- Dashboards & runbooks: <links>

## What we provide to other teams
- <capability/API/service> → docs: <link>, support: <channel>, SLA: <statement>

## How to engage us
- Chat channel: <#channel> (default; we answer within <N> working hours)
- Requests for work: <how — e.g., issue template link>; triaged <cadence>
- Office hours: <when/where>
- Do NOT: <e.g., DM individual engineers for production requests>

## Current interaction modes
- <Team X>: collaboration — <purpose>, ends <date>
- <Team Y>: X-as-a-Service — we consume <their service>
- <Team Z>: facilitating — they coach us on <capability>, ends <date>

## On-call & escalation
- Rotation: <link>; what we are paged for: <scope>
- Escalation: <named role> → <named role>

## Roadmap & priorities
- Now / next / later: <link>
- What we are explicitly NOT doing this quarter: <list>

## Working agreements
- <e.g., trunk-based development; PRs reviewed within 24h; no deploys after 16:00 Friday>
```

The "Do NOT" and "NOT doing this quarter" lines do disproportionate work: they convert recurring boundary skirmishes into a published, reviewable decision.

## Warning Signs of Overload

Watch for these before the survey says it out loud:

- **Perpetual looking-it-up:** the team owns code no member can explain without reading it first — ownership has gone shallow
- **Improvement work always slips:** every retro action item dies; debt items are bumped every sprint for three months
- **Rising WIP:** people run 3-4 concurrent tasks to mask wait states
- **Defensive planning:** the team pads estimates and resists any new scope, even trivial — a rational response to hidden load
- **On-call dread:** pages routinely require waking a second specific person; vacation handovers take days of prep
- **Hero dependence:** one person is on every incident call; bus factor of 1 on a complicated domain
- **Quality oscillation:** incident clusters after each delivery push, then a freeze, then another cluster
- **Recruiting can't keep up:** the team believes "we just need more people" — but new joiners take quarters to be useful because the domain set is too broad

**Responses, in order of preference:**

1. **Shed domains** — transfer a whole domain to another team or a platform (fastest, most effective)
2. **Cut extraneous load** — adopt platform services, delete bespoke tooling, automate the top recurring toil item
3. **Split the software, then the team** — if one domain has outgrown any single team, split it along a fracture plane into team-sized pieces first
4. **Add people last** — and only within Dunbar limits (~9); beyond that, you are creating two teams and should design them deliberately

Headcount as the first response is the classic mistake: it raises coordination load immediately and only dilutes domain load after months, if ever.
