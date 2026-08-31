---
name: gsap-scrolltrigger-storytelling
description: "Build cinematic sticky product storytelling with GSAP ScrollTrigger, progressive UI reveals, scroll-synced animation, smooth interpolation, and immersive section transitions."
---

# GSAP ScrollTrigger Storytelling Skill

## Use When
- Build cinematic sticky product storytelling with GSAP ScrollTrigger, progressive UI reveals, scroll-synced animation, smooth interpolation, and immersive section transitions.

## Workflow

## Scope
- Apply this when the page should feel like a scroll-driven product story rather than a static marketing layout.
- Use GSAP ScrollTrigger as the main choreography layer for sticky sections, progressive interface reveals, pinned scenes, scrubbed timelines, and immersive transitions between sections.
- Preserve the actual product narrative and interface clarity. The motion should amplify comprehension, not hide basic content behind theatrical effects.

## Experience target
- Create sticky product storytelling where each scroll segment reveals a new product state, feature layer, data view, device frame, or workflow step.
- Use scroll-synced animation so copy, UI panels, screenshots, overlays, and background atmosphere move together as one authored sequence.
- Build progressive UI reveals: draw in frames, fade in controls, slide panels into place, count values up, highlight regions, and swap states as the user advances.
- Keep the overall mood cinematic, premium, and immersive with controlled pacing, clean staging, depth, and transitions that feel intentional.

## Implementation guidance
- Use GSAP timelines with ScrollTrigger `scrub` for the main scroll narrative and regular tweens only for supporting entrance or hover motion.
- Pin long-form story sections with `pin: true` and map each scene to explicit timeline labels so the sequence is easy to tune.
- Prefer transform and opacity animation over layout-affecting properties. Use `will-change` sparingly on animated elements that actually need it.
- Use `gsap.context()` in React components and clean it up on unmount so ScrollTriggers are killed correctly.
- Refresh ScrollTrigger after images, fonts, or async content load if those assets affect section height or pinned offsets.
- Use `matchMedia()` or equivalent breakpoints so desktop sticky choreography can simplify gracefully on smaller screens.

## Motion patterns
- Sticky product frame: keep the main artifact pinned while the surrounding narrative updates in measured steps.
- Layer reveal: bring labels, overlays, panels, and product states in one at a time with short offsets and a shared easing language.
- Section handoff: let the current scene scale, mask, blur, or translate into the next section instead of ending abruptly.
- Smooth interpolation: use scrub smoothing, quickSetter/quickTo, or lerped values for pointer-following and scroll-reactive details.
- Cinematic depth: use foreground/background parallax, subtle camera moves, dimming layers, masks, and focus shifts without overwhelming readability.

## Tuning knobs
- Pin duration: extend for dense product stories, shorten when the scene has only one or two state changes.
- Scrub feel: use direct scrub for precise technical walkthroughs and eased scrub for a more cinematic product film feel.
- Reveal density: add more micro-reveals for complex UI, reduce them for narrative sections where copy needs to carry the moment.
- Transition intensity: keep high-impact transitions reserved for section handoffs, not every small content change.

## Avoid
- Triggering unrelated animations on every scroll tick without a clear story beat.
- Using sticky/pinned sections that trap the reader for too long or make the page feel broken.
- Animating width, height, top, left, or layout-heavy properties during scrubbed scenes when transforms can do the job.
- Letting cinematic effects reduce text contrast, cover CTAs, or obscure the product UI the section is meant to explain.
- Leaving ScrollTriggers alive after component unmounts or route changes.
