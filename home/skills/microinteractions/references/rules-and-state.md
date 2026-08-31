# Rules and State in Microinteractions

Rules are the invisible engine of a microinteraction. Once a trigger fires, rules determine what happens: what changes, in what order, with what constraints, and when the interaction ends. Users never see rules directly -- they experience their effects through feedback. But when rules are poorly designed, users feel it immediately: the toggle that does not remember its position, the slider that jumps to unexpected values, the form that erases their input on error.

## What Rules Define

Every microinteraction's rules answer these questions:

| Question | What It Determines | Example |
|----------|-------------------|---------|
| What happens first? | The initial response to the trigger | Button text changes to "Saving..." |
| What sequence follows? | Steps that occur in order | Validate input, send request, show result |
| What can the user do during? | Available actions while processing | Cancel button appears during upload |
| What can the user NOT do? | Constraints that prevent errors | Cannot submit form with empty required fields |
| What are the boundaries? | Minimum, maximum, and default values | Character limit: 280; volume: 0-100%; quantity: 1-99 |
| When does it end? | Completion condition | Request returns success; timer reaches zero |
| What if it fails? | Error handling behavior | Show error message, preserve input, suggest fix |

---

## Defining Rules: The Goal-First Method

Start with the goal, not the interface. What is the user trying to accomplish? Derive every rule from that goal.

### Process

1. **State the goal in one sentence:** "The user wants to set their alarm time."
2. **Identify the minimum inputs:** Time (hour, minute), AM/PM, days of week.
3. **Define the simplest path:** Tap time, scroll to desired hour/minute, toggle AM/PM, select days, confirm.
4. **Add constraints:** Cannot set alarm in the past (today). Maximum 20 alarms. Minimum interval between alarms: 1 minute.
5. **Handle failures:** If alarm cannot be set (permission denied), show error with action to fix it.
6. **Define the end state:** Alarm is set, confirmation shown, alarm appears in list.

### Rule Complexity vs. Frequency

| Usage Frequency | Rule Complexity | Rationale | Example |
|-----------------|-----------------|-----------|---------|
| **Many times per day** | Minimal rules, zero configuration | Must be instant and frictionless | Liking a post: one tap, done |
| **Once per day** | Simple rules, smart defaults | Allow some configuration | Setting an alarm: time + days |
| **Once per week** | Moderate rules, options available | Users can invest time | Scheduling a meeting: time, attendees, recurrence |
| **Once ever** | Full rule set, onboarding acceptable | First-time setup | Account creation: email, password, preferences |

---

## State Management Within Microinteractions

Every microinteraction has state -- the current condition of the interaction at any given moment. Managing state well means users always know where they are, what happened, and what they can do next.

### Core States of a Microinteraction

| State | Description | Visual Indicator | User Can... |
|-------|-------------|------------------|-------------|
| **Idle** | Ready and waiting for trigger | Default appearance | Initiate the interaction |
| **Active/In Progress** | Processing or awaiting input | Loading spinner, active color | Cancel, wait, or provide input |
| **Success** | Completed successfully | Green checkmark, confirmation text | Move on, undo (if available) |
| **Error** | Failed to complete | Red indicator, error message | Retry, correct input, dismiss |
| **Partial** | Partially complete or partially loaded | Partial progress, skeleton | Continue, wait for more |
| **Disabled** | Cannot be initiated | Grayed out, reduced opacity | Nothing (show reason on hover/focus) |

### State Transition Map

Map every possible transition between states to ensure no combination is overlooked:

```
                    ┌─────────┐
          trigger   │  IDLE   │  reset
         ┌─────────→│         │←──────────┐
         │          └────┬────┘           │
         │               │ trigger        │
         │               ▼                │
         │         ┌──────────┐           │
         │         │  ACTIVE  │───────────┤
         │         │          │   cancel   │
         │         └────┬─────┘           │
         │           ┌──┴──┐              │
         │           │     │              │
         │       success  fail            │
         │           │     │              │
         │           ▼     ▼              │
         │     ┌────────┐ ┌───────┐       │
         │     │SUCCESS │ │ ERROR │       │
         │     │        │ │       │──retry─┘
         │     └───┬────┘ └───────┘
         │         │ timeout/dismiss
         └─────────┘
```

### State Persistence

