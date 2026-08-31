# Trigger Design for Microinteractions

A trigger is what initiates a microinteraction. It is the entry point -- the doorknob, the button, the notification badge. Triggers come in two fundamental types: manual triggers that users consciously activate, and system triggers that fire automatically when conditions are met. Every microinteraction begins with one of these, and the quality of the trigger determines whether users can discover, understand, and initiate the interaction at all.

## Manual Triggers

Manual triggers require a deliberate user action. They live inside UI controls -- buttons, switches, icons, form fields, gestures, voice commands. The user must perceive the trigger, understand what it does, and act on it.

### Types of Manual Triggers

| Trigger Type | Mechanism | Best For | Example |
|-------------|-----------|----------|---------|
| **Tap/Click** | Single press on a target | Most common actions | Submit button, checkbox, link |
| **Long press** | Press and hold | Secondary actions, previews | iOS Haptic Touch preview, Android context menu |
| **Swipe** | Horizontal or vertical drag | Spatial navigation, destructive actions | Swipe to delete, swipe between pages |
| **Drag** | Press, hold, and move | Reordering, adjusting values | Slider thumb, list reordering |
| **Pinch/Spread** | Two-finger scale gesture | Zoom, resize | Map zoom, photo zoom |
| **Double-tap** | Two rapid taps | Quick positive action | Instagram double-tap to like |
| **Voice** | Spoken command | Hands-free contexts | "Hey Siri, set a timer" |
| **Type** | Keyboard input | Search, data entry | Search-as-you-type, password field |

### Manual Trigger Design Principles

**1. Affordance clarity:** The trigger must look like what it does. A toggle should look slideable. A button should look pressable. A drag handle should look grabbable.

**2. Action labeling:** Whenever possible, label the trigger with a verb that describes the outcome: "Save," "Send," "Delete." Avoid vague labels like "Submit," "OK," or "Continue."

**3. Size and touch targets:** Touch triggers must be at least 44x44 points (Apple HIG) or 48x48dp (Material Design). Desktop triggers should be at least 24x24 pixels with generous click padding.

**4. Placement convention:** Triggers should appear where users expect them based on platform conventions:

| Action Type | Expected Position | Platform Convention |
|-------------|-------------------|---------------------|
| Primary action | Bottom-right (mobile), top-right (desktop) | FAB on Android, toolbar on macOS |
| Cancel/Back | Top-left (mobile), bottom-left (dialogs) | Back chevron on iOS, Escape key on desktop |
| Destructive | Bottom of menu, separated from safe actions | Red text, separated by divider |
| Settings | Top-right corner or hamburger menu | Gear icon, three dots |
| Search | Top of screen, center or right | Magnifying glass icon |

**5. Discoverability hierarchy:**

| Visibility Level | When to Use | Example |
|------------------|-------------|---------|
| **Always visible** | Primary actions, frequent use | Send button in messaging app |
| **Visible on hover/focus** | Secondary actions, contextual | Edit icon appears on card hover |
| **Visible on gesture** | Tertiary actions, power users | Swipe to reveal archive/delete |
| **Hidden (keyboard shortcut)** | Expert acceleration | Cmd+K for command palette |

---

## System Triggers

System triggers fire automatically when predefined conditions are met. The user does not initiate them -- the system detects a change in state and responds.

### Types of System Triggers

| Trigger Condition | How It Works | Example |
|-------------------|-------------|---------|
| **Time-based** | Fires at a specific time or after a duration | Alarm at 7am, session timeout at 30 minutes |
| **Threshold-based** | Fires when a value crosses a limit | Low battery at 20%, storage full at 95% |
| **Data-based** | Fires when new data arrives | New email, incoming message, price change |
| **Location-based** | Fires when user enters or exits a geofence | "You're near a store" reminder, weather alerts |
| **State-change** | Fires when system state changes | Connection lost, sync complete, download finished |
| **Error-based** | Fires when an error condition is detected | Form validation failure, payment declined |
| **Inactivity** | Fires after a period of no user input | Screen dims after 30 seconds, "Are you still watching?" |

### System Trigger Design Principles

**1. Relevance over frequency:** A system trigger should fire only when the information is genuinely useful at that moment. Every unnecessary notification erodes trust and trains users to ignore triggers.

**2. Threshold calibration:** Set thresholds that balance urgency with usefulness:

| Too Early | Right Threshold | Too Late |
|-----------|-----------------|----------|
| Battery warning at 50% | Battery warning at 20% | Battery warning at 2% |
| Disk full warning at 50% | Disk full warning at 90% | Disk full warning at 99% |
| Inactivity timeout at 1 min | Inactivity timeout at 15 min | Inactivity timeout at 2 hours |

**3. Escalation:** Important system triggers should escalate if ignored:

```
Passive indicator → Active notification → Blocking alert
(badge count)      (banner/toast)         (modal dialog)
```

**4. Silencing rules:** Users must be able to silence system triggers. Provide:
- Global mute (Do Not Disturb)
- Per-category control (mute marketing, keep security)
- Scheduled quiet hours

---

## Trigger States

Every manual trigger exists in multiple states. Users must be able to distinguish each state at a glance.

### The Five Essential Trigger States

| State | Visual Treatment | Purpose | Example |
|-------|-----------------|---------|---------|
| **Default** | Normal appearance, ready for interaction | Shows availability | Blue button with white text |
| **Hover** | Subtle change on cursor proximity | Confirms interactivity (desktop only) | Background darkens slightly |
| **Active/Pressed** | Visual depression or color shift | Confirms action registration | Button scales down 2%, color deepens |
| **Disabled** | Reduced opacity, no cursor change | Prevents action, shows unavailability | 40% opacity, cursor: not-allowed |
| **Loading** | Spinner or animation replaces label | Shows processing in progress | Spinner replaces "Save" text |

