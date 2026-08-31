# Case Studies: Lean UX in Practice

These case studies illustrate how Lean UX principles apply across different organizational contexts. Each scenario is a realistic composite based on common patterns, not a specific company. The goal is to show how hypothesis-driven design, collaborative practices, and outcome-focused metrics work in the real world.

## Case Study 1: Enterprise Product Team

### Context

A B2B SaaS company with 500 employees builds project management software for mid-market companies. The product team (12 people: 2 designers, 6 engineers, 2 PMs, 1 data analyst, 1 QA) has been shipping features from a roadmap driven by sales requests. Despite shipping 15 major features in the past year, net revenue retention is flat and NPS has declined from 42 to 35.

### The Problem

The team is caught in the output trap. Sales submits feature requests, PMs write specs, designers create wireframes, engineers build, and the cycle repeats. No one checks whether shipped features actually improve user outcomes. The roadmap is a conveyor belt of outputs with no feedback loop.

### Lean UX Intervention

**Week 1: Assumption Workshop**

The PM organized a 60-minute assumption workshop with the full team. They identified 24 assumptions underlying the current roadmap. Prioritization revealed three high-risk, high-uncertainty assumptions:

| Assumption | Risk | Uncertainty |
|-----------|------|-------------|
| "Users want Gantt chart view because sales says they do" | High (3 months of development planned) | High (no user research) |
| "Users leave because we lack integrations" | High (churn is the main revenue threat) | High (based on exit survey with 12% response rate) |
| "Our onboarding is fine because support tickets are low" | Medium (may be suppressing activation) | High (no onboarding funnel data) |

**Week 2-3: Hypotheses and Experiments**

The team wrote hypotheses and designed experiments for each assumption:

**Hypothesis 1:** "We believe project managers will use Gantt charts at least 3x/week if they have a one-click timeline view in their project dashboard."
- **Experiment:** Clickable Figma prototype tested with 8 existing users.
- **Result:** 6 of 8 users could not complete the test task. 5 of 8 said they use spreadsheets for timeline views and would not switch. Hypothesis invalidated.
- **Decision:** Removed Gantt chart from the roadmap, saving 3 months of development. Pivoted to a lightweight "milestones" view based on user feedback.

**Hypothesis 2:** "We believe users churn because they cannot connect to their existing tools. Integration adoption will reduce 90-day churn by 20%."
- **Experiment:** Concierge MVP. The team manually set up Zapier integrations for 15 at-risk accounts and measured engagement over 30 days.
- **Result:** 9 of 15 accounts used the integration. Churn intent (measured by cancellation page visits) dropped by 35% in the test group. Hypothesis partially validated.
- **Decision:** Built native integrations for the top 3 tools identified in the concierge test.

**Hypothesis 3:** "We believe onboarding completion is low (baseline unknown) and that users who complete onboarding retain at 2x the rate of those who don't."
- **Experiment:** Instrumented the existing onboarding flow to measure completion.
- **Result:** Only 28% of new users completed onboarding. Users who completed onboarding had 2.4x higher 30-day retention. Hypothesis validated.
- **Decision:** Redesigned onboarding using a Design Studio session. New onboarding tested with 5 users before development.

### Outcomes After 3 Months

| Metric | Before Lean UX | After 3 Months |
|--------|---------------|----------------|
| Features shipped per quarter | 5 | 3 (but all validated) |
| Hypotheses tested per quarter | 0 | 11 |
| NPS | 35 | 41 |
| Onboarding completion | 28% | 52% |
| 90-day churn | 18% | 14% |
| Roadmap items removed | 0 | 4 (saved ~6 months of development) |

### Key Lesson

The team shipped fewer features but produced better outcomes. The Gantt chart cancellation alone saved 3 months of engineering time that was redirected to validated work. The cultural shift was the hardest part: the VP of Sales initially resisted removing Gantt charts from the roadmap but was convinced by the user test videos.

## Case Study 2: Startup

### Context

A 6-person startup building a personal finance app for freelancers. The team consists of 1 founder/PM, 1 designer, 3 engineers, and 1 marketer. They have $400K in runway (8 months) and 200 beta users. The product has expense tracking and invoicing but retention is poor: only 15% of users are active after 30 days.

### The Problem

The founder has a long list of features to build (tax estimation, bank sync, reporting, team billing) but limited runway. Building the wrong feature next could burn 2-3 months and bring the company closer to failure without improving retention.

### Lean UX Intervention

**Day 1: Assumption Mapping**

The team spent 90 minutes listing assumptions and plotting them on the prioritization matrix:

Top 3 to test:
1. "Freelancers leave because they forget to log expenses" (retention assumption)
2. "Tax estimation is the feature that will make users pay" (monetization assumption)
3. "Users want to connect their bank account for auto-categorization" (value assumption)

**Week 1: Rapid Experiments**

