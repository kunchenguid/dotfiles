# Feedback Patterns for Microinteractions

Feedback is how a microinteraction communicates its rules to the user. It answers the most fundamental question in any interaction: "What just happened?" Without feedback, users operate in the dark -- unsure if their action registered, if the system is working, or if the result was what they intended. Feedback bridges the Gulf of Evaluation by making the invisible visible.

## The Feedback Hierarchy

Not all feedback is equal. The type, intensity, and duration of feedback should match the significance of the event.

| Event Significance | Feedback Level | Duration | Example |
|-------------------|---------------|----------|---------|
| **Micro** (hover, focus) | Subtle visual change | Instant, continuous | Background lightens on hover |
| **Minor** (tap, toggle) | Clear visual change | 100-300ms | Toggle slides, color shifts |
| **Medium** (save, send) | Visual change + state label | 1-3 seconds | "Saved" text appears briefly |
| **Major** (purchase, delete) | Multi-signal confirmation | 3-5 seconds, user-dismissable | Confirmation banner with undo option |
| **Critical** (error, failure) | Prominent, persistent | Until acknowledged | Red banner with error message and action |

### The Minimum Feedback Rule

**Use the least amount of feedback that still communicates the message.** A hover state does not need a sound effect. A successful save does not need a modal dialog. A button press does not need a full-screen animation. Escalate feedback only when the event demands it.

---

## Visual Feedback

Visual feedback is the primary feedback channel for nearly every microinteraction. It is silent, non-intrusive, and universally accessible (when designed with sufficient contrast).

### Color Changes

| Pattern | When to Use | Implementation | Example |
|---------|-------------|---------------|---------|
| **State color shift** | Show current state | Background or border color changes | Toggle track: gray (off) to green (on) |
| **Validation color** | Indicate input validity | Border or icon color changes | Green border = valid, red border = invalid |
| **Progress color** | Show completion level | Fill color changes as progress increases | Upload bar shifts from blue to green at 100% |
| **Attention color** | Draw focus to a change | Brief highlight animation | Row flashes yellow after being updated |
| **Semantic color** | Communicate meaning | Consistent color system | Red = error, green = success, yellow = warning, blue = info |

### Animations

| Animation Type | Duration | Easing | When to Use | Example |
|---------------|----------|--------|-------------|---------|
| **Button press** | 50-100ms | ease-out | Every button interaction | Scale down to 0.97, then back |
| **Toggle slide** | 150-250ms | ease-in-out | Binary state change | Thumb slides from left to right |
| **Expand/collapse** | 200-300ms | ease-in-out | Revealing or hiding content | Accordion section opens smoothly |
| **Fade in/out** | 150-300ms | ease-in (in), ease-out (out) | Elements appearing/disappearing | Toast notification fades in |
| **Slide in/out** | 200-400ms | ease-out (in), ease-in (out) | Panels, drawers, sheets | Side panel slides from right edge |
| **Skeleton to content** | 200-400ms | ease-in-out | Content loading | Gray placeholders crossfade to real content |
| **Checkmark draw** | 300-500ms | ease-out | Success confirmation | SVG checkmark animates stroke from left to right |
| **Shake** | 300-500ms | ease-in-out (oscillate) | Invalid input | Field shakes horizontally 2-3 times |
| **Bounce** | 200-400ms | spring | Attention, arrival | New item bounces into list |

### Animation Principles for Microinteractions

**1. Purpose over decoration.** Every animation should communicate something: state change, direction, connection, or confirmation. If you cannot articulate what the animation communicates, remove it.

**2. Interruptible.** If the user acts before an animation completes, the animation should yield to the new action. Never make users wait for an animation to finish.

**3. Consistent timing.** Use a small set of durations (100ms, 200ms, 300ms, 500ms) and apply them consistently by category. Do not use random durations.

**4. Physics-based easing.** Use ease-out for elements entering (decelerating arrival), ease-in for elements leaving (accelerating departure), and ease-in-out for elements that stay but change state.

### Progress Indicators

| Indicator Type | When to Use | Design Details |
|---------------|-------------|----------------|
| **Determinate progress bar** | Duration is known or estimable | Shows percentage; bar fills left to right; show time remaining if > 10s |
| **Indeterminate spinner** | Duration is unknown, expected < 10s | Rotating circle or dots; use brand-consistent style |
| **Skeleton screen** | Content layout is known, data loading | Gray rectangles matching final layout shape and size |
| **Percentage text** | Long operations where users want precision | "47% complete" text; pair with progress bar |
| **Step indicator** | Multi-step process | "Step 2 of 4" with visual step markers |
| **Inline spinner** | Loading within a specific component | Small spinner inside the button or field that triggered loading |

### Progress Indicator Selection Guide

| Load Time | Best Indicator | Why |
|-----------|---------------|-----|
| < 0.3s | None (instant) | Any indicator would flash and distract |
| 0.3-1s | Subtle inline spinner | Acknowledges loading without overdoing it |
| 1-5s | Skeleton screen or spinner | Shows the system is working |
| 5-30s | Determinate progress bar | Users need to see progress |
| 30s+ | Progress bar + percentage + estimated time | Users need reassurance and ability to leave |

