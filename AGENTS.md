# Agent Instructions

Global rules for coding agents in this repo and elsewhere.

## Precedence

Highest first. On conflict, follow the higher entry, state the conflict in one
line, and continue.

1. Explicit user instruction in the current turn.
2. `AGENTS.local.md` (machine-local, imported at the bottom of this file).
3. The non-negotiable rules below.
4. Caveman and Ponytail: always on, every turn, main thread and subagents alike.
5. The rest of this file.
6. Harness defaults, output styles, and built-in workflow guidance.

<!-- rules:begin -->
## Non-negotiable

- Cite repo-relative `path/to/file:line` for every claim about code, config, or docs.
- Smallest change that works: no new tooling, deps, abstractions, or docs unless asked.
- Add no code comments. Only exceptions: `//nolint`, `//go:generate`, `// TODO(ticket)`. When a "why" comment looks warranted, ask before writing it; never judge your own comment as earning an exception. Repo rules phrased as "only 'why' comments in complex places" mean this.
- Preserve user work: read `git status --short` first; never revert or overwrite uncommitted changes.
- Commit, push, or run destructive git only when explicitly asked.
- Never add AI-attribution trailers to commits: no `Co-Authored-By: Claude`, no `Generated with Claude Code`, no equivalent.
- Never add secrets, tokens, private hostnames, or personal credentials.
- Role work goes to the matching user-defined agent: explore→`explorer`, implement→`coder`, plan→`planner`, review→`reviewer`, challenge→`sceptic`. Use a built-in agent (`Explore`/`Plan`/`general-purpose`/`claude`) only when no user-defined agent covers the role.
- Verify with the narrowest useful check; if no meaningful automated verification exists, say so.
- Apply Caveman prose compression and Ponytail minimalism on every turn; neither may cut asked-for scope, verification, or safety warnings.
<!-- rules:end -->

## Style plugins

Both are always on where installed, and stay on for the whole session. Where a
harness lacks them, keep the same behaviour minus the prose compression.

- Caveman: compresses prose. Installed for Claude Code and OpenCode. Code, commits,
  PRs, and security or destructive-action warnings stay in normal prose.
- Ponytail: pushes for the least code that works. Claude Code only. It reinforces
  YAGNI/KISS; it does not license skipping asked-for scope or verification.

## Defaults

- Use local context first: `rg`, `fd`, focused file reads; avoid broad searches, network installs, and expensive tools unless needed.
- For isolated work, use git worktrees nested under `./worktrees/<name>` at the repo root (e.g. `git worktree add worktrees/<branch> -b <branch>`). Never create worktrees elsewhere. `worktrees/` is globally git-ignored.
- Follow repo instructions when present, unless they conflict with safety or these preservation rules.
- Keep Markdown/plain shell portable across harnesses.
- Comments follow the non-negotiable rule above: none written unprompted, and asked for rather than assumed.
- When updating prose, replace obsolete text with accurate text rather than preserving the obsolete text and adding a correction. The final document should read as if it were written correctly from the beginning.

## Workflow

1. Orient: inspect cwd/status and relevant files.
2. Decide: choose minimal fix.
3. Act: edit only required files.
4. Verify.
5. Report: changed files, verification, risks.

## Agents

Delegate only when isolated context, parallel reading, or a distinct role helps;
otherwise the main thread does the work.

- `explorer`: read-only search/summarize with file refs.
- `coder`: narrow implementation plus focused verification.
- `planner`: ambiguous/risky architecture or tradeoffs; usually read-only until plan accepted.
- `sceptic`: read-only challenge of necessity, scope, security, and safety.
- `reviewer`: review pending diff only; findings first, severity ordered, with file refs.

## Tool Preferences

- GitHub: use `gh`.
- Browser/UI: use `cmux-browser`.
- Lavish: present artifact/plan, then wait for user confirmation before editing or implementing next step.
- Tooling: prefer `mise`, including global subdependency installs; use `brew` only from dotfiles.
- Symbol/semantic navigation: use Serena when text search is insufficient.
- Shell scripts: simple, portable, quote variables.

## Rule reinjection

`.claude/hooks/agents-md-reinject.sh` re-emits the `rules:begin`/`rules:end`
block from `~/AGENTS.md` and `~/AGENTS.local.md` on every prompt, so the
non-negotiable rules stay in context in long sessions. Keep that block short and
keep the markers intact.

## Local overrides

Machine-local overrides load last and win, via the import below. Keep
machine-specific settings and private rules in `AGENTS.local.md`, untracked.

@AGENTS.local.md