**Experiment 1 (retention):** Interviewed 8 churned users over Zoom (30 minutes each). Found that 6 of 8 said they "forgot the app existed" after the first week. The problem was not missing features but missing triggers.
- **Insight:** Users needed reminders, not more features.
- **Quick test:** Sent manual weekly email summaries to 50 active users for 2 weeks.
- **Result:** 30-day retention for the email group was 32% vs. 15% for the control group. Validated.

**Experiment 2 (monetization):** Created a smoke test landing page for a "tax estimation" feature with a $9/month price tag and "Get Early Access" button.
- **Result:** 12% of the 200 beta users clicked. 4% entered their email. Weak signal. Partially invalidated.
- **Pivot:** Interviewed the 8 users who clicked. Found they wanted "peace of mind" about taxes, not a calculator. Pivoted hypothesis to a "tax set-aside" feature that automatically suggests how much to save per invoice.

**Experiment 3 (bank sync):** Wizard of Oz test. Offered 10 users "automatic bank sync" and manually categorized their transactions for 1 week.
- **Result:** 8 of 10 users logged in more frequently during the test week. Qualitative feedback was overwhelmingly positive. Validated.
- **Decision:** Prioritized bank sync using a third-party API rather than building from scratch.

**Week 2-8: Iterative Build and Test**

The team implemented dual-track agile with 1-week sprints:
- Discovery: Designer + founder tested 2 hypotheses per week
- Delivery: Engineers built validated features

### Outcomes After 2 Months

| Metric | Before | After 2 Months |
|--------|--------|----------------|
| 30-day retention | 15% | 34% |
| Weekly active users | 30 | 68 |
| Features built | 0 (all planned) | 3 (all validated) |
| Runway consumed | N/A | 2 months |
| Hypotheses tested | 0 | 14 |
| Features removed from backlog | 0 | 5 |

### Key Lesson

With limited runway, the startup could not afford to build the wrong feature. Lean UX helped them discover that the retention problem was not about features but about triggers. The weekly email summary (which took 2 hours to build) had more impact than the tax estimation feature (which would have taken 6 weeks). Speed of learning was the competitive advantage.

## Case Study 3: Agency

### Context

A digital agency with 40 employees serves mid-market e-commerce clients. The design team (8 designers) typically delivers pixel-perfect mockups, comprehensive wireframe decks, and detailed style guides. Projects take 8-12 weeks from kick-off to handoff. Clients frequently request changes after handoff, causing scope creep and eroding margins.

### The Problem

The agency's deliverable-heavy process creates two problems: (1) designers spend weeks on artifacts that change after client review, and (2) the final product often misses user needs because no real user testing happens until after launch.

### Lean UX Intervention

**Pilot Project:** A new e-commerce client wanted a redesign of their checkout flow to reduce abandonment (currently 72%).

**Week 1: Collaborative Kick-Off**

Instead of a traditional creative brief, the agency ran a Lean UX kick-off:

1. **Assumption workshop (2 hours)** with client stakeholders, agency designers, and the client's development team. Identified 16 assumptions about why users abandon checkout.

2. **Hypothesis prioritization:** Top 3 assumptions to test:
   - "Users abandon because the form is too long (18 fields)"
   - "Users abandon because shipping costs are hidden until step 4"
   - "Users abandon because guest checkout is hard to find"

3. **Design Studio (90 minutes):** Agency designers, client's developer, and client's marketing lead sketched solutions together.

**Week 2: Prototype and Test**

- Built clickable prototype of the top-voted checkout concept in 2 days
- Recruited 6 of the client's actual customers
- Ran 30-minute moderated usability sessions
- Findings: Form length was not the issue (users did not mind the fields). Hidden shipping costs were the primary abandonment trigger (5 of 6 users mentioned it). Guest checkout was fine.

**Week 3: Iterate and Retest**

- Revised prototype to show shipping cost estimate on the cart page (before checkout)
- Retested with 5 new users
- All 5 completed checkout. 4 of 5 specifically mentioned that seeing shipping costs early made them more confident.

**Week 4: Handoff**

- Delivered a tested, validated prototype (not a 60-page wireframe deck)
- Client's development team had attended the Design Studio and usability sessions, so they already understood the design
- Handoff meeting took 30 minutes instead of the usual 3 hours

### Outcomes

| Metric | Before Lean UX | After Lean UX |
|--------|---------------|---------------|
| Project duration | 10 weeks | 4 weeks |
| Designer hours | 320 hours | 140 hours |
| Client revision rounds | 4-5 | 1 |
| User tests before launch | 0 | 2 rounds (11 users) |
| Checkout abandonment | 72% | 58% (post-launch) |
| Client satisfaction | "Met expectations" | "Exceeded expectations" |
| Profit margin | 18% | 34% |

### Key Lesson

