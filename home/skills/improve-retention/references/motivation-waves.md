# Motivation Waves

Motivation is the most misunderstood element in behavior design. It is powerful but unreliable — it comes in waves, and products that depend on motivation peaks fail when the wave inevitably recedes.

## The Three Core Motivators

BJ Fogg identifies three core motivators, each with two sides:

### 1. Sensation (Pleasure / Pain)

**What it is:** The immediate physical or emotional experience. Pleasure pulls toward behavior; pain pushes away.

**Product examples:**
- Pleasure: Beautiful UI, satisfying animations, dopamine from social validation
- Pain: Annoying notifications, frustrating errors, slow load times

**Design implications:**
- Make the product pleasant to use (sensory reward)
- Remove painful friction points
- But don't rely on pleasure alone — novelty wears off
- Sensation is the fastest motivator but the shortest-lasting

### 2. Anticipation (Hope / Fear)

**What it is:** The expectation of future outcomes. Hope pulls toward behavior (I'll get a promotion if I learn this); fear pushes toward behavior (I'll lose my job if I don't use this).

**Product examples:**
- Hope: "See your progress in real-time" (anticipation of achievement)
- Fear: "Your trial expires in 3 days" (anticipation of loss)

**Design implications:**
- Hope is more sustainable than fear for building habits
- Fear is powerful for one-time behaviors (upgrades, completions) but corrosive for habits
- Show users their potential future state (before/after, progress projections)
- Be careful with fear — overuse damages trust and creates anxiety

### 3. Belonging (Acceptance / Rejection)

**What it is:** The desire to be part of a group and the fear of being excluded. Social motivation.

**Product examples:**
- Acceptance: "Join 50,000 teams using this tool" (belonging)
- Rejection: "Your team is ahead of you" (social pressure)

**Design implications:**
- Social proof is one of the most reliable motivation boosters
- Showing teammates already using the product reduces social deviance (Ability Chain)
- Community features create belonging
- Be careful with rejection/comparison — it can demotivate rather than motivate

---

## Motivation Waves

Motivation is not stable. It fluctuates in predictable patterns:

```
Motivation
    ↑
    │    ★ Peak
    │   / \
    │  /   \
    │ /     \        ★ Smaller peak
    │/       \      / \
    │         \    /   \
    │          \  /     \___________
    │           \/        Trough
    │
    └──────────────────────────────→ Time
    Day 1   Day 7   Day 14   Day 30
```

### The Motivation Timeline

| Phase | Timeframe | Motivation Level | What Happens |
|-------|-----------|-----------------|--------------|
| **Honeymoon** | Day 1-3 | Very high | New user excitement, novelty, social pressure from signup |
| **First dip** | Day 4-7 | Dropping | Novelty wears off, reality of effort sets in |
| **Recommitment** | Day 7-14 | Moderate spike | External trigger (weekly email) or social event sparks return |
| **Trough** | Day 14-30 | Low | This is where most users churn. Motivation alone won't sustain them |
| **Plateau** | Day 30+ | Stable-low | If habit formed, behavior continues without motivation. If not, user is gone |

### Why This Matters for Product Design

The critical insight: **Most products are designed for the honeymoon phase.** Onboarding assumes high motivation. Features assume engaged users. Prompts assume people want to hear from you.

The trough (Day 14-30) is where retention is won or lost. Products that survive the trough do so because:
1. Core behaviors are easy enough to do without motivation (Ability)
2. Prompts are well-timed and event-based (not spam)
3. Tiny habits have started to wire
4. The product delivers value even at minimal engagement

---

## Designing for the Trough

### The Trough Survival Checklist

| Question | If No | Action |
|----------|-------|--------|
| Can users get value in under 30 seconds? | Core action is too hard for low motivation | Shrink to Starter Step |
| Does the product work with minimal engagement? | All-or-nothing design loses trough users | Create value at every engagement level |
| Are prompts event-based, not schedule-based? | Schedule-based prompts feel like spam at the trough | Switch to event-based triggers |
| Is there a tiny habit recipe for the core behavior? | No habit formation path | Design anchor → tiny behavior → celebration |
| Does the product show accumulated value? | Users forget what they'd lose by leaving | Surface history, progress, data investment |

### Trough-Resistant Product Patterns

**1. The Value Buffer**
Build up value during the honeymoon that pays off during the trough.
- User configures preferences during honeymoon → better recommendations during trough
- User enters data during honeymoon → accumulated reports during trough
- User builds connections during honeymoon → social content during trough

**2. The Gravity Well**
Create increasing switching costs so leaving becomes harder over time.
- Data that only exists in your product
- Integrations with other tools
- Team dependencies
- Customization and personalization

**3. The Minimum Viable Engagement**
Define the tiniest engagement that still delivers value:
- "Just open the app" → see your status
- "Glance at the email" → one key metric in the subject line
- "Check the badge count" → know if anything needs attention

---

## Motivation Boosters

When you do need to increase motivation (for hard behaviors or critical moments), use these strategically:

### Effective Motivation Boosters

| Booster | Motivator | When to Use | Example |
|---------|-----------|-------------|---------|
| **Social proof** | Belonging | Signup, adoption | "50,000 teams trust us" |
| **Loss aversion** | Anticipation (fear) | Trial ending, churn risk | "Don't lose your 30-day history" |
| **Progress visualization** | Anticipation (hope) | Mid-journey, recommitment | "You're 60% to your goal" |
| **Peer activity** | Belonging | Re-engagement | "3 teammates shared updates today" |
| **Success stories** | Anticipation (hope) | Onboarding, feature adoption | "Teams like yours saved 4 hours/week" |
| **Streak tracking** | Anticipation (fear of loss) | Habit building | "Keep your 7-day streak going" |

### Motivation Booster Timing

Use boosters at predictable motivation dips:

| Timing | Dip | Booster |
|--------|-----|---------|
| Day 3-5 | Novelty wearing off | Progress visualization + social proof |
| Day 7 | First week end | Achievement milestone + peer comparison |
| Day 14-21 | Deep trough | Success story + loss aversion (data) |
| Day 30 | Make-or-break point | Accumulated value summary + belonging |

---

## Why Motivation-First Strategies Fail

### The Motivation Trap

Many products and product teams default to motivation-first thinking:
- "We need more inspiring onboarding"
- "Let's add gamification to boost engagement"
- "We need better copy to motivate users"

This fails because:

1. **Motivation is temporary.** No matter how inspiring your copy, motivation fades.
2. **Motivation is contextual.** What motivates at 9am fails at 4pm.
3. **Motivation is personal.** What works for one user fails for another.
4. **Motivation doesn't compound.** Each boost starts from zero.

### The Ability-First Alternative

| Motivation-First | Ability-First |
|-----------------|---------------|
| Inspiring onboarding video | One-click first action |
| Gamification points system | Simpler core workflow |
| Motivational push notifications | Event-based prompts at high-ability moments |
| Aspirational copy | Clear, specific copy that reduces confusion |
| Social pressure to engage more | Social proof that reduces social deviance |

**Rule of thumb:** If you're trying to increase motivation, first ask: "Can I make the behavior easier instead?"

---

## Motivation and the Ability Chain

Motivation and ability interact on the Fogg Behavior Model:

| Scenario | Motivation | Ability | What Happens |
|----------|-----------|---------|--------------|
| New user, day 1 | High (honeymoon) | Low (unfamiliar) | Works temporarily — but trough will come |
| New user, day 14 | Low (trough) | Low (still unfamiliar) | **Churn** — below the Action Line |
| Trained user, day 30 | Low (stable) | High (practiced) | **Habit** — ability compensates for low motivation |
| Power user | Variable | Very high | Automatic behavior — above the line regardless |

The path to retention: **Move users from top-left (high motivation, low ability) to bottom-right (low motivation, high ability) before the motivation wave crashes.**
