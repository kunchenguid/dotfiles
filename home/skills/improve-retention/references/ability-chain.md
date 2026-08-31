# The Ability Chain

Ability in the Fogg Behavior Model is not a single dimension. It is a chain of six factors — and the chain is only as strong as its weakest link.

## The Six Simplicity Factors

Simplicity is always relative to the person and context. A behavior is "easy" when the cost across all six factors is low enough for the specific user at the specific moment.

### 1. Time

**Definition:** How long does the behavior take?

**Product examples:**
- Sign up with Google SSO (5 seconds) vs. fill out a 10-field form (3 minutes)
- One-tap checkout vs. re-entering credit card details
- Pre-loaded dashboard vs. configuring from scratch

**Simplification strategies:**
- Pre-fill everything possible
- Use progressive disclosure (ask for more later)
- Show estimated time: "Takes 30 seconds"
- Eliminate optional fields from required flows
- Auto-save progress so users can stop and resume

**Audit question:** Can the user complete this behavior in under 60 seconds?

---

### 2. Money

**Definition:** What is the financial cost of the behavior?

**Product examples:**
- Free tier removes money as a barrier entirely
- Free trial defers the money decision
- "No credit card required" eliminates even the perceived cost

**Simplification strategies:**
- Offer a free tier or trial
- Remove credit card requirements for signup
- Show pricing transparently (no surprises)
- Offer money-back guarantees to reduce perceived risk
- Use value-based pricing that feels fair relative to outcome

**Audit question:** Does the user need to spend or commit money to do this behavior?

---

### 3. Physical Effort

**Definition:** How much physical work is required?

**Product examples:**
- One-tap actions vs. multi-step workflows
- Thumb-friendly mobile targets vs. tiny buttons
- Voice input vs. typing on mobile
- Copy-paste vs. manual re-entry

**Simplification strategies:**
- Increase touch target sizes (minimum 44pt)
- Place primary actions in thumb-reach zones on mobile
- Use swipe gestures for frequent actions
- Support voice input, camera input, and autocomplete
- Minimize typing — use selectors, toggles, and pickers

**Audit question:** How many taps, clicks, or physical actions are required?

---

### 4. Mental Effort (Brain Cycles)

**Definition:** How much thinking does the behavior require?

**Product examples:**
- Smart defaults eliminate decisions
- Templates reduce blank-page anxiety
- Guided wizards vs. open-ended configuration
- Clear labels vs. ambiguous options

