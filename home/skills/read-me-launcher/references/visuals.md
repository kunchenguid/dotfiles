# Visual craft + GitHub image reality

Visuals are optional proof. Prefer the lightest honest evidence
([taxonomy.md](taxonomy.md), [audience.md](audience.md)).

## GitHub camo rules (hard errors)

| Do | Do not |
|----|--------|
| Prefer **PNG/WebP** when embedding raster heroes | Rely on CSS-class SVGs as the only image |
| SVG only with **inline** `fill`/`stroke`/`font-*` | Depend on `<style>`, `class=`, `@keyframes` |
| Verify local images exist | Leave placeholders |
| Keep GIFs under ~5MB | Stack typing APIs + snakes + badge carnivals |

## When to generate images

Generate banner/preview/showcase **only if** primary proof is visual/behavioral
and a graphic is the clearest evidence.

Constraints when generating:

- Show **this** product’s outcome, not a fake unrelated dashboard
- No secrets, tokens, private hostnames, or real customer data
- Readable at small size; one accent family
- Prefer PNG for README `<img>` tags

If generation would invent UI you have not seen, use a terminal/code proof instead.

## Reference assets (Launch examples, not mandates)

This skill’s `assets/*.png` show one valid Launch look. They are a quality
reference, not a requirement for every public repo.

## Render-safe structure

Keep fenced code **outside** HTML wrappers:

```markdown
<div align="center">

  <img src="assets/preview.png" alt="Outcome" width="94%" />

  <p><strong>Pitch.</strong></p>

</div>

```bash
npm i your-thing
```
```

## Lint levels (see check-readme.sh)

- **ERROR**  -  broken render, missing image, possible secret
- **WARN**  -  fragile patterns (SVG-only, external fetch issues)
- **PREF**  -  style (em dashes); `--strict-style` promotes to ERROR
