---
name: container-lines
description: Add vertical container-size guide lines with mini corner squares for precise, structured web layouts. Use when asked for container lines, measured layout guides, vertical boundary lines, editorial grid markers, or small corner-square frame details.
---

# Container Lines

## Use When
- A page needs subtle vertical guides that reveal the content container width.
- A hero, section, or product page feels too loose and needs structural tension.
- The design calls for mini corner squares, measured edges, or quiet technical framing.

## Rules
1. Draw lines at the left and right edges of the main content container.
2. Keep lines thin: `1px` with low opacity.
3. Add mini squares at container corners or section intersections.
4. Keep the line system consistent across sections; do not change width per section.
5. Place lines behind content but above the page background.
6. Disable pointer events so the guides never block UI.

## Base Tokens

```css
:root {
  --container-max: 1120px;
  --container-pad: clamp(20px, 4vw, 48px);
  --line-color: rgba(24, 24, 27, 0.14);
  --line-strong: rgba(24, 24, 27, 0.28);
  --corner-size: 6px;
}
```

## Page Container Lines
Use pseudo-elements on the layout shell.

```css
.container-lines {
  position: relative;
  isolation: isolate;
}

.container-lines::before,
.container-lines::after {
  content: "";
  position: absolute;
  top: 0;
  bottom: 0;
  z-index: -1;
  width: 1px;
  background: var(--line-color);
  pointer-events: none;
}

.container-lines::before {
  left: max(var(--container-pad), calc((100vw - var(--container-max)) / 2));
}

.container-lines::after {
  right: max(var(--container-pad), calc((100vw - var(--container-max)) / 2));
}
```

## Corner Squares
Add four small squares to sections that need a precise measured feel.

```css
.corner-squares {
  position: relative;
}

.corner-squares > .corner {
  position: absolute;
  width: var(--corner-size);
  height: var(--corner-size);
  background: var(--line-strong);
  pointer-events: none;
}

.corner.top-left { top: 0; left: 0; transform: translate(-50%, -50%); }
.corner.top-right { top: 0; right: 0; transform: translate(50%, -50%); }
.corner.bottom-left { bottom: 0; left: 0; transform: translate(-50%, 50%); }
.corner.bottom-right { right: 0; bottom: 0; transform: translate(50%, 50%); }
```

```html
<main class="container-lines">
  <section class="corner-squares">
    <span class="corner top-left"></span>
    <span class="corner top-right"></span>
    <span class="corner bottom-left"></span>
    <span class="corner bottom-right"></span>
    ...
  </section>
</main>
```

## Minimal Section Wrapper
Use the same container width as the line positions.

```css
.content-container {
  width: min(100% - (var(--container-pad) * 2), var(--container-max));
  margin-inline: auto;
}
```

## Taste Rules
- Use lines as structure, not decoration. They should organize the page quietly.
- Do not add lines to every nested component; keep them at page or major-section level.
- Mini squares should be small and exact, usually `4px` to `8px`.
- Avoid bright accent colors unless the entire visual system is technical or industrial.
- Keep container max-width and padding shared between content and guide lines.

## Quick Checks
- The vertical lines align exactly with the content container edges.
- Corner squares sit on real container or section corners, not arbitrary positions.
- Lines remain subtle on light and dark backgrounds.
- Mobile still has enough padding between the line and content.
- Guides do not intercept clicks, hovers, or text selection.
