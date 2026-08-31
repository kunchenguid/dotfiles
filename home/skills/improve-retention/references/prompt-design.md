# Prompt Design

Prompts are the most overlooked element in behavior design. Without a prompt, behavior doesn't happen — no matter how motivated or able the user is.

## Three Prompt Types

### 1. Person Prompts (Internal)

**What they are:** Thoughts or reminders that come from within the user. "I should check my metrics." "Time to update the project."

**How they form:** Through repeated association between a context and a behavior. After enough repetitions, the user thinks of the behavior automatically in that context.

**Product implications:**
- You cannot directly create Person Prompts
- You create them indirectly by pairing external prompts with consistent contexts
- Person Prompts are the goal — they mean the habit is formed
- When users act without any external prompt, Person Prompts are driving behavior

**Measurement:** Track organic sessions (sessions without a preceding notification or email). Rising organic sessions = Person Prompts forming.

---

### 2. Context Prompts (Environmental)

**What they are:** Cues in the user's environment that trigger behavior. A badge on an app icon. A browser tab that's always open. A physical location associated with a task.

**How they work:** The environment reminds the user to act. The cue doesn't come from the product's notification system — it comes from the user's existing context.

**Product implications:**
- Design for environmental persistence (widgets, browser tabs, badges, status bar items)
- Integrate into existing workflows (Slack integrations, email digests, calendar events)
- Physical environment matters: desktop apps have different context cues than mobile

**Design strategies:**
- App badges and notification counts (persistent visual cue)
- Browser start page or new tab integration
- Widget on phone home screen
- Calendar integrations (event = context cue)
- Slack/Teams bot messages in existing channels

---

### 3. Action Prompts (Designed)

**What they are:** Prompts deliberately designed and sent by the product. Push notifications, emails, in-app tooltips, CTAs, banners, and modals.

**How they work:** The product actively tells the user to do something at a specific moment.

**Product implications:**
- You have full control over timing, content, and frequency
- But Action Prompts are expensive — each one uses up attention capital
- Prompt fatigue is real: too many Action Prompts degrades all future prompts
- Action Prompts should feel like helpful reminders, not interruptions

---

## Prompt Timing

The most important principle: **Prompts only work above the Action Line.** Sending a prompt to someone who lacks motivation or ability is not engagement — it's spam.

### When to Prompt

| Timing Strategy | How It Works | Example |
|----------------|-------------|---------|
| **Event-based** | Prompt triggered by a real event | "Your report is ready" (report was generated) |
| **Anchor-based** | Prompt tied to user's existing routine | "After your morning standup, check your dashboard" |
| **State-based** | Prompt triggered by user's product state | "You have 3 unread comments" (content waiting) |
| **Completion-based** | Prompt after user finishes a related action | "You just finished a meeting — want to log action items?" |
| **Threshold-based** | Prompt when a metric crosses a threshold | "Your project hit 80% completion" |

### When NOT to Prompt

| Anti-Pattern | Why It Fails | Better Approach |
|-------------|-------------|-----------------|
| **Time-based schedule** | "Every Monday at 9am" regardless of context | Event-based: prompt when there's something to act on |
| **Re-engagement spam** | "We miss you!" every 3 days | Wait for a meaningful event, then send one message |
| **Feature promotion** | "Have you tried our new analytics?" | Prompt when user encounters the problem analytics solves |
| **Vanity metrics** | "You've been viewed 12 times this week!" | Only prompt for actionable information |
| **Guilt-based** | "Your team is waiting" when they're not | Only use social prompts when genuinely true |

---

## Notification Design

### The PASS Framework for Notifications

Every notification should pass four tests:

**P — Personal:** Is this relevant to this specific user?
- Bad: "Check out our new features"
- Good: "Your project 'Q2 Launch' has 3 new comments"

**A — Actionable:** Can the user act on this right now?
- Bad: "Your subscription renews in 30 days"
- Good: "Sarah shared a file with you — tap to view"

