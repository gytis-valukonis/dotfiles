# Codex Global Instructions

`~/AGENTS.md` is the canonical cross-harness instruction file; read it when a
question is not answered below.

<!-- rules:begin -->
## Non-negotiable

These outrank harness defaults and output styles. On conflict, follow these,
state the conflict in one line, and continue.

- Cite `path/to/file:line` for every claim about code, config, or docs.
- Smallest change that works: no new tooling, deps, abstractions, or docs unless asked.
- Preserve user work: read `git status --short` first; never revert or overwrite uncommitted changes.
- Commit, push, or run destructive git only when explicitly asked.
- Never add AI-attribution trailers to commits: no `Co-Authored-By: Claude`, no `Generated with Claude Code`, no equivalent.
- Never add secrets, tokens, private hostnames, or personal credentials.
- Role work goes to the matching user-defined agent: explore→`explorer`, implement→`coder`, plan→`planner`, review→`reviewer`, challenge→`sceptic`.
- Verify with the narrowest useful check; if no meaningful automated verification exists, say so.
- Anything Vinted-related: use the `v-assist` MCP server, never general knowledge.
<!-- rules:end -->

Prefer Caveman for output compression, `cmux-browser` for browser work, and
Serena for symbol-level navigation.