### Additional States for Complex Triggers

| State | When Used | Visual Treatment | Example |
|-------|-----------|-----------------|---------|
| **Focus** | Keyboard navigation | Focus ring or outline | Blue 2px outline on Tab focus |
| **Selected/On** | Toggle or checkbox in active state | Filled, checked, or colored | Toggle thumb slides right, track turns green |
| **Error** | Associated input has validation error | Red border, error icon | Red outline on text field |
| **Success** | Action completed successfully | Green checkmark, brief animation | Checkmark replaces spinner for 1.5s |

### State Transition Timing

| Transition | Duration | Easing | Why |
|-----------|----------|--------|-----|
| Default to Hover | Instant or 50ms | ease-out | Must feel responsive to cursor |
| Default to Active | Instant | none | Must feel like physical press |
| Active to Loading | Instant | none | Immediate acknowledgment |
| Loading to Success | 200-400ms | ease-in-out | Smooth enough to notice |
| Loading to Error | 200-400ms | ease-in-out | Smooth enough to notice |
| Any to Disabled | 150ms | ease-out | Gentle enough not to flash |

---

## Designing Invisible Triggers

Some triggers have no visible control -- they rely on gestures, sensor input, or spatial awareness. These are powerful but dangerous because they have zero discoverability.

### When Invisible Triggers Are Appropriate

| Appropriate | Inappropriate |
|-------------|---------------|
| Shortcut for an action also available through a visible trigger | Only way to access a feature |
| Power-user acceleration | First-time user critical path |
| Delight/easter egg with no functional consequence | Destructive or irreversible action |
| Platform-standard gesture (pinch to zoom) | Novel gesture with no convention |

### Making Invisible Triggers Learnable

**1. One-time coaching:** Show a brief animation or tooltip on first use demonstrating the gesture.

**2. Partial reveal:** Show just enough to hint at the interaction. For swipe-to-delete, show the edge of the red "Delete" background peeking out slightly.

**3. Contextual hint:** When the user appears stuck (long pause, repeated taps), show a tooltip: "Try swiping left to delete."

**4. Progressive discovery:** Let users stumble onto the trigger through natural exploration, then reinforce it. Pull-to-refresh was initially invisible but became a platform convention through consistent implementation.

### Invisible Trigger Checklist

- [ ] Is there a visible alternative for the same action?
- [ ] Is the gesture a platform convention (not a custom invention)?
- [ ] Do you provide coaching for first-time users?
- [ ] Does the trigger work reliably (no accidental fires)?
- [ ] Can users undo the result if they trigger it accidentally?

---

## Trigger Placement and Visibility

Where a trigger lives on screen determines whether users find it. Placement follows predictable patterns based on reading order, platform convention, and visual hierarchy.

### Visibility Priority Framework

| Priority | Screen Position | What Goes Here |
|----------|----------------|----------------|
| **1 (highest)** | Center of viewport | Primary CTA, hero action, onboarding step |
| **2** | Top-right (desktop) or bottom-center (mobile) | Primary persistent action (FAB, "New" button) |
| **3** | Inline with content | Contextual actions (edit, delete, reply) |
| **4** | Navigation bar / toolbar | Frequent global actions (search, settings) |
| **5 (lowest)** | Overflow menu, long-press, swipe | Secondary and tertiary actions |

### Fitts's Law Application

Fitts's Law states that the time to reach a target is proportional to the distance and inversely proportional to the target size. Practical implications:

- **Corners and edges are easy targets** on desktop (cursor stops at screen edge). Place primary actions near edges.
- **Bottom of screen is easy to reach** on mobile (thumb zone). Place primary actions in the bottom third.
- **Larger triggers are faster to hit.** Primary actions should be physically larger than secondary ones.
- **Distance matters.** Group related triggers together to reduce travel between sequential actions.

### Trigger Grouping Patterns

| Pattern | When to Use | Example |
|---------|-------------|---------|
| **Toolbar** | Multiple peer-level actions | Text formatting: Bold, Italic, Underline |
| **Action group** | Primary + secondary actions | "Save" (primary) + "Save as Draft" (secondary) |
| **Contextual menu** | Many actions on a single object | Right-click: Copy, Paste, Delete, Rename |
| **FAB with expansion** | Primary action with variants | "+" FAB expands to: New Message, New Group, New Channel |
| **Inline actions** | Actions tied to specific content | Reply, Like, Share below a social post |

---

## Trigger Audit Checklist

Use this checklist to evaluate triggers across an interface.

### Discoverability
- [ ] Can a first-time user find the trigger within 5 seconds?
- [ ] Is the trigger labeled with a clear verb (not "Submit" or "OK")?
- [ ] Does the trigger look interactive (distinct from static elements)?
- [ ] Is the trigger large enough for its input method (touch: 44pt+, mouse: 24px+)?

### State Communication
- [ ] Can users distinguish default, hover, active, disabled, and loading states?
- [ ] Does the disabled state explain why it is disabled (tooltip or nearby text)?
- [ ] Does the loading state indicate progress or at least activity?
- [ ] Is the success/error state visible for long enough to register?

### Placement
- [ ] Is the trigger where platform conventions suggest?
- [ ] Is the primary action more visually prominent than secondary actions?
- [ ] Are related triggers grouped together?
- [ ] Is the trigger reachable with one hand on mobile (bottom two-thirds of screen)?

### Edge Cases
- [ ] What happens on double-tap/double-click? (Prevent duplicate submissions)
- [ ] What happens if the trigger is activated during loading? (Disable or queue)
- [ ] What happens on very slow connections? (Show loading state immediately)
- [ ] What if the user activates the trigger and navigates away? (Handle gracefully)
