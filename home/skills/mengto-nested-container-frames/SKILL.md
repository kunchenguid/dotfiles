---
name: nested-container-frames
description: "Create a container-in-container layout system using nested frames. Use an outer centered container with visible vertical boundary lines and corner markers. Inside, place inner containers inset from the edges, each with its own background and rounded frame. Technique: outer container defines global bounds, inner containers use padding to create inset spacing, layered frames (border + background) to separate levels, and consistent spacing between outer frame and inner blocks."
---

# Nested Container Frames Skill

## Use When
- A layout needs a container-in-container system with visible outer bounds, inset inner frames, and layered page structure.

## Workflow
1. Define an outer centered container that controls the global page width.
2. Add visible vertical boundary lines and small corner markers to establish the frame.
3. Place inner containers inset from the outer edges using consistent padding.
4. Give each inner level its own background, border, radius, and spacing rhythm.
5. Use the frame hierarchy to separate hero, feature, proof, and CTA modules without adding heavy cards.

## Guardrails
- Do not nest cards inside cards until the layout feels boxed in.
- Do not let frame lines overpower content readability.
