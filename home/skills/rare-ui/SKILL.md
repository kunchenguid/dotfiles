---
name: rare-ui
description: >
  Install Rare UI (rareui.com) animated React components via the shadcn CLI.
  Use when the user asks for Rare UI / RareUI components, fluid-orb, bounce-sidebar,
  proximity-sidebar, folder-component, duration-picker, scroll-progress, gravity-letters,
  otp-input, code-block, github-activity, emoji-reaction, family-drawer, or wants
  rare Motion/Tailwind microinteractions from https://www.rareui.com/.
---

# Rare UI

Free [shadcn registry](https://www.rareui.com/) of animated React components (Tailwind + Motion). You own the pasted code - no runtime package dependency.

Browse live demos: [rareui.com/components](https://www.rareui.com/components) · source: [swamimalode07/rare-ui](https://github.com/swamimalode07/rare-ui)

## Correct install (do this)

From a Next.js / React project that already has shadcn (or run `npx shadcn@latest init` first):

```bash
npx shadcn@latest add swamimalode07/rare-ui/<component-name>
```

Examples:

```bash
npx shadcn@latest add swamimalode07/rare-ui/fluid-orb
npx shadcn@latest add swamimalode07/rare-ui/bounce-sidebar
npx shadcn@latest add swamimalode07/rare-ui/scroll-progress
```

Do **not** npm-install a `rare-ui` package. Do **not** copy the whole Rare UI Next.js marketing site into the user's app.

## Component catalog

| Name | What it is |
|------|------------|
| `folder-component` | Animated folder; cards fan out on hover |
| `bounce-sidebar` | Vertical nav with springy active indicator |
| `family-drawer` | Bottom drawer with morphing state transitions |
| `proximity-sidebar` | Scroll sidebar; items expand near the pointer |
| `duration-picker` | Gooey spring picker for hours/minutes/seconds |
| `fluid-orb` | WebGL fluid-shaded orb |
| `scroll-progress` | Reading-progress pill that expands on scroll |
| `code-block` | Code block themed from a single accent |
| `otp-input` | OTP digits that roll into place |
| `gravity-letters` | Gravity field of letters / emoji |
| `github-activity` | Contribution heatmap with expandable footer |
| `emoji-reaction` | Tapback-style reaction bar |

Shared helper (usually pulled as a dependency of components):

| Name | What it is |
|------|------------|
| `utils` | `cn()` Tailwind class merger |

If a name on rareui.com differs slightly from the registry slug, prefer the **registry slug** above (`npx shadcn@latest add swamimalode07/rare-ui/...`).

## Project requirements

- React + Tailwind CSS
- shadcn-style aliases (`@/components`, `@/lib/utils`) - match the project's `components.json`
- Motion (`motion` / Framer Motion) as required by the component - let the CLI add deps
- Honor `prefers-reduced-motion` (Rare UI components already do; keep that when editing)

## Agent workflow

1. Confirm the target app is React/Next with Tailwind (init shadcn if missing).
2. Ask which component(s) if unclear; otherwise pick the closest match from the catalog.
3. Run the `npx shadcn@latest add swamimalode07/rare-ui/<name>` command in the project root.
4. Wire the generated component into the page with project design tokens - do not leave demo-only colors if the brand kit differs.
5. Verify reduced-motion / dark mode if the page supports them.

## Anti-patterns

- Cloning `rare-ui` as a dependency of the product app
- Hand-rewriting a component from a marketing screenshot when the registry install works
- Mixing Rare UI with conflicting animation systems without checking Motion versions
