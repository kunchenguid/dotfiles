---
name: marquee-loop
description: "Apply seamless infinite marquee loops using duplicated items."
---

# Marquee Skill

## Use When
- A design needs a seamless infinite loop for logos, testimonials, screenshots, tags, or short feature chips.

## Workflow
1. Duplicate the item sequence so the end and beginning match perfectly.
2. Animate the track with a linear transform from 0 to -50%.
3. Keep item widths stable to prevent jumps during the loop.
4. Mask or fade the edges when the marquee enters or exits a section.
5. Pause or slow the marquee on hover only when interaction is useful.
6. Respect prefers-reduced-motion with a static wrap or very slow movement.

## Guardrails
- Do not animate unique content that users must read carefully.
- Do not use large CPU-heavy shadows or filters on every moving item.
