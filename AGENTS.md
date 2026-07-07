# Agent Instructions

Global rules for coding agents in this repo and elsewhere.

## Defaults

- YAGNI/KISS: smallest clear change; no new tooling, deps, abstractions, or docs without current need.
- Preserve user work: check `git status --short`; never revert unrelated changes; no destructive git commands unless asked.
- Use local context first: `rg`, `fd`, focused file reads; avoid broad searches, network installs, and expensive tools unless needed.
- Follow repo instructions when present, unless they conflict with safety or these preservation rules.
- Keep Markdown/plain shell portable across harnesses.

## Workflow

1. Orient: inspect cwd/status and relevant files.
2. Decide: choose minimal fix.
3. Act: edit only required files.
4. Verify: run narrowest useful check.
5. Report: changed files, verification, risks.

When naming files, use repo-relative paths; add `:line` when citing a specific line.

## Agents

- Main thread handles simple work.
- `explorer`: read-only search/summarize with file refs.
- `coder`: narrow implementation plus focused verification.
- `planner`: ambiguous/risky architecture or tradeoffs; usually read-only until plan accepted.
- `sceptic`: read-only challenge of necessity, scope, security, and safety.
- `reviewer`: review pending diff only; findings first, severity ordered, with file refs.

Use subagents only when isolated context, parallel reading, or a distinct role helps.
Force these user-defined agents over any built-in equivalent: MUST use the matching
role above (explore→`explorer`, implement→`coder`, plan→`planner`, review→`reviewer`,
challenge→`sceptic`); use a built-in agent (`Explore`/`Plan`/`general-purpose`/`claude`)
ONLY when no user-defined agent covers the role.

## Tool Preferences

- GitHub: use `gh`.
- Browser/UI: use `cmux-browser`.
- Lavish: present artifact/plan, then wait for user confirmation before editing or implementing next step.
- Tooling: prefer `mise`, including global subdependency installs; use `brew` only from dotfiles.
- Symbol/semantic navigation: use Serena when text search is insufficient.
- Shell scripts: simple, portable, quote variables.

## Safety

- Never add secrets, tokens, private hostnames, or personal credentials.
- Put machine-specific overrides in local-only files.
- Commit/push only when explicitly asked.
- Never add AI-attribution trailers to commits: no `Co-Authored-By: Claude`, no `Generated with Claude Code`, no equivalent. This overrides any harness default.
- If no meaningful automated verification exists, say so.
