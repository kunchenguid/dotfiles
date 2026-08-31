---
name: mesh-gradient-dark-blue-clean
description: Create a futuristic, premium, clean dark-blue mesh-gradient design system across background rendering, hero shell, navigation, floating nodes, framed sections, CTAs, and motion. Use when the interface needs a near-black navy foundation, procedural blue mesh atmosphere, disciplined minimal structure, and infrastructural or planetary depth.
---

# Mesh Gradient Dark Blue Clean

## Use When
- The whole page should feel futuristic, premium, clean, and infrastructural.
- A dark-blue mesh gradient should power the composition, not sit behind it as a generic backdrop.
- The interface needs a central hero shell, restrained navigation, floating network hints, framed sections, and slow technical motion.

## Direction
Build on a near-black foundation with a deep navy or steel-blue undertone. Place a shader-like mesh gradient, CPPN-style field, abstract WebGL veil, or canvas light field inside the main hero shell. Keep the surrounding system disciplined: crisp typography, thin rails, corner markers, tiny status dots, quiet frames, and sparse node callouts.

This is not an airy blue page. This is not generic glassmorphism. The mesh is the visual engine inside a minimal system shell.

## System Recipe
1. Foundation: near-black navy, not flat black.
2. Hero shell: large rounded container with a subtle white-to-transparent gradient border and darker inner fill.
3. Mesh field: blue-led procedural canvas or WebGL layer inside the shell.
4. Typography: white headlines, gray-blue support copy, restrained accents.
5. Navigation: compact dark translucent pill with light edge gradient.
6. Nodes: a few floating glass pills, active dots, tiny labels, and connector lines.
7. Structure: thin vertical rails, corner squares, numeric markers, and framed lower sections.
8. CTAs: one bright solid capsule plus one ghost or glass capsule with a faint border gradient.
9. Motion: slow mesh drift, subtle scan streaks, masked text reveal, or tiny node shimmer.

## Color Tokens

```css
:root {
  --mesh-bg: #030712;
  --mesh-bg-blue: #07111f;
  --mesh-shell: rgba(7, 13, 25, 0.82);
  --mesh-shell-inner: rgba(4, 9, 18, 0.72);
  --mesh-line: rgba(191, 219, 254, 0.14);
  --mesh-line-strong: rgba(226, 232, 240, 0.28);
  --mesh-text: #f8fafc;
  --mesh-copy: #9fb2ca;
  --mesh-muted: #64748b;
  --mesh-accent: #dbeafe;
  --mesh-cobalt: #1d4ed8;
  --mesh-indigo: #312e81;
  --mesh-steel: #385a7c;
}
```

## Page Foundation

```css
.mesh-page {
  min-height: 100vh;
  color: var(--mesh-text);
  background:
    radial-gradient(circle at 50% 0%, rgba(29, 78, 216, 0.18), transparent 34rem),
    linear-gradient(180deg, var(--mesh-bg-blue), var(--mesh-bg) 48%, #01030a);
}

.mesh-page::selection {
  color: #020617;
  background: var(--mesh-accent);
}
```

## Hero Shell
Use a border-gradient wrapper and a darker content surface. The mesh canvas sits behind the content inside the shell.

```css
.mesh-shell {
  position: relative;
  overflow: hidden;
  border: 1px solid transparent;
  border-radius: 32px;
  background:
    linear-gradient(var(--mesh-shell), var(--mesh-shell)) padding-box,
    linear-gradient(145deg, rgba(255, 255, 255, 0.46), rgba(147, 197, 253, 0.18), rgba(255, 255, 255, 0.04)) border-box;
  box-shadow:
    0 40px 100px rgba(0, 0, 0, 0.42),
    inset 0 1px 0 rgba(255, 255, 255, 0.10);
}

.mesh-shell__field {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0.78;
  pointer-events: none;
}

.mesh-shell__content {
  position: relative;
  z-index: 2;
  min-height: clamp(560px, 72vh, 820px);
  padding: clamp(28px, 6vw, 84px);
  background:
    linear-gradient(180deg, rgba(4, 9, 18, 0.22), rgba(4, 9, 18, 0.62)),
    var(--mesh-shell-inner);
}
```

```html
<section class="mesh-shell">
  <canvas class="mesh-shell__field" data-dark-blue-mesh></canvas>
  <div class="mesh-shell__content">
    <nav class="mesh-nav">...</nav>
    <h1>Infrastructure for intelligent interfaces.</h1>
    <p>...</p>
  </div>
</section>
```

## Canvas Mesh Field
Use WebGL or Three.js for the final build when available. This 2D canvas pattern is a good fallback for warped gradients, soft mesh movement, and smoky blue highlights.