---

## Audio Feedback

Audio feedback provides confirmation through sound. It is powerful when visual attention is elsewhere, but it is easily annoying and must be used sparingly.

### When Audio Feedback Is Appropriate

| Appropriate | Inappropriate |
|-------------|---------------|
| Confirmation of important action (payment, send) | Every button click |
| Error that needs immediate attention | Form validation errors |
| Background task completion (download, print) | Hover or focus changes |
| Accessibility (screen reader announcements) | Decorative or branding sounds |
| Physical product interaction (keyboard typing) | Any action that occurs frequently (> 10x/min) |

### Audio Feedback Design Rules

**1. Short.** Sounds should be 50-200ms for confirmations, up to 1 second for completions. Never longer.

**2. Quiet.** Default volume should be unobtrusive. Users should be able to disable all sounds.

**3. Distinct.** Success and error sounds must be obviously different -- do not rely on subtle pitch changes.

**4. Non-verbal.** Avoid spoken words in feedback sounds (they do not scale across languages and are slow). Pure tones or abstract sounds work best.

**5. Consistent.** Use the same sound for the same type of event across the entire product. Success always sounds the same.

### Audio Feedback Patterns

| Event | Sound Character | Duration | Example Reference |
|-------|----------------|----------|-------------------|
| **Success** | Rising pitch, major chord | 100-300ms | iOS payment success chime |
| **Error** | Low buzz or discordant tone | 100-200ms | macOS alert sound |
| **Notification** | Gentle chime, mid-range | 200-500ms | Slack notification ding |
| **Completion** | Satisfying click or chime | 100-200ms | Camera shutter sound |
| **Typing** | Soft click per keystroke | 20-50ms | iPhone keyboard clicks |
| **Delete/Trash** | Crumple or whoosh | 200-400ms | macOS trash sound |

---

## Haptic Feedback

Haptic feedback uses vibration or force feedback to communicate through touch. It is available on mobile devices and some game controllers, laptops, and wearables.

### Haptic Feedback Patterns

| Pattern | iOS API | Android API | When to Use |
|---------|---------|-------------|-------------|
| **Light tap** | .light impact | HapticFeedbackConstants.CLOCK_TICK | Toggle, checkbox, minor selection |
| **Medium tap** | .medium impact | HapticFeedbackConstants.CONTEXT_CLICK | Button press, drag snap |
| **Heavy tap** | .heavy impact | HapticFeedbackConstants.LONG_PRESS | Confirmation of significant action |
| **Success** | .success notification | Custom pattern: short-pause-long | Action completed successfully |
| **Warning** | .warning notification | Custom pattern: two short bursts | Approaching limit, caution needed |
| **Error** | .error notification | Custom pattern: three rapid bursts | Action failed, attention needed |
| **Selection tick** | .selection changed | HapticFeedbackConstants.KEYBOARD_TAP | Scrolling through picker values |

### Haptic Design Rules

**1. Pair with visual.** Haptic feedback should always accompany visual feedback, never replace it. Some devices have haptics disabled, and users with motor impairments may not feel vibrations.

**2. Match intensity to significance.** Light tap for toggles. Medium for confirmations. Heavy for warnings. Never heavy for routine actions.

**3. Use sparingly.** Constant vibration is annoying and drains battery. Reserve haptics for moments where tactile confirmation adds genuine value.

**4. Respect system settings.** Always check if the user has disabled haptic feedback at the system level. Never override this preference.

---

## Feedback Timing

When feedback occurs is as important as what feedback occurs. The human perception system has specific thresholds that determine whether feedback feels instant, delayed, or broken.

### Perception Thresholds

| Delay | User Perception | Required Feedback |
|-------|----------------|-------------------|
| **0-100ms** | Instantaneous -- feels like direct manipulation | Visual state change (color, position) |
| **100-300ms** | Slight lag but still responsive | Transition animation, inline spinner |
| **300ms-1s** | Noticeable delay | Loading indicator, cursor change |
| **1-5s** | Waiting | Spinner, skeleton screen, "Loading..." |
| **5-10s** | Attention wanders | Progress bar with estimate |
| **10-30s** | Impatient | Progress bar + percentage + "X seconds remaining" |
| **30s+** | Will leave or switch tasks | Progress bar + allow backgrounding + notification on completion |

### Optimistic UI Pattern

Show the result immediately and correct later if the action fails. This makes the interface feel instant even when the server takes time.

| Step | What Happens | Example |
|------|-------------|---------|
| 1. User triggers | Show success state immediately | Heart fills red instantly on like |
| 2. Send request | API call fires in background | POST /like runs asynchronously |
| 3a. Server confirms | Nothing changes (already showing success) | Response 200: no visual change |
| 3b. Server fails | Revert to previous state with error | Heart unfills; toast: "Could not save like" |

**When to use optimistic UI:**
- Action is very likely to succeed (> 99%)
- Reverting is possible and not confusing
- The action is low-stakes (not a payment or deletion)