| Persistence Type | When to Use | Storage Method | Example |
|-----------------|-------------|----------------|---------|
| **Ephemeral** | Within a single session | Component state (React state, SwiftUI @State) | Hover state, dropdown open/closed |
| **Session** | Across page navigations, lost on close | Session storage, navigation state | Form progress, scroll position |
| **Persistent** | Across sessions, survives app close | Local storage, database, user preferences | Theme setting, notification preferences |
| **Synced** | Across devices | Cloud database, account-linked storage | Read/unread status, bookmarks |

---

## Constraints and Limitations

Constraints are rules that prevent errors by limiting what users can do. Well-designed constraints feel natural -- users do not notice them because the wrong action was never possible.

### Types of Constraints in Microinteractions

| Constraint Type | Mechanism | Example |
|----------------|-----------|---------|
| **Range** | Limit input to min/max values | Volume slider: 0-100%, cannot exceed |
| **Format** | Enforce specific input patterns | Phone field: auto-formats as (555) 123-4567 |
| **Type** | Restrict input to valid characters | Numeric field: keyboard shows numbers only |
| **Sequence** | Enforce step order | Payment flow: shipping before payment before confirm |
| **Dependency** | One option enables/disables others | "Ship to different address" checkbox reveals address form |
| **Capacity** | Limit quantity or selection count | File upload: maximum 5 files, 10MB each |
| **Temporal** | Restrict timing of actions | "Undo send": available for 30 seconds only |

### Implementing Constraints Gracefully

**Prevent rather than punish.** The best constraint is one users never encounter because the wrong action was impossible:

| Punishing (bad) | Preventing (good) |
|----------------|-------------------|
| "Invalid date format" error after typing | Date picker control that only allows valid dates |
| "That username is taken" after submitting form | Real-time availability check as user types |
| "File too large" error after waiting for upload | Show size limit upfront; disable upload for oversized files |
| "Cannot select past dates" error message | Gray out and disable past dates in calendar |

### Communicating Constraints

| Method | When to Use | Example |
|--------|-------------|---------|
| **Disabled state** | Action not available yet | Submit button grayed until form is valid |
| **Counter** | Approaching a limit | "23/280 characters" or "3 of 5 files uploaded" |
| **Visual boundary** | Range limits | Slider track shows min/max; cursor stops at edges |
| **Inline hint** | Format requirements | "Must be 8+ characters with one number" below password field |
| **Progressive disclosure** | Complex constraints | Advanced options hidden behind "Show more" |

---

## Error States

Error states are what happens when rules are violated or when the system fails. Error handling is where most microinteractions fall apart -- and where thoughtful design has the most impact on user trust.

### Error State Principles

**1. Preserve the user's work.** Never erase input on error. If a form fails validation, keep everything the user typed.

**2. Explain in human language.** Not "Error 422: Unprocessable Entity" but "That email address looks incomplete. Did you forget the domain (e.g., @gmail.com)?"

**3. Point to the problem.** Show the error next to the field that caused it, not in a banner at the top of the page.

**4. Offer a path forward.** Every error message should suggest a fix or offer an alternative.

**5. Time it right.** Validate on blur (when the user leaves the field) for format errors; validate on submit for cross-field errors.

### Error State Taxonomy

| Error Type | Cause | Detection Timing | Display Strategy |
|-----------|-------|-------------------|------------------|
| **Format error** | Wrong input pattern (email, phone) | On blur or real-time | Inline message below field |
| **Missing required** | Required field left empty | On submit | Highlight field, inline message |
| **Range error** | Value outside allowed range | Real-time or on blur | Inline message with valid range |
| **Conflict error** | Input conflicts with existing data | On submit (requires server check) | Inline with suggestion |
| **System error** | Server failure, network issue | On submit | Banner or modal with retry option |
| **Permission error** | User lacks authorization | On trigger | Disable trigger or show explanation |
| **Timeout error** | Operation took too long | After threshold | Message with retry; preserve input |

### Error Recovery Patterns

| Pattern | How It Works | Example |
|---------|-------------|---------|
| **Inline correction** | User fixes error in place | Red-bordered field; user retypes; border turns green |
| **Undo** | Reverse the action that caused the error | "Undo" link in error toast message |
| **Retry** | Attempt the same action again | "Retry" button after network timeout |
| **Suggestion** | System proposes a valid alternative | "Did you mean john@gmail.com?" |
| **Fallback** | System provides an alternative path | "Upload failed. Try a smaller file or paste a URL instead." |
| **Graceful degradation** | System completes partial operation | "3 of 5 files uploaded. Retry remaining?" |