The agency discovered that clients did not actually want 60-page wireframe decks; they wanted confidence that the design would work. Testing with real users provided that confidence faster and cheaper than polished deliverables. The agency now offers "Lean UX Sprints" as a service, charging the same fee but delivering in half the time with better results.

## Case Study 4: Internal Tools Team

### Context

A 200-person logistics company has a 4-person internal tools team (1 PM, 1 designer, 2 engineers) that builds software for warehouse staff, dispatchers, and customer service agents. The team maintains 6 internal applications. Requests come from department heads, and the team has a 9-month backlog. No user research has ever been conducted because "we know our users; they sit down the hall."

### The Problem

Despite a full backlog, the three most recent features shipped in the past 6 months have been underused. The warehouse barcode scanning feature (3 months to build) is used by only 2 of 15 warehouse staff. The dispatcher dashboard (2 months) was abandoned after 1 week because dispatchers reverted to their spreadsheet.

### Lean UX Intervention

**Week 1: Assumption Audit**

The team reviewed the 9-month backlog and categorized every item by assumption risk:

| Backlog Category | Items | Validated | Assumed | Unknown |
|-----------------|-------|-----------|---------|---------|
| Warehouse tools | 8 | 0 | 5 | 3 |
| Dispatcher tools | 6 | 0 | 4 | 2 |
| Customer service tools | 5 | 0 | 3 | 2 |

Every single backlog item was based on assumptions from department heads, with zero user validation.

**Week 2: Go to the Gemba**

The designer and PM spent 3 days observing actual users:
- **Day 1:** Shadowed 3 warehouse staff for 4 hours each. Discovered that the barcode scanner was too slow (3 seconds per scan vs. the 0.5-second manual process). Staff needed speed, not technology.
- **Day 2:** Sat with 2 dispatchers for a full shift. Discovered the dashboard was abandoned because it lacked a critical field (driver phone number) that the spreadsheet had. A 5-minute fix could resurrect the feature.
- **Day 3:** Observed 3 customer service agents. Discovered they toggled between 4 different systems to resolve one ticket. The most impactful change would be a unified view, not a new tool.

**Week 3-4: Rapid Hypothesis Testing**

**Hypothesis 1:** "We believe dispatcher dashboard adoption will reach 80% if we add the driver phone number field and a one-click call button."
- **Experiment:** Added the field (30-minute code change). Monitored adoption for 1 week.
- **Result:** Adoption went from 0% to 73% in one week. Validated.

**Hypothesis 2:** "We believe customer service resolution time will decrease by 25% if agents can see order status, shipping status, and customer history in a single pane."
- **Experiment:** Paper prototype of unified view, tested with 4 agents using real (anonymized) ticket scenarios.
- **Result:** All 4 agents completed tasks faster and expressed strong preference for the unified view. 3 of 4 identified additional data fields they needed. Validated (with refinements).

**Hypothesis 3:** "We believe warehouse scan adoption will increase if scan time is under 1 second."
- **Experiment:** Technical spike. Engineer determined that switching to a different barcode library could reduce scan time to 0.4 seconds. Built a prototype in 2 days.
- **Result:** Tested with 5 warehouse staff. All 5 preferred the fast scanner. 4 of 5 said they would use it daily. Validated.

### Outcomes After 2 Months

| Metric | Before | After |
|--------|--------|-------|
| Backlog items validated before building | 0% | 100% |
| Features adopted by target users | 33% | 90% |
| Dispatcher dashboard adoption | 0% | 73% |
| Time spent observing users per month | 0 hours | 12 hours |
| Backlog items removed (not worth building) | 0 | 7 |
| Average time from request to validated solution | 3 months | 2 weeks |

### Key Lesson

"We know our users" was the most dangerous assumption the team held. Sitting next to users for a single day revealed that the barcode scanner problem was about speed (not technology), the dashboard problem was about one missing field (not a redesign), and the service tool problem was about context switching (not a new tool). The cheapest Lean UX activity, direct observation, had the highest ROI.

## Cross-Cutting Themes

Patterns that appear across all four case studies:

| Theme | How It Appeared | Principle |
|-------|----------------|-----------|
| **Assumptions are invisible until surfaced** | Every team had critical assumptions they had never questioned | Start with an assumption workshop |
| **Observation beats opinion** | Watching users revealed insights that surveys and stakeholders missed | Go to the gemba; watch real behavior |
| **Small experiments prevent big waste** | A 30-minute code fix, a landing page, or a paper prototype saved months of misdirected effort | Choose the lowest-fidelity experiment that answers the question |
| **Invalidation is valuable** | Removing features from the backlog was as impactful as building new ones | Celebrate invalidated hypotheses |
| **Shared understanding beats documentation** | Teams that designed together and observed research together needed less handoff | Collaborative design and shared research observation |
| **Outcomes reveal the truth** | Output metrics (features shipped) masked failure; outcome metrics (retention, adoption, task time) revealed reality | Measure behavior change, not feature delivery |
