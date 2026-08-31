---
name: background-grid-webgl
description: "Create a perspective WebGL background grid with fading lines, subtle particle haze, slow forward drift, and gentle camera parallax."
---

# Background Grid WebGL Skill

## Use When
- Create a perspective WebGL background grid with fading lines, subtle particle haze, slow forward drift, and gentle camera parallax.

## Workflow

## Scope
- Apply this only to the immersive background grid layer, not to the full page layout, copy, or unrelated particle or laser systems.
- Use it when the design needs a perspective tech grid receding into space with subtle motion and depth.

## Visual target
- Create a large perspective ground-plane grid viewed from an elevated camera angle so the lines recede toward the horizon.
- Keep the grid understated and atmospheric: thin lines, soft fade with distance, dark background, and restrained glow rather than a loud retro neon floor.
- Add a light field of floating particles or dust to give the scene depth without overpowering the grid.
- Use the design's primary color or strongest accent color sparingly for glow, particles, or secondary emphasis. If the design is neutral, a white or cool gray grid is acceptable.

## Implementation guidance
- Prefer Three.js or equivalent real WebGL rendering for this effect.
- Use a perspective camera positioned above the plane and looking toward the origin to emphasize depth.
- Build the grid as a large plane helper or custom grid with line opacity fading by distance so the far field dissolves smoothly.
- Animate the grid with slow forward drift or repeated positional cycling so it feels alive without becoming distracting.
- Add subtle mouse-responsive camera parallax or offset, but keep the movement calm and damped.
- Add a sparse additive particle field with low opacity and slow motion to soften the empty space around the grid.

## Tuning knobs
- Grid density: control plane size, division count, and line spacing.
- Fade: adjust opacity falloff so the grid recedes naturally into darkness.
- Motion: tune forward drift speed, particle float speed, and camera smoothing.
- Camera: adjust height, distance, tilt, and parallax strength to control perspective drama.
- Color: keep the base grid subtle and use the active design accent only as a restrained highlight.

## Avoid
- Bright synthwave neon grids unless the design explicitly calls for that style.
- Thick linework or high-contrast grids that compete with foreground content.
- Dense particles or fog that obscure the grid structure.
- Aggressive mouse tracking or fast grid motion that makes the background feel unstable.
