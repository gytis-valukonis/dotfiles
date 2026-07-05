---
name: vercel-web-interface-review
description: Review React, Next.js, and general web UI code for compliance with Vercel Web Interface Guidelines. Use when asked to audit files, components, routes, styles, or patterns for accessibility, focus states, forms, motion, typography, performance, hydration safety, navigation, touch behavior, theming, i18n, or other web interface quality rules.
---

# Vercel Web Interface Review

Review UI code against the Vercel Web Interface Guidelines and report only concrete findings with file:line locations.

## Quick Start

1. Resolve the requested file or pattern first. Prefer `rg --files` and `rg -n` to narrow the scope.
2. Read only the relevant files. Use line-numbered output when needed so every finding can point to a specific line.
3. Check the code against the checklist in [references/checklist.md](references/checklist.md).
4. Report findings grouped by file. If a file has no issues, print `✓ pass`.

## Review Workflow

### Scope the Review

- Expand globs or patterns before reading file contents.
- Prefer likely UI files first: `*.tsx`, `*.jsx`, `*.ts`, `*.js`, CSS, route files, component folders.
- If the request is broad, focus on user-facing components and shared primitives before internal helpers.

### Evaluate

- Flag only issues supported by the code currently in view.
- Prefer semantic and behavioral problems over stylistic preferences.
- Treat anti-patterns in the checklist as automatic findings.
- When a rule depends on runtime context and the code is ambiguous, mention the uncertainty briefly in the finding instead of assuming.

### Write Findings

- Output grouped by file.
- Use `path:line - issue` format.
- Keep wording terse and high-signal. Skip explanations unless the fix is non-obvious.
- Order findings by severity within each file when practical: broken accessibility/behavior first, polish issues later.
- Do not add a preamble or summary unless the user asks for one.

## Output Contract

Use this shape exactly:

```text
## src/Button.tsx

src/Button.tsx:42 - icon button missing aria-label
src/Button.tsx:67 - transition: all -> list properties explicitly

## src/Card.tsx

✓ pass
```

## References

- Read [references/checklist.md](references/checklist.md) for the review checklist and anti-patterns.
