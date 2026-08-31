# House defaults (greenfield)

Use only when the survey is empty or nearly empty. Once the tree has names,
those names win over this file.

## Case cheatsheet

| Kind | Default |
|------|---------|
| Project / skill / directory | kebab-case |
| TS/JS file (non-component) | kebab-case |
| React component file | PascalCase |
| Python module | snake_case |
| Env / vault key | SCREAMING_SNAKE_CASE |
| Git branch | `feat|fix|chore/<kebab>` |
| npm package | kebab-case; scope if org uses `@org/` |

## Vocabulary

- Prefer short domain stems already common here: `axi`, `quota`, `tasks`,
  `menu`, `backend`, `frontend`
- Suffix tools with role when that pattern exists: `*-axi`, `*-design`,
  `*-cli`
- Product codes stay intact: `5432wire` not `fifty-four-thirty-two-wire`

## Deriving related names from a stem

Stem: `quota-widget`

- Dir: `quota-widget/`
- Component: `QuotaWidget.tsx`
- Test: `QuotaWidget.test.tsx`
- Env prefix (project): `PROJECT_QUOTA_WIDGET_*`
- Branch: `feat/quota-widget`
- Skill: `quota-widget` or `quota-widget-design` if it is a design pack

## Spaces and Unicode

- Do not create new paths with spaces
- ASCII names only for code paths and env keys