---

## Edge Cases

Edge cases are the boundary conditions where microinteractions often break. Designing for edge cases means asking "What happens when...?" for every unusual situation.

### Essential Edge Cases to Design For

| Edge Case | Question | Design Response |
|-----------|----------|-----------------|
| **Empty state** | What if there is no data? | Show helpful empty state with CTA |
| **Zero value** | What if the count is zero? | "No notifications" not "Notifications (0)" |
| **Maximum value** | What if the limit is reached? | Disable further input; show "Maximum reached" |
| **Rapid repeated trigger** | What if user clicks 10 times fast? | Debounce; disable trigger during processing |
| **Interruption** | What if user navigates away mid-action? | Save progress or warn before leaving |
| **Slow connection** | What if the request takes 30 seconds? | Show progress; allow cancel |
| **No connection** | What if the user is offline? | Queue action; show "Will send when online" |
| **Concurrent edit** | What if two users edit the same thing? | Detect conflict; show merge options |
| **Very long input** | What if the user enters 10,000 characters? | Truncate display; show full on expand |
| **Special characters** | What if input contains emoji, HTML, or Unicode? | Sanitize and display correctly |
| **Screen reader** | What if the user cannot see the visual feedback? | Announce state changes via aria-live regions |
| **Keyboard only** | What if the user cannot use a mouse? | Ensure all triggers are focusable and operable via keyboard |

### Edge Case Testing Methodology

1. **Boundary values:** Test at 0, 1, max-1, max, and max+1 for any numeric input.
2. **Empty/full:** Test with no data and with maximum data.
3. **Speed:** Test with instant response, 3-second delay, and 30-second delay.
4. **Interruption:** Test what happens when the user closes the browser, loses connection, or switches apps mid-action.
5. **Repetition:** Test triggering the same action 10 times rapidly.
6. **Platform variety:** Test on the slowest supported device and smallest supported screen.

---

## What NOT to Allow

Deciding what NOT to allow is as important as deciding what to allow. Good rules prevent harmful, confusing, or destructive actions.

### Actions to Prevent

| Action to Prevent | Why | How to Prevent |
|-------------------|-----|----------------|
| **Double submission** | Duplicates orders, messages, payments | Disable trigger on first click; debounce |
| **Deleting without confirmation** | Irreversible data loss | Confirmation dialog for destructive actions |
| **Submitting invalid data** | Creates bad records, user confusion | Client-side validation before submission |
| **Exceeding rate limits** | Overloads system, degrades experience | Throttle triggers; show "Try again in X seconds" |
| **Conflicting selections** | Logical impossibility (depart after arrive) | Disable impossible options based on other selections |
| **Accidental mode entry** | User does not realize they changed context | Require deliberate action (not hover) to enter modes |

### The "Nothing Should Happen" Cases

Some trigger activations should produce no result -- and that is a deliberate rule:

| Situation | Rule | Feedback |
|-----------|------|----------|
| Clicking a disabled button | No action | Show tooltip explaining why it is disabled |
| Submitting an empty required field | No submission | Highlight field; show "Required" |
| Dragging a non-draggable item | No movement | No cursor change; no visual response |
| Pressing a key outside valid range | No input | No character appears; optionally shake field |
| Tapping outside a modal | Close modal (if non-critical) or no action (if critical) | Modal dismisses or overlay flashes briefly |

---

## State Design Checklist

- [ ] Have you defined every possible state (idle, active, success, error, disabled, partial)?
- [ ] Can users always tell which state the interaction is in?
- [ ] Have you mapped every state transition?
- [ ] Have you defined what is NOT allowed?
- [ ] Do constraints prevent errors instead of punishing them?
- [ ] Are error messages human-readable, specific, and actionable?
- [ ] Is user input preserved on error?
- [ ] Have you tested all edge cases (empty, max, rapid, offline, interrupted)?
- [ ] Is state persistence appropriate (ephemeral vs. session vs. permanent)?
- [ ] Can screen reader users perceive state changes?
