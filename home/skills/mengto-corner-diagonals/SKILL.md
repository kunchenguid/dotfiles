---
name: corner-diagonals
description: Apply diagonal-cut corners and chamfered edges to buttons, cards, panels, and container shells. Use when a design needs precise geometric framing, sci-fi UI surfaces, clipped-corner controls, or engineered sharp containers instead of rounded pills or plain rectangles.
---

# Corner Diagonals

## Scope
- Apply only to buttons, cards, panels, and container shells.
- Use when surfaces need diagonal-cut corners or chamfered edges.
- Keep the hit area readable and usable even when the visual shape is clipped.
- Reuse the same corner logic across surfaces so it feels like a system.

## Visual Target
- Diagonal cuts should feel engineered, sharp, and intentional.
- Cuts stay subtle and proportional to the component size.
- One or more corners can be chamfered, but the silhouette should still read quickly.
- Use diagonal corners as a repeated structural motif, not a one-off trick.

## Cut Tokens

```css
:root {
  --corner-cut-sm: 8px;
  --corner-cut-md: 14px;
  --corner-cut-lg: 24px;
  --corner-line: rgba(255, 255, 255, 0.18);
  --corner-line-strong: rgba(255, 255, 255, 0.34);
  --corner-fill: rgba(10, 14, 24, 0.82);
  --corner-accent: #8b5cf6;
}
```

## Core Shapes
Use `clip-path: polygon(...)` for true diagonal silhouettes.

```css
.cut-all {
  --cut: var(--corner-cut-md);
  clip-path: polygon(
    var(--cut) 0,
    calc(100% - var(--cut)) 0,
    100% var(--cut),
    100% calc(100% - var(--cut)),
    calc(100% - var(--cut)) 100%,
    var(--cut) 100%,
    0 calc(100% - var(--cut)),
    0 var(--cut)
  );
}

.cut-top-left-bottom-right {
  --cut: var(--corner-cut-md);
  clip-path: polygon(
    var(--cut) 0,
    100% 0,
    100% calc(100% - var(--cut)),
    calc(100% - var(--cut)) 100%,
    0 100%,
    0 var(--cut)
  );
}

.cut-top-right-bottom-left {
  --cut: var(--corner-cut-md);
  clip-path: polygon(
    0 0,
    calc(100% - var(--cut)) 0,
    100% var(--cut),
    100% 100%,
    var(--cut) 100%,
    0 100%,
    0 0
  );
}
```

## Bordered Shell
For bordered surfaces, use an outer wrapper and inner surface with the same polygon.

```css
.cut-shell {
  --cut: var(--corner-cut-md);
  --border-size: 1px;
  position: relative;
  padding: var(--border-size);
  background: linear-gradient(135deg, var(--corner-line-strong), transparent 46%, var(--corner-line));
  clip-path: polygon(
    var(--cut) 0,
    100% 0,
    100% calc(100% - var(--cut)),
    calc(100% - var(--cut)) 100%,
    0 100%,
    0 var(--cut)
  );
}

.cut-shell__inner {
  min-height: 100%;
  padding: clamp(16px, 2.4vw, 28px);
  background: var(--corner-fill);
  clip-path: inherit;
}
```

```html
<section class="cut-shell">
  <div class="cut-shell__inner">
    ...
  </div>
</section>
```

## Button Pattern

```css
.cut-button {
  --cut: var(--corner-cut-sm);
  position: relative;
  display: inline-flex;
  min-height: 44px;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 0 18px;
  border: 0;
  color: white;
  background: linear-gradient(135deg, var(--corner-accent), color-mix(in srgb, var(--corner-accent), black 28%));
  clip-path: polygon(
    var(--cut) 0,
    100% 0,
    100% calc(100% - var(--cut)),
    calc(100% - var(--cut)) 100%,
    0 100%,
    0 var(--cut)
  );
}

.cut-button:hover {
  filter: brightness(1.08);
}

.cut-button:focus-visible {
  outline: 2px solid color-mix(in srgb, var(--corner-accent), white 45%);
  outline-offset: 3px;
}
```

## Secondary Button
Use a darker shell with diagonal outline treatment.

```css
.cut-button-secondary {
  --cut: var(--corner-cut-sm);
  color: white;
  background:
    linear-gradient(var(--corner-fill), var(--corner-fill)) padding-box,
    linear-gradient(135deg, var(--corner-line-strong), transparent 58%, var(--corner-accent)) border-box;
  border: 1px solid transparent;
  clip-path: polygon(
    var(--cut) 0,
    100% 0,
    100% calc(100% - var(--cut)),
    calc(100% - var(--cut)) 100%,
    0 100%,
    0 var(--cut)
  );
}
```

## Recommended Patterns
- Primary buttons: clipped hex-like or chamfered rectangles with one consistent cut amount.
- Secondary buttons: dark shells with diagonal outline treatment and restrained hover fill.
- Cards and panels: thin framed containers with one or two diagonal corners.
- Large sections: diagonal-corner inner blocks nested inside straight outer frames for hierarchy.
- Mirrored pairings: top-left plus bottom-right, or top-right plus bottom-left.

## Tuning Knobs
- Cut size: `6px-10px` for small controls, `12px-18px` for cards, `20px-32px` for large panels.
- Border treatment: use a thin stroke, gradient shell, or inset line to make the silhouette legible.
- Consistency: reuse the same polygon family across buttons and containers.
- Accent: reserve bright color for primary controls, hover borders, or focal states.
- Motion: brighten fills, reveal borders, or slide overlays; keep the shape stable.

## Avoid
- Random cut sizes across similar components.
- Aggressive clipping that harms readability or makes the component feel broken.
- Mixing rounded pills and chamfered geometry without clear hierarchy.
- Clipping only the background while borders and hit areas stay rectangular.
- Flooding every diagonal surface with a bright accent color.

## Quick Checks
- Border, background, and hit area follow the same diagonal geometry.
- Text still has comfortable horizontal padding after the cut.
- Buttons keep at least `44px` height for touch targets.
- Repeated components use the same `--cut` scale.
- Focus states remain visible around the clipped shape.