**Simplification strategies:**
- Set smart defaults (users rarely change them)
- Provide templates and examples
- Use progressive disclosure — show complexity only when needed
- Reduce choices (Hick's Law: more options = slower decisions)
- Use familiar patterns — don't make users learn new conventions
- Label everything clearly — no jargon, no ambiguity

**Audit question:** Does the user need to think, decide, or figure anything out?

---

### 5. Social Deviance

**Definition:** Does the behavior require going against social norms?

**Product examples:**
- Using a tool no one on the team uses yet (high social deviance)
- Sharing personal data on a new platform (moderate)
- Using an industry-standard tool everyone uses (zero)

**Simplification strategies:**
- Show social proof: "Used by 50,000 teams"
- Display logos of respected companies using the product
- Show teammates already on the platform
- Frame behaviors as normal: "Most users do this in the first week"
- Reduce visibility of risky actions (private by default)

**Audit question:** Would the user feel weird, embarrassed, or out of place doing this?

---

### 6. Non-Routine

**Definition:** Does the behavior require breaking existing habits or learning something new?

**Product examples:**
- Switching from email to a new messaging tool (high non-routine)
- Adding a feature to an app you already use daily (low)
- Adopting a workflow that matches your current process (low)

**Simplification strategies:**
- Mirror existing tools and conventions (familiar UI patterns)
- Import data from existing tools
- Map to existing workflows: "Works with tools you already use"
- Offer migration paths from competitors
- Start with behaviors that fit into existing routines

**Audit question:** Is this something the user already does regularly, or is it brand new?

---

## The Friction Audit

A friction audit systematically evaluates each of the six factors for a specific behavior.

### Friction Audit Template

For each key product behavior, rate each factor 1-5:

| Factor | Rating (1-5) | Notes | Fix |
|--------|-------------|-------|-----|
| Time | | How long does it take? | |
| Money | | What's the financial cost? | |
| Physical Effort | | How many actions required? | |
| Mental Effort | | How much thinking needed? | |
| Social Deviance | | Is it socially comfortable? | |
| Non-Routine | | Is it familiar? | |

**Rating scale:**
- 5 = No friction at all
- 4 = Minimal friction
- 3 = Moderate friction
- 2 = Significant friction (likely bottleneck)
- 1 = Major friction (definitely blocking behavior)

**The weakest link:** Your lowest-rated factor is where behavior is most likely to fail. Fix this first.

### Example: SaaS Onboarding Friction Audit

**Behavior:** New user creates their first project

| Factor | Rating | Notes | Fix |
|--------|--------|-------|-----|
| Time | 3 | Takes 4 minutes, too many fields | Pre-fill with smart defaults, reduce to 3 fields |
| Money | 5 | Free tier, no card needed | None needed |
| Physical Effort | 4 | Desktop form, reasonable | Minor — add keyboard shortcuts |
| Mental Effort | 2 | User must name project, choose settings, understand terminology | **BOTTLENECK** — Add templates, explain terms, set defaults |
| Social Deviance | 4 | Common tool category | Minor — add social proof |
| Non-Routine | 3 | New tool, unfamiliar UI | Mirror competitor patterns, add guided tour |

**Priority fix:** Mental effort is the bottleneck. Add project templates ("Start with a template") and smart defaults that eliminate decisions.

---

## Simplification Strategies by Factor

### Universal Strategies (Help All Factors)

1. **Shrink the behavior** — Make it smaller (Starter Step)
2. **Set defaults** — Eliminate decisions
3. **Progressive disclosure** — Start simple, reveal complexity later
4. **Pre-fill with data** — Use what you know about the user

### The Simplicity Ladder

When a behavior is too hard, climb down the simplicity ladder:

| Level | Strategy | Example |
|-------|----------|---------|
| **Full behavior** | Complete the target action | "Set up your workspace with channels, permissions, and integrations" |
| **Reduced version** | Remove optional steps | "Set up your workspace (we'll handle permissions later)" |
| **Guided version** | Add a wizard or templates | "Choose a workspace template" |
| **Starter Step** | Tiniest meaningful version | "Name your workspace" |
| **Preview** | Show value without requiring action | "Here's what your workspace could look like" |

Start at whatever level gets users above the Action Line. Then gradually move them up.

---

## Ability Chain Across User Journey

Different stages of the user journey have different Ability Chain bottlenecks:

| Stage | Typical Bottleneck | Why |
|-------|-------------------|-----|
| **First visit** | Mental effort, non-routine | User doesn't understand the product yet |
| **Signup** | Time, money | Friction gates (forms, pricing) |
| **Onboarding** | Mental effort, non-routine | Learning new tool, making decisions |
| **First value** | Mental effort, time | Finding the core action and completing it |
| **Daily use** | Time, physical effort | Behavior must be fast and easy to sustain |
| **Feature adoption** | Mental effort, non-routine | Learning new capabilities |
| **Team adoption** | Social deviance, non-routine | Getting others to change behavior |

---

## Common Friction Patterns

| Pattern | What Happens | Fix |
|---------|-------------|------|
| **The Empty State** | User faces blank page with no guidance | Add templates, examples, sample data |
| **The Decision Overload** | Too many options, user freezes | Reduce choices, recommend one, use smart defaults |
| **The Terminology Wall** | Jargon-heavy UI confuses new users | Use plain language, add tooltips, match user vocabulary |
| **The Configuration Maze** | Too many settings before first value | Ship opinionated defaults, let users customize later |
| **The Onboarding Marathon** | 10-step setup before any value | Defer everything non-essential, deliver value in step 1 |
| **The Mobile Tax** | Desktop-designed flows on mobile | Redesign for mobile-first, minimize typing |
