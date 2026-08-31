# Interview Snapshots

A practical guide to conducting story-based customer interviews, capturing insights in a standardized snapshot format, and building a sustainable weekly interview cadence.

## Story-Based Interviewing

### Why Stories, Not Opinions

Traditional customer interviews ask people what they want, how they'd rate features, or whether they'd use a hypothetical product. These approaches fail because:

| Approach | Why It Fails | What You Get |
|----------|-------------|--------------|
| "What features do you want?" | Customers design solutions, not needs | Feature requests disconnected from real problems |
| "Would you use X?" | Hypothetical questions get hypothetical answers | False positives -- people say yes to be polite |
| "How important is Y on a scale of 1-5?" | Everything is rated "important" with no context | Flat data with no insight into actual behavior |
| "What do you think of Z?" | Opinions don't predict behavior | Rationalizations, not revelations |

Story-based interviewing asks customers to describe specific past experiences in rich detail. Real stories reveal what people actually did, felt, and struggled with -- not what they think they might do.

### The Core Technique

**The anchor question:** "Tell me about the last time you [did the relevant activity]."

This single prompt unlocks a narrative. From there, follow up with:

- **Sequence questions:** "What happened next?" "And then what did you do?"
- **Clarification questions:** "What do you mean by 'frustrating'?" "Can you walk me through that step by step?"
- **Emotion questions:** "How did that make you feel?" "What were you thinking at that point?"
- **Context questions:** "Where were you when this happened?" "Who else was involved?"
- **Contrast questions:** "Was that different from the time before?" "Have you ever done it differently?"

### Interview Structure (30 Minutes)

**Minutes 1-3: Warm-up**
- Thank the participant
- Explain the purpose: "We're trying to understand how you [activity] so we can make the experience better"
- Reassure: "There are no right or wrong answers -- we just want to learn from your real experience"
- Ask permission to record

**Minutes 3-8: Context setting**
- "How often do you [activity]?"
- "How long have you been doing it this way?"
- "Who else is involved when you [activity]?"

**Minutes 8-25: Story elicitation**
- "Tell me about the last time you [activity]. Start from the very beginning."
- Follow the story wherever it goes, using follow-up questions
- Probe pain points: "You mentioned that was annoying -- can you tell me more about that?"
- Probe workarounds: "You said you used a spreadsheet for that part -- walk me through why"
- Get specifics: "You said 'a while' -- was that minutes? Hours? Days?"

**Minutes 25-30: Wrap-up**
- "Is there anything else about this experience that we haven't covered?"
- "What's the single most frustrating part of [activity]?"
- Thank the participant and explain next steps

### Common Interview Mistakes

| Mistake | Example | Fix |
|---------|---------|-----|
| Leading questions | "Don't you think it would be better if...?" | "How do you handle that situation today?" |
| Accepting vague answers | Customer says "it's fine" and you move on | "Can you tell me about a specific time it was fine? What happened?" |
| Pitching your solution | "We're building a feature that does X -- would you use it?" | Save solution ideas for after the interview |
| Talking more than listening | Interviewer fills silences with explanations | Embrace silence; count to 5 before speaking |
| Only interviewing happy customers | Recruiting from active power users | Include churned users, new users, and struggling users |
| Going hypothetical | "What would you do if...?" | "Tell me about a time when you actually faced that situation" |

## The Interview Snapshot Format

After each interview, the product trio fills out a one-page snapshot. The goal is a concise, scannable artifact that anyone on the team can read in two minutes.

### Snapshot Template

