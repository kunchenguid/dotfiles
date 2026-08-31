# Case Studies: Cold Start Principles in Practice

## Table of Contents

- [Case Study 1: A B2B Collaboration Tool Finds Its Atomic Network](#case-study-1-a-b2b-collaboration-tool-finds-its-atomic-network)
- [Case Study 2: Seeding a Local-Services Marketplace in One City](#case-study-2-seeding-a-local-services-marketplace-in-one-city)
- [Case Study 3: A Social App Recovers from a Big-Bang Launch](#case-study-3-a-social-app-recovers-from-a-big-bang-launch)
- [Key Takeaways](#key-takeaways)

## Case Study 1: A B2B Collaboration Tool Finds Its Atomic Network

### Context

An eight-person startup builds an async standup and status tool, positioned "for modern engineering organizations." A directory launch and some press produce 2,400 signups in the first month. The team celebrates, then watches the retention chart.

### The Problems

**Almost everyone arrived alone.** 86% of signups came in with no teammates. They landed in an empty workspace, posted a status update nobody would read, and left. The product's entire value — seeing what your team is doing — was structurally impossible for them.

**Activation was measured at the wrong level.** The team tracked "completed onboarding" (62% — looked great) while "invited 2+ teammates" sat at 9% and nobody owned it. Week-4 retention was 4%.

**Sales chased the wrong unit.** Outbound targeted VPs of engineering at 500-person companies. Pilots stalled in procurement for months while the product sat unused — the company was selling to a market while the product needed a network.

### The Application

**Step 1: Define the atomic network.** Interviews with the handful of retained accounts showed the live unit was never a company. It was a single pod: a team lead plus four to eight engineers who already ran a daily standup ritual and merely wanted it async. The atomic network was defined as "one team where 4+ members post on 3+ days per week."

**Step 2: Identify the hard side.** One person per pod did the work: the team lead who set the tool up, configured prompts, and nagged everyone to post. Their motivations were utility (kill the standing meeting) and status (look organized to their own manager). The roadmap was rebuilt for the lead first: one-click setup, a blockers digest, and an auto-generated weekly summary the lead could forward upward.

**Step 3: Define and instrument the magic moment.** "A standup where every member posts before 11am and the lead reacts to at least one update." Data check: teams with three consecutive such standups in week one retained at five times the rate of other teams. That became the network-level activation bar on a per-pod dashboard with live/forming/dead statuses.

**Step 4: Rebuild onboarding around the network.** Signup now asks for the team by name and email up front (graph capture), and the first-run experience is built for inviting the pod. For leads who genuinely arrive alone, a single-player fallback — a personal work journal that compiles a weekly self-report — delivers standalone value while they recruit.

**Step 5: Flintstone the first pods.** Founders joined the first 40 workspaces as visible "facilitators": posting prompt questions, modeling good updates, and personally onboarding every member. Manual, unscalable, and decisive — these pods set the usage patterns the templates were later copied from.

**Step 6: Sequence expansion by adjacency.** A company "tips" when three or more pods are live; at that point the lead's peer teams are the next targets, and a cross-pod dashboard (the org-level product) is offered to engineering managers — the economic step.

### Results After 4 Months

| Metric | Before | After |
|--------|--------|-------|
| Network-level activation | 9% invited anyone | 47% of new workspaces reach 4+ active members |
| Week-4 retention | 4% of users | 58% of activated pods still active |
| Weekly active pods | Not measured | 212 |
| Multi-pod companies | 0 | 31 with 3+ live pods |
| Founder flintstoning time | 0 | 15 hrs/week at start → 3 hrs/week by month 4 |

### Lessons Learned

1. The atomic network was smaller and more specific than anyone guessed — not a company, not a department, but a pod with an existing ritual to replace.
2. User-level activation metrics hid everything; the pod-level bar made dead workspaces visible in one glance.
3. The single-player journal looked like a distraction and was the bridge that kept solo leads alive long enough to assemble their pods.
4. The hard side wasn't paid in money. The forwardable weekly summary — status with their own manager — retained leads better than any feature shipped that quarter.

## Case Study 2: Seeding a Local-Services Marketplace in One City

### Context

A home-cleaning marketplace raises $1.2M and launches in three cities simultaneously, splitting the marketing budget evenly. The model: customers book online, vetted cleaners accept jobs, the platform takes 20%.

### The Problems

After eight weeks: fill rate 38%, median time-to-match 19 hours, and 41% of first-time customers never returned — most had experienced a no-match or a next-day response to a same-week need. Cleaners were churning too: with demand spread thin, the median provider got two jobs a week, far below what justified keeping the app on their phone. Paid CAC was climbing as bad reviews accumulated. Both sides were starving in all three cities at once — three sub-atomic networks, each generating anti-network effects.

### The Application

**Step 1: Retreat to one city, then one zone.** A selection scorecard (provider availability, density potential, competitive gap, ops reach) picked the strongest city — not the largest — and constrained the relaunch further to four contiguous zip codes.

**Step 2: Pre-commit supply.** Thirty-five vetted cleaners signed before relaunch: $25/hour guaranteed for eight weeks plus a fee holiday, in exchange for defined availability windows and a two-hour response SLA. The taper was published in the contract: the guarantee steps down as utilization crosses 60%.

**Step 3: Throttle demand to supply.** Paid acquisition was geofenced to the four zips and capped so fill rate stayed above 85%. Customers elsewhere hit a waitlist: "We'll text you when your zip code opens." Marketing protested; the founders held the cap.

**Step 4: Flintstone operations.** Founders dispatched edge cases manually, handled every reschedule, and called each customer after their first clean. Every manual fix was logged as a requirement for the matching system.

**Step 5: Gate expansion on liquidity bars.** Written definition of "tipped": fill rate above 85% for two consecutive weeks, time-to-match under two hours, 30-day repeat rate above 45%, and a guarantee gap at zero. Adjacent zips opened only when the current zone held all four bars.

**Step 6: Codify the launch kit.** Seeding sequence, subsidy levels, taper schedule, geofence caps, and dispatch scripts were written up and rerun in city #2 by one ops hire.

### Results After 6 Months

| Metric | 3-City Launch (Week 8) | One-Zone Relaunch (Week 8) | City #2 via Kit (Week 8) |
|--------|------------------------|----------------------------|--------------------------|
| Fill rate | 38% | 91% | 87% |
| Median time-to-match | 19 h | 1.4 h | 1.9 h |
| 30-day repeat rate | 22% | 51% | 48% |
| Median provider jobs/week | 2 | 9 | 8 |
| Guarantee cost per booking | — | $11 → $2 | $6 → $1 |
| Cost to tip the market | Never tipped | $86K | $52K |

### Lessons Learned

1. Throttling demand felt insane and was the highest-leverage decision: every early customer landed on full shelves, and repeat rate — not signups — is what compounds.
2. Supply pre-commitment turned launch from a gamble into logistics; day one had inventory because it was signed before marketing spent a dollar.
3. The published taper prevented a provider revolt at step-down — cleaners had priced it in, and by then organic demand had closed the gap.
4. The playbook compounded: city #2 tipped 40% cheaper and faster, with zero founder dispatching. The durable asset of the relaunch was the kit.

## Case Study 3: A Social App Recovers from a Big-Bang Launch

### Context

A social app for runners — activity sharing plus local route and crew discovery — lands a press exclusive and an influencer campaign. 340,000 installs in 17 days. Champagne, then silence.

### The Problems

**The cohort died on arrival.** D1/D7/D30 retention: 31% / 9% / 2.8%. The median new user followed one account. 74% of posts received zero responses. The zero rate — sessions opening to an empty or stale feed — was 63%.

**Aggregate dashboards hid it for two weeks.** Installs and signups kept climbing while every cohort beneath them collapsed. Users had arrived as 340,000 scattered individuals, not as networks; each one experienced a ghost town, and anti-network effects did the rest — "I tried it, it was dead."

**The press card was spent.** A relaunch blast was impossible; the market had already formed its opinion once.

### The Application

**Step 1: Rebuild analytics at the network level.** The team defined the candidate atomic network — a local running club or crew with roughly ten members posting weekly — and reprocessed the wreckage. Finding: 14 accidental live clusters, all crews that had joined together, were essentially the only retained users. The product was club-first; it had been launched follower-first.

**Step 2: Relaunch invite-only around clubs.** Signup now requires joining or creating a club. Solo signups go to a waitlist keyed by city and crew name — graph capture that turned the dead install base into a seeding map.

**Step 3: Solve the hard side: club captains.** Captains (status + utility motives) got dedicated tools — run scheduling, attendance, a member map, a public club page — plus a founding-captain badge and a monthly call with the team. The founders personally recruited 25 captains across three running-dense cities with a status pitch: "your crew's home online."

**Step 4: Define the magic moment and the bars.** Magic moment: "your post gets 3+ responses from your own club within 24 hours." Club live bar: 10+ weekly posters. Expansion gate: a new city opens only when 60% of launched clubs are live.

**Step 5: Flintstone and add single-player value.** Staff seeded route content and event recaps into young clubs, and the app shipped solid solo run-tracking so a runner waiting for their club still got tool value (come for the tool, stay for the network).

**Step 6: Re-engage the dead installs club by club.** The 340K lapsed users were contacted city by city as their clubs went live — "12 crews are now active in Austin, including one near you" — never as another blast.

### Results After 5 Months

| Metric | Big-Bang (Day 30) | Club Relaunch (Month 5) |
|--------|-------------------|-------------------------|
| Live networks | ~14 accidental clusters | 187 live clubs of 240 launched |
| D30 retention | 2.8% | 38% among club members |
| Zero rate | 63% | 11% |
| Posts receiving responses | 26% | 81% |
| Organic share of new users | 8% | 64% via club invites |
| Weekly actives | 9K and falling | 31K and growing |

### Lessons Learned

1. The launch wasn't under-marketed — it was over-marketed into emptiness. Density, not awareness, was the binding constraint, and press multiplied the anti-network effect.
2. Requiring club membership at signup looked like friction and was the retention mechanism: nobody lands alone anymore.
3. Captains were the network. Tooling and status for roughly 240 people moved 31,000 weekly actives.
4. The first launch's one real asset was data: the 14 accidental clusters revealed exactly what the atomic network was. Post-mortems on dead cohorts are seeding maps.

## Key Takeaways

1. **Define the network before the funnel.** All three teams measured users while the product lived or died at the network level — pods, zip codes, clubs. Per-network dashboards with live/forming/dead statuses changed every decision downstream.
2. **The hard side is specific and small.** A team lead, 35 cleaners, 240 captains — single-digit-percentage minorities determined everything. Build their tools, economics, and status first.
3. **Throttle to density.** The counterintuitive moves — capping demand, gating signups, waitlists, invite-only — created the liquidity that made every first impression work. Growth restraint was the growth tactic.
4. **Bars before expansion.** Written live bars (fill rate, club live rate, pod participation) turned "are we ready to grow?" from a debate into a checklist, and made the circuit breaker impersonal.
5. **Playbooks compound.** Each tipped network made the next one cheaper. The durable output of a launch is the kit and the bars — the cohort is just the first proof.
