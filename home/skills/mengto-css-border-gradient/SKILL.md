---
name: css-border-gradient
description: Apply subtle gradient-border treatments for premium web surfaces. Use when cards, pricing panels, nav bars, modals, buttons, or hero surfaces need a refined edge highlight without a loud glow.
---

# Border Gradients

## Use When
- A surface needs a more premium edge than a flat `border`.
- Dark glass, pricing, hero, modal, or feature-card UI feels too plain.
- A hover or focus state needs a quiet brand accent.

## Defaults
- Width: `1px`; use `2px` only for large hero cards or active states.
- Radius: inherit the parent radius.
- Angle: `135deg` or `160deg`.
- Stops: neutral highlight, one brand accent, neutral fade.
- Opacity: keep most stops below `0.4`; subtle beats shiny.

## Simple CSS Pattern
Use this when the surface has a solid or translucent fill.

```css
.gradient-border {
  --surface: rgba(10, 14, 24, 0.72);
  --border-a: rgba(255, 255, 255, 0.34);
  --border-b: rgba(125, 92, 255, 0.36);
  --border-c: rgba(255, 255, 255, 0.08);

  border: 1px solid transparent;
  border-radius: 20px;
  background:
    linear-gradient(var(--surface), var(--surface)) padding-box,
    linear-gradient(135deg, var(--border-a), var(--border-b), var(--border-c)) border-box;
}
```

```html
<div class="gradient-border">
  ...
</div>
```

## Masked Pattern
Use this when the surface already has a complex background that should not be overwritten.

```css
.gradient-border-mask {
  position: relative;
  border-radius: 20px;
}

.gradient-border-mask::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    145deg,
    rgba(255, 255, 255, 0.34),
    rgba(125, 92, 255, 0.36) 45%,
    rgba(255, 255, 255, 0.08)
  );
  -webkit-mask:
    linear-gradient(#fff 0 0) content-box,
    linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
}
```

## Tailwind Shortcut
Use arbitrary properties for one-off surfaces.

```html
<div class="rounded-2xl border border-transparent [background:linear-gradient(rgba(10,14,24,.72),rgba(10,14,24,.72))_padding-box,linear-gradient(135deg,rgba(255,255,255,.34),rgba(125,92,255,.36),rgba(255,255,255,.08))_border-box]">
  ...
</div>
```

## Taste Rules
- Apply to one hierarchy level at a time: primary card, active tab, selected plan, or hero panel.
- Do not use rainbow borders, full-saturation neon, or animated gradients by default.
- Keep the border quieter than the content. It should frame, not compete.
- Pair with restrained depth: a soft shadow or inner highlight is enough.
- Check light and dark themes separately; the same alpha rarely works for both.

## Quick Checks
- No double border from an existing `border-color`.
- Radius matches the surface exactly.
- The gradient is visible at normal zoom but barely noticeable when scanning.
- Focus states remain accessible and do not rely only on the gradient.
