# The Fogg Behavior Model (B=MAP)

The Fogg Behavior Model is the foundation of behavior design. Every behavior — from clicking a button to forming a daily habit — follows the same equation: B=MAP.

## The Equation

**Behavior = Motivation + Ability + Prompt**

All three elements must converge at the same moment for behavior to occur. If any one is missing, the behavior doesn't happen.

```
            HIGH ┃
                 ┃     ★ ★ ★ ★
                 ┃   ★         ★
                 ┃  ★            ★
  Motivation     ┃━★━━━━━━━━━━━━━━★━━━ ← Action Line
                 ┃                  ★
                 ┃   ✗ ✗ ✗          ★
                 ┃                    ★
            LOW  ┃
                 ┗━━━━━━━━━━━━━━━━━━━━━━
                 HARD              EASY
                        Ability
```

Stars above the line: behavior happens when prompted.
X marks below the line: behavior fails regardless of prompt.

---

## The Action Line

The Action Line is the curve that separates success from failure. It is not a straight line — it curves because motivation and ability compensate for each other.

### How the Curve Works

- **High motivation + low ability:** Behavior can still happen (people do hard things when motivated enough)
- **Low motivation + high ability:** Behavior can still happen (people do easy things even when unmotivated)
- **Low motivation + low ability:** Below the Action Line — no prompt works
- **High motivation + high ability:** Well above the line — almost any prompt triggers action

### Design Implications

1. **Move right (increase ability):** Most reliable strategy. Systematic, permanent, controllable.
2. **Move up (increase motivation):** Unreliable. Motivation is temporary and context-dependent.
3. **Better prompts:** Only work above the Action Line. Optimizing prompts for users below the line is wasted effort.

---

## Behavior Types

Not all behaviors are the same. Fogg categorizes behaviors by their relationship to time and repetition:

### One-Time Behaviors (Dot Behaviors)

Behaviors you want to happen once:
- Sign up for an account
- Complete a purchase
- Accept an invitation
- Enable a feature

**Design approach:** Spike motivation (urgency, social proof) and reduce friction. One-time behaviors can tolerate higher motivation requirements because you only need the wave once.

### Habitual Behaviors (Span Behaviors)

Behaviors you want to happen repeatedly:
- Check the dashboard daily
- Review weekly reports
- Use the collaboration tool
- Log activity

**Design approach:** Make it tiny, anchor it, celebrate it. Habitual behaviors cannot depend on motivation — they must survive the trough. This is where the Ability Chain and Tiny Habits method are critical.

### Stop Behaviors

Behaviors you want to stop:
- Churning from the product
- Skipping onboarding steps
- Ignoring notifications

**Design approach:** Stopping a behavior requires removing the prompt, reducing motivation for the unwanted behavior, or making it harder (increasing friction on the unwanted path).

---

## When Behavior Fails: Diagnostic Framework

When a target behavior isn't happening, diagnose using B=MAP:

### Step 1: Is there a Prompt?

If the user never receives a prompt, behavior won't happen — regardless of motivation and ability.

**Check:**
- Is there a visible CTA?
- Does a notification or email fire?
- Is there an environmental cue?
- Is the prompt well-timed?

**Common failure:** The product assumes users will find the feature themselves. They won't.

### Step 2: Is there Ability?

If the prompt exists but the behavior isn't happening, check ability next (not motivation).

**Check:**
- Can the user complete the behavior in under 60 seconds?
- Is any of the six Ability Chain factors a bottleneck?
- Is the behavior familiar or does it require learning?
- Are there unnecessary steps or decisions?

**Common failure:** The product team assumes users can do things they can't. Too many steps, too much cognitive load, too unfamiliar.

### Step 3: Is there Motivation?

Only check motivation last. If prompt and ability are present and the behavior still isn't happening, motivation is the issue.

**Check:**
- Does the user understand the benefit?
- Is the timing right (motivation wave present)?
- Is there a motivation mismatch (product solving wrong problem)?
- Are the three motivators (sensation, anticipation, belonging) being leveraged?

**Common failure:** The product serves a real need, but messaging and timing don't connect with the user's emotional state.

---

## Behavior Mapping for Products

### Core Behaviors to Map

For any product, identify and map these behaviors:

| Behavior Category | Examples | B=MAP Priority |
|-------------------|----------|----------------|
| **Activation** | First core action, onboarding completion | Ability + Prompt (motivation is high at start) |
| **Engagement** | Daily/weekly core actions | Ability (must survive low motivation) |
| **Retention** | Return visits, habit loops | Prompt + Ability (internal prompts take time) |
| **Expansion** | Feature adoption, upgrades | Motivation + Prompt (new behaviors need motivation) |
| **Advocacy** | Referrals, reviews, sharing | Motivation + Ability (make sharing easy) |

### The B=MAP Audit Template

For each key behavior:

1. **Describe the behavior** — Be specific: "User opens the dashboard and checks their top metric"
2. **Rate Motivation (1-5)** — How motivated is the user at the moment of the prompt?
3. **Rate Ability (1-5)** — How easy is the behavior? Which Ability Chain factor is weakest?
4. **Rate Prompt (1-5)** — Is the prompt present, well-timed, and clear?
5. **Action Line assessment** — Is the combined M+A above the threshold?
6. **Fix priority** — Address the weakest element first (usually Ability)

---

## Integration with Other Frameworks

### B=MAP and the Hook Model

Fogg's model is the scientific foundation that Nir Eyal's Hook Model builds upon. The relationship:

- **Trigger** (Hook) = **Prompt** (Fogg)
- **Action** (Hook) = **Behavior** (Fogg), governed by B=MAT/B=MAP
- **Variable Reward** (Hook) = **Motivation booster** (Fogg) — increases motivation for next cycle
- **Investment** (Hook) = **Ability builder** (Fogg) — makes product easier/more personalized over time

Use Fogg for diagnosis (why isn't this behavior happening?). Use the Hook Model for loop design (how do we create a self-reinforcing cycle?).

### B=MAP and Jobs to Be Done

JTBD identifies the aspiration (what progress the user wants). B=MAP designs the behaviors that deliver that progress. They are complementary:

1. JTBD → "What is the user trying to accomplish?"
2. B=MAP → "What specific behavior achieves that job, and is it above the Action Line?"

---

## Key Principles Summary

1. **Behavior is not about willpower.** It's a design problem.
2. **Ability is more reliable than motivation.** Always try making things easier before trying to motivate.
3. **Prompts are the forgotten element.** Many behavior failures are simply prompt failures.
4. **The Action Line is your diagnostic tool.** If behavior isn't happening, find out which element is failing.
5. **Start with ability, not motivation.** Ability improvements are permanent; motivation is temporary.
6. **Different behavior types need different strategies.** One-time behaviors can tolerate motivation dependency; habits cannot.
