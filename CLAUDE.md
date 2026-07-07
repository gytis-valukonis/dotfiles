# Claude Bridge

Use `AGENTS.md` in the home directory or current repository as the canonical cross-harness instruction file.

Keep work minimal, follow YAGNI and KISS, prefer cmux-browser for browser work, and prefer Caveman and Serena for local context.

## Subagents

Force user-defined subagents over built-in. For any delegated role, MUST use the
matching user-defined agent; use a built-in agent ONLY when no user-defined
equivalent exists (e.g. `statusline-setup`, `claude-code-guide`).

- search / read / explore → `explorer` (not `Explore`, `general-purpose`)
- implement scoped change → `coder` (not `claude`, `general-purpose`)
- plan / architecture / tradeoffs → `planner` (not `Plan`)
- review pending diff → `reviewer`
- challenge necessity / scope / security → `sceptic`