**S — Specific:** Does it tell the user exactly what happened?
- Bad: "You have new activity"
- Good: "2 tasks were completed in your Sprint 4 board"

**S — Short:** Can the user get the point in under 3 seconds?
- Bad: "We wanted to let you know that there have been some updates to the project that you've been following, and several team members have added their contributions"
- Good: "3 updates in Project Alpha"

### Notification Frequency Guidelines

| User Segment | Frequency | Rationale |
|-------------|-----------|-----------|
| New users (Week 1) | 1-2 per day max | Build value without overwhelming |
| Active users | Based on events, not schedule | They're engaged; prompt around real activity |
| Fading users | 1-2 per week max | High value, low volume to re-engage |
| Churned users | 1 per month max | Only prompt for highly relevant events |

### Notification Hierarchy

Not all prompts are equal. Design a hierarchy:

1. **Critical:** Requires immediate action (security alerts, time-sensitive deadlines)
2. **Important:** Meaningful event that benefits from quick response (teammate mention, task completion)
3. **Informational:** Nice to know but not urgent (weekly digest, milestone reached)
4. **Ambient:** Background awareness (badge count update, status change)

Match the notification channel to the hierarchy level:

| Level | Channel | Interruption Level |
|-------|---------|-------------------|
| Critical | Push notification + banner | Full interruption |
| Important | Push notification | Standard interruption |
| Informational | In-app + email digest | Low interruption |
| Ambient | Badge count, in-app indicator | No interruption |

---

## Anchor Moments

Anchor moments are the key to forming habits. They are existing routines that serve as reliable triggers for new behaviors.

### What Makes a Good Anchor

A good anchor moment is:
- **Reliable:** It happens consistently (daily, weekly)
- **Recognizable:** The user clearly knows when it happens
- **Relevant:** It's contextually related to the new behavior
- **Already habitual:** It doesn't require motivation — it's automatic

### Common Anchor Moments for Products

| Anchor Moment | New Behavior | Recipe |
|---------------|-------------|--------|
| Opening laptop in the morning | Check dashboard | "After I open my laptop, I will glance at my dashboard" |
| Finishing a meeting | Log action items | "After I leave a meeting, I will add one task" |
| Morning coffee | Review daily plan | "After I pour my coffee, I will check my priorities" |
| End of workday | Update project status | "After I close my IDE, I will update one status" |
| Weekly team standup | Review team metrics | "After our standup, I will check the team scoreboard" |

### Designing for Anchor Moments

1. **Identify** the anchor through user research (what do users already do reliably?)
2. **Pair** the new behavior with the anchor (proximity in time and context)
3. **Prompt** at the anchor moment (notification, email, or in-app cue)
4. **Shrink** the new behavior to its Starter Step
5. **Celebrate** after completion (feedback, progress, positive emotion)

---

## Prompt Design Patterns

### Progressive Prompt Reduction

As habits form, reduce external prompts:

| Week | Prompt Strategy | Goal |
|------|----------------|------|
| 1-2 | Daily action prompts | Establish the behavior |
| 3-4 | Reduce to every other day | Test if habit is forming |
| 5-8 | Weekly summary only | Shift to context/person prompts |
| 9+ | No external prompts | Habit formed (monitor organic sessions) |

### The Prompt-Value Ratio

Every prompt should deliver more value than it costs in attention:

```
Prompt Value = (Relevance × Urgency × Actionability) / Frequency
```

If frequency goes up, each prompt must be more relevant, more urgent, or more actionable to maintain the same value ratio.

### Prompt A/B Testing

Test prompts on these dimensions:

| Dimension | A | B |
|-----------|---|---|
| **Timing** | Morning send | Anchor-moment send |
| **Content** | Generic ("Check your dashboard") | Specific ("2 tasks due today") |
| **Channel** | Push notification | In-app banner |
| **Frequency** | Daily | Event-based |
| **Tone** | Informational ("Your report is ready") | Social ("Sarah commented on your project") |

Measure: Open rate, action completion rate, and long-term retention (not just clicks).