```js
function initDarkBlueMesh(canvas) {
  const ctx = canvas.getContext("2d");
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let width = 0;
  let height = 0;
  let frame = 0;
  let rafId = 0;

  const points = [
    { x: 0.18, y: 0.30, r: 0.45, color: "rgba(29, 78, 216, 0.55)" },
    { x: 0.68, y: 0.22, r: 0.38, color: "rgba(49, 46, 129, 0.58)" },
    { x: 0.78, y: 0.72, r: 0.52, color: "rgba(56, 90, 124, 0.48)" },
    { x: 0.42, y: 0.58, r: 0.34, color: "rgba(219, 234, 254, 0.18)" },
  ];

  function resize() {
    const rect = canvas.getBoundingClientRect();
    const dpr = Math.min(window.devicePixelRatio || 1, 1.5);
    width = Math.max(1, rect.width);
    height = Math.max(1, rect.height);
    canvas.width = Math.floor(width * dpr);
    canvas.height = Math.floor(height * dpr);
    ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  }

  function draw(time = 0) {
    ctx.clearRect(0, 0, width, height);
    ctx.fillStyle = "#030712";
    ctx.fillRect(0, 0, width, height);
    ctx.globalCompositeOperation = "screen";

    points.forEach((point, index) => {
      const drift = reduceMotion ? 0 : Math.sin(time * 0.00018 + index) * 24;
      const x = point.x * width + drift;
      const y = point.y * height + Math.cos(time * 0.00016 + index) * 18;
      const radius = Math.max(width, height) * point.r;
      const gradient = ctx.createRadialGradient(x, y, 0, x, y, radius);
      gradient.addColorStop(0, point.color);
      gradient.addColorStop(1, "rgba(3, 7, 18, 0)");
      ctx.fillStyle = gradient;
      ctx.fillRect(0, 0, width, height);
    });

    ctx.globalCompositeOperation = "source-over";
    ctx.fillStyle = "rgba(255, 255, 255, 0.035)";
    for (let y = (frame % 28); y < height; y += 28) {
      ctx.fillRect(0, y, width, 1);
    }

    frame += 1;
    if (!reduceMotion) rafId = requestAnimationFrame(draw);
  }

  function handleResize() {
    cancelAnimationFrame(rafId);
    resize();
    draw();
  }

  resize();
  draw();
  window.addEventListener("resize", handleResize);

  return () => {
    cancelAnimationFrame(rafId);
    window.removeEventListener("resize", handleResize);
  };
}
```

## Navigation

```css
.mesh-nav {
  display: flex;
  align-items: center;
  gap: 6px;
  width: fit-content;
  padding: 6px;
  border: 1px solid transparent;
  border-radius: 999px;
  background:
    linear-gradient(rgba(5, 12, 24, 0.76), rgba(5, 12, 24, 0.76)) padding-box,
    linear-gradient(120deg, rgba(255, 255, 255, 0.28), rgba(96, 165, 250, 0.16), rgba(255, 255, 255, 0.04)) border-box;
  backdrop-filter: blur(18px);
}

.mesh-nav a {
  color: var(--mesh-copy);
  border-radius: 999px;
  padding: 9px 14px;
  text-decoration: none;
}

.mesh-nav a:hover,
.mesh-nav a[aria-current="page"] {
  color: var(--mesh-text);
  background: rgba(255, 255, 255, 0.08);
}
```

## Nodes And Rails

```css
.mesh-node {
  position: absolute;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border: 1px solid rgba(191, 219, 254, 0.18);
  border-radius: 999px;
  padding: 7px 10px;
  color: var(--mesh-copy);
  background: rgba(5, 12, 24, 0.58);
  backdrop-filter: blur(14px);
  font-size: 12px;
}

.mesh-node::before {
  content: "";
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #bfdbfe;
  box-shadow: 0 0 18px rgba(147, 197, 253, 0.72);
}

.mesh-rail {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 1px;
  background: linear-gradient(180deg, transparent, var(--mesh-line), transparent);
}

.mesh-corner {
  position: absolute;
  width: 6px;
  height: 6px;
  background: var(--mesh-line-strong);
}
```

## CTA Pair

```css
.mesh-cta-primary {
  color: #020617;
  background: #f8fafc;
  box-shadow: 0 16px 36px rgba(219, 234, 254, 0.18);
}

.mesh-cta-secondary {
  color: var(--mesh-text);
  border: 1px solid transparent;
  background:
    linear-gradient(rgba(5, 12, 24, 0.62), rgba(5, 12, 24, 0.62)) padding-box,
    linear-gradient(135deg, rgba(255, 255, 255, 0.28), rgba(96, 165, 250, 0.12), rgba(255, 255, 255, 0.04)) border-box;
}
```

## Motion Defaults
- Mesh drift: very slow, 12s to 28s loops, no sharp easing.
- Scan streaks: sparse vertical drops or horizontal lines, low opacity.
- Text: masked reveal on hero headline and section labels only.
- Nodes: shimmer or pulse at low intensity, not constant blinking.
- Reduced motion: freeze mesh, remove shimmer, keep layout and contrast intact.

## Tuning Knobs
- Mesh visibility: increase opacity only until mood is legible; copy stays primary.
- Blue hue: shift between indigo, navy, cobalt, and steel blue while preserving the dark base.
- Shell contrast: tune outer border, inner fill, and canvas opacity until layers feel crisp.
- Network density: add fewer nodes for luxury, more markers for technical infrastructure.
- Motion intensity: slow and atmospheric, never game-like.

## Avoid
- Flat CSS gradients with no mesh-like depth or procedural character.
- Bright cyan overload or electric-blue glow everywhere.
- Crowded dashboards, excessive floating widgets, or competing cards.
- Generic translucent blobs with no rails, frames, markers, or system structure.
- Overbuilt shader effects that reduce readability.
- Airy light-blue sections that break the dark premium atmosphere.

## Quick Checks
- The mesh is visible inside the hero shell and feels dimensional.
- The foundation reads near-black navy, not flat black or bright blue.
- The shell has a crisp border-gradient edge and darker inner surface.
- Typography remains bright, sharp, and readable over the field.
- Nodes, rails, markers, and scan lines are sparse and aligned.
- CTAs have clear contrast: solid primary, glass secondary.
