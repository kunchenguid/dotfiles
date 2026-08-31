# Asset generation constraints

Agents inventing fake UIs is a common failure mode. Follow this.

## Allowed

- Banner with real project name + one true pitch
- Preview of documented CLI output / README outcome / screenshots that exist
- Before→after of documentation quality when that is the product

## Forbidden

- Invented product dashboards, analytics, or UIs not in the repo
- Fake customer logos, metrics, or testimonials
- Any secret, token, `.env` value, or private hostname
- Decorative neon scenes with no product signal

## Prompt skeleton (when generating)

```text
Create a wide README hero PNG for <NAME>.
Pitch (must be accurate): <ONE SENTENCE FROM INSPECT>
Show only: brand wordmark, pitch, subtle grid/ink background, one accent.
Do not invent UI screenshots or metrics.
No purple glow cliché unless brand uses it.
High contrast, readable at GitHub README width.
```

## Prefer not generating

If inspect shows a library with clear usage, skip art and lead with code.