**When NOT to use optimistic UI:**
- Action has a significant failure rate
- Action is irreversible
- Reverting would be confusing (e.g., message appears then disappears)

---

## Progressive Disclosure in Feedback

Not all feedback needs to appear at once. Progressive disclosure reveals information in layers, starting with the most important.

### Feedback Layering

| Layer | What It Shows | When | Example |
|-------|-------------|------|---------|
| **Immediate** | "Your action was received" | 0-100ms | Button changes state |
| **Status** | "Here's what's happening" | 100ms-3s | Spinner, progress bar |
| **Result** | "Here's the outcome" | On completion | Success message, error details |
| **Detail** | "Here's the specifics" | On demand (hover, click) | Tooltip with timestamp, expandable error log |

### Progressive Error Disclosure

| Level | What to Show | Example |
|-------|-------------|---------|
| **Summary** | One-line human-readable error | "Upload failed" |
| **Explanation** | Why it happened | "The file is too large (12MB). Maximum size is 10MB." |
| **Resolution** | How to fix it | "Try compressing the image or choosing a smaller file." |
| **Technical detail** | For developers or support | Expandable: "Error 413: Request Entity Too Large. Request ID: abc123" |

---

## Preventing Feedback Overload

Too much feedback is as bad as too little. When every action triggers a toast notification, animation, and sound, users become desensitized and miss the feedback that actually matters.

### Signs of Feedback Overload

| Symptom | Cause | Fix |
|---------|-------|-----|
| Users ignore toast notifications | Too many toasts for minor events | Reserve toasts for actions user may want to undo |
| Interface feels "jittery" | Too many animations on trivial events | Remove animation from hover/focus; keep for state changes |
| Users disable notifications | Every event sends a push notification | Tier notifications; only push for high-priority events |
| Sound becomes annoying | Every click has an audio cue | Remove audio from routine actions; keep for confirmations |
| Screen reader users overwhelmed | Too many aria-live announcements | Announce only meaningful state changes |

### Feedback Reduction Strategies

**1. Consolidate.** Instead of four separate toast messages for four file uploads, show one: "4 files uploaded successfully."

**2. Delay and batch.** Accumulate minor events and present them as a summary: "While you were away: 3 likes, 2 comments, 1 share."

**3. Tier by priority.** Define three tiers of feedback intensity and assign every event type to a tier:

| Tier | Intensity | Feedback Type | Events |
|------|-----------|--------------|--------|
| **1 (High)** | Multi-signal, persistent | Banner + sound + haptic | Errors, destructive confirmations, payment success |
| **2 (Medium)** | Single signal, temporary | Toast or inline text | Save success, status change, minor warning |
| **3 (Low)** | Minimal, passive | Visual state change only | Hover, focus, toggle, minor selection |

**4. Respect context.** Reduce feedback when:
- User is performing rapid sequential actions (bulk editing)
- System is in background/minimized
- User has indicated preference for fewer notifications

---

## Feedback Accessibility

Feedback must work for all users, including those who cannot see animations, hear sounds, or feel vibrations.

### Accessibility Requirements

| User Group | Feedback Adaptation |
|-----------|---------------------|
| **Screen reader users** | Use aria-live regions (polite for status, assertive for errors) to announce state changes |
| **Low vision users** | Ensure color changes have sufficient contrast (3:1 minimum for state changes); do not rely on color alone |
| **Motion-sensitive users** | Respect prefers-reduced-motion; replace animations with instant state changes |
| **Deaf/hard of hearing users** | Never rely on audio as sole feedback channel; always pair with visual |
| **Keyboard-only users** | Focus indicators must be visible on all interactive elements; state changes near focus |

### Accessibility Feedback Checklist

- [ ] Can every state change be perceived without color alone (shape, text, or icon accompanies color)?
- [ ] Are error messages announced to screen readers via aria-live="assertive"?
- [ ] Are success messages announced via aria-live="polite"?
- [ ] Do animations respect prefers-reduced-motion media query?
- [ ] Is all audio feedback accompanied by a visual equivalent?
- [ ] Can keyboard users perceive which element has focus?
- [ ] Do loading states have an accessible label ("Loading...", role="status")?
- [ ] Are progress bars accessible (role="progressbar", aria-valuenow, aria-valuemin, aria-valuemax)?

---

## Feedback Design Checklist

- [ ] Does every interactive element provide immediate visual feedback on activation?
- [ ] Is feedback proportional to event significance (small action = small feedback)?
- [ ] For operations > 300ms, is there a loading indicator?
- [ ] For operations > 10 seconds, is there a progress bar?
- [ ] Do error messages explain what happened and how to fix it?
- [ ] Is success feedback brief and non-blocking (does not require dismissal)?
- [ ] Are animations under 500ms and interruptible?
- [ ] Is audio feedback optional and disabled by default (except essential alerts)?
- [ ] Does haptic feedback match system settings?
- [ ] Are all feedback channels accessible (visual + ARIA + reduced-motion support)?