```
┌─────────────────────────────────────────────────────┐
│ INTERVIEW SNAPSHOT                                  │
│                                                     │
│ Date: [date]          Participant: [name/alias]     │
│ Interviewer(s): [names]                             │
│ Role/Segment: [description]                         │
│                                                     │
│ ── THE STORY ──────────────────────────────────────│
│ [2-3 sentence summary of the specific experience    │
│  the participant described]                         │
│                                                     │
│ ── KEY QUOTES ─────────────────────────────────────│
│ • "[verbatim quote 1]"                              │
│ • "[verbatim quote 2]"                              │
│ • "[verbatim quote 3]"                              │
│                                                     │
│ ── OPPORTUNITIES IDENTIFIED ───────────────────────│
│ • [Opportunity 1 -- framed as customer need]        │
│ • [Opportunity 2 -- framed as customer need]        │
│                                                     │
│ ── SURPRISES / NEW INSIGHTS ───────────────────────│
│ • [Something unexpected that challenges our         │
│   assumptions]                                      │
│                                                     │
│ ── FOLLOW-UP ──────────────────────────────────────│
│ • [Questions to explore in future interviews]       │
│ • [Data to look up]                                 │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Filling Out the Snapshot

**Timing:** Complete the snapshot immediately after the interview, while the conversation is fresh. This should take 10-15 minutes for the trio together.

**The Story section:** Write 2-3 sentences that capture the specific experience the participant described. Not a summary of everything they said -- the core narrative arc. Example: "Maria described her weekly process of preparing client reports. She spends 2 hours every Monday manually pulling data from three different tools into a spreadsheet, then another hour formatting it. She sends the report by email and rarely hears back, so she doesn't know if clients actually read it."

**Key Quotes:** Write down 2-4 verbatim quotes that were particularly revealing. These are gold for communicating customer voice to stakeholders. Example: "I just copy and paste from three different dashboards. It's ridiculous, but I don't know a better way."

**Opportunities Identified:** Translate pain points and unmet needs into opportunity statements. These should be framed from the customer's perspective and be solution-agnostic. Example: "Users need a way to aggregate data from multiple sources without manual copy-paste."

**Surprises:** Capture anything that challenged the team's assumptions or was genuinely new. This section forces the team to acknowledge what they didn't know.

## Synthesizing Across Interviews

Individual interviews tell stories. Patterns across interviews reveal opportunities. Synthesis is how you move from anecdotes to evidence.

### The Synthesis Process

**Weekly (after each interview):**
1. Complete the interview snapshot
2. Add new opportunities to the Opportunity Solution Tree
3. Note if the opportunity reinforces a pattern seen in prior interviews

**Bi-weekly (every 2 weeks):**
1. Lay out all recent snapshots side by side
2. Look for recurring themes across participants
3. Cluster similar opportunities together
4. Identify which opportunities have the most supporting evidence
5. Update the OST with refined opportunity framing

**Monthly:**
1. Review the full snapshot library
2. Assess coverage: are we hearing from diverse segments?
3. Identify gaps: what questions remain unanswered?
4. Adjust recruitment strategy based on gaps

### Identifying Patterns

| Signal | What It Means | Action |
|--------|---------------|--------|
| 3+ participants describe the same pain point | Strong opportunity with broad impact | Promote to a primary opportunity on the OST |
| Different segments describe the same need differently | Opportunity may need sub-opportunities by segment | Break into segment-specific sub-opportunities |
| One participant describes something nobody else mentioned | Could be an outlier or an early signal | Keep it noted; look for it in the next 3-5 interviews |
| Participants describe workarounds for the same gap | Unmet need that customers are actively trying to solve | High-priority opportunity -- customers already want a solution |
| Emotional language appears around a specific moment | High-impact pain point with emotional resonance | Opportunity with strong desirability signal |

### Avoiding Synthesis Pitfalls

- **Recency bias:** The most recent interview feels most important. Counter by reviewing all recent snapshots together.
- **Confirmation bias:** You notice patterns that confirm what you already believe. Counter by specifically looking for disconfirming evidence.
- **Loudest voice:** One particularly articulate participant's story dominates thinking. Counter by counting -- how many participants mentioned this?
- **Premature closure:** You stop interviewing once you hear a pattern. Counter by continuing interviews even when you think you've found the answer.

## Extracting Opportunities from Stories

### The Translation Process

Stories contain raw data. Opportunities are insights extracted from that data. The translation requires separating what customers did and felt from what the team might do about it.

**Step 1: Identify the pain point or unmet need in the story**
- Customer action: "I export data to a spreadsheet, then reformat it manually"
- Pain point: Manual data transformation is time-consuming and error-prone

**Step 2: Frame it from the customer's perspective**
- Bad: "We need to add a data export feature" (solution-framed)
- Good: "Users need their data in a usable format without manual transformation" (need-framed)

**Step 3: Validate the scope**
- Is this too broad? ("Users need data") -- break it down
- Is this too narrow? ("Users need CSV export with custom columns") -- zoom out
- Just right: specific enough to be actionable, broad enough to allow multiple solutions

## Automating Recruitment

The biggest reason teams stop doing weekly interviews is that recruitment is painful. Automation makes the habit sustainable.

### Recruitment Channels

| Channel | Best For | Setup Effort | Ongoing Effort |
|---------|----------|-------------|----------------|
| In-app intercept | Active users; behavior-triggered targeting | Medium (requires engineering) | Very low |
| Email to existing users | Broad user base; can segment by behavior | Low | Low |
| Customer advisory panel | Power users willing to give regular feedback | Medium (need to curate panel) | Low |
| Support ticket follow-up | Users who experienced specific problems | Low | Medium (manual screening) |
| Scheduling tool (e.g., Calendly) | All channels; reduces back-and-forth | Very low | Very low |
| User research platform | Diverse participants including non-users | Low (subscription) | Low |

### The Ideal Recruitment System

1. **Trigger:** An in-app message appears to users who match your target criteria (e.g., users in their first week, users who haven't used feature X, users who recently churned)
2. **Opt-in:** The message says: "Help us make [product] better for you. Chat for 20-30 minutes and receive [incentive]."
3. **Scheduling:** Clicking the message opens a scheduling tool with the team's available slots
4. **Reminder:** Automatic email reminder 24 hours and 1 hour before the session
5. **Follow-up:** Automatic thank-you email with incentive delivery after the session

### Incentive Guidelines

| Audience | Appropriate Incentive |
|----------|----------------------|
| B2B enterprise users | Gift card ($50-100), donation to charity of choice |
| B2B SMB users | Gift card ($25-50), extended trial or credits |
| Consumer users (paid) | Gift card ($15-30), free month of service |
| Consumer users (free) | Gift card ($10-20), premium feature access |
| Churned users | Gift card ($30-50) -- harder to recruit, worth the premium |

## The Weekly Interview Cadence

### Minimum Viable Cadence

- **One interview per week** with the full product trio present
- **10-15 minutes of snapshot synthesis** immediately after the interview
- **30 minutes of bi-weekly synthesis** reviewing patterns across recent snapshots

### Scaling the Cadence

As the team builds the habit, scale to 2-3 interviews per week:

| Slot | Focus | Participant Type |
|------|-------|-----------------|
| Tuesday 2pm | Current problem space | Active users matching current opportunity |
| Thursday 10am | Broad discovery | Diverse user segments for new opportunities |
| Friday 11am (optional) | Specific investigation | Churned users, prospects, or edge cases |

### What If You Can't Get Interviews?

| Barrier | Workaround |
|---------|------------|
| "Our users won't talk to us" | Start with users who contact support -- they already want to talk |
| "We're B2B and can't reach end users" | Partner with customer success to join their regular calls |
| "Leadership says we don't have time" | Start with one 30-minute interview per week; the value will justify more |
| "We don't have users yet" | Interview people who match your target persona about their current experience |
| "Nobody shows up" | Increase incentive, send multiple reminders, over-recruit (book 5 to get 3) |

## Snapshot Library Management

### Organization

Organize snapshots so the team can reference them easily:
- **Chronological:** Newest on top for scanning recent learning
- **Tagged by opportunity:** Each snapshot tagged with the opportunities it supports
- **Tagged by segment:** Each snapshot tagged with participant characteristics
- **Searchable:** Use a tool that allows keyword search across all snapshots

### Using the Library

- **Before designing a solution:** Pull up all snapshots related to the target opportunity
- **During stakeholder discussions:** Reference specific snapshots and quotes to ground conversations in evidence
- **When onboarding new team members:** Have them read the last 10-15 snapshots to build customer empathy quickly
- **During prioritization:** Count how many snapshots support each opportunity to assess evidence strength
