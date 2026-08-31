---
name: corner-lasers
description: "Create a corner-anchored laser composition with thin beams, a bright emitter node, bloom, and atmospheric glow or fog."
---

# Corner Lasers Skill

## Use When
- Create a corner-anchored laser composition with thin beams, a bright emitter node, bloom, and atmospheric glow or fog.

## Workflow

## Scope
- Apply this only to corner-based laser beam compositions, not to generic centered lasers, particle scenes, or unrelated motion systems.
- Use it when the design needs beams that originate from or converge at a corner or edge junction, with a strong cinematic emitter point.

## Visual target
- Create two or three thin laser beams that meet at a bright corner emitter, then extend outward along different directions like a geometric room corner or portal seam.
- Keep the beam lines narrow and sharp with a white-hot center, a restrained halo, and strong bloom concentrated around the corner junction.
- Let the surrounding atmosphere glow softly from the emitter so the corner feels illuminated by volumetric haze rather than flat lines on a dark background.
- Use the design's primary color or strongest accent color for the halo and atmospheric tint instead of hardcoding blue, while keeping the brightest beam core near white.

## Implementation guidance
- Prefer raw WebGL shader treatment or equivalent effect logic when the output supports it.
- Anchor the composition to an off-center corner point and derive multiple beam directions from that point rather than placing unrelated separate lines.
- Use signed-distance or line-distance logic so each beam stays thin, crisp, and continuous.
- Add a concentrated bloom or energy flare at the corner emitter where the beams meet; that hotspot should be the brightest point in the composition.
- Add subtle atmospheric glow, fog, or light diffusion around the beams so the effect feels immersive and spatial, not flat.
- Motion should stay restrained: slow pulsing, faint traveling energy, or gentle shimmer is good; chaotic flicker is not.

## Tuning knobs
- Corner position: move the emitter point inward from the edge or corner to frame the composition.
- Beam count and angle: use two or three rays with clear directional contrast.
- Beam thickness: keep the core thin and tune the outer glow separately so the lasers stay elegant.
- Color: derive halo and haze tint from the active design accent color.
- Atmosphere: adjust bloom radius, fog density, falloff, and vignette strength so the corner stays luminous without washing out the UI.

## Avoid
- Thick neon bars that lose the precision of laser lines.
- Full-screen fog with no localized relationship to the corner emitter.
- Hardcoding a cold blue palette when the design clearly uses another primary color.
- Symmetrical centered compositions when the goal is an off-axis corner beam effect.
