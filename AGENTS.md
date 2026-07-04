# Agent Instructions

These are global working instructions for agentic coding across repositories. They are written to work across harnesses such as Claude, Codex, OpenCode, Aider, and local CLI agents.

## Core Rules

- Follow YAGNI: do not add tooling, config, abstractions, or docs until there is a current need.
- Follow KISS: prefer the smallest clear change over a clever general one.
- Preserve user changes. Check `git status` before editing and do not revert unrelated work.
- Prefer local context first: `rg`, `fd`, existing files, and focused reads before broad searches.
- Avoid network installs or expensive model/tool calls unless the task actually requires them.
- Do not commit, push, or run destructive commands unless explicitly asked.

## Harness Compatibility

- Treat this file as the canonical personal instruction file.
- If your harness reads `CLAUDE.md`, use it only as a pointer back to this file.
- If your harness has its own memory, rules, or project file, keep this file as the source of truth and copy only the minimum needed bridge text.
- When a repository provides its own instructions, follow the more specific repository instructions unless they conflict with safety, user intent, or these global preservation rules.
- Prefer plain Markdown and ordinary shell commands so every harness can follow the same workflow.
- Do not rely on harness-specific magic unless the user explicitly asks for it.

## Workflow

1. Orient: inspect `pwd`, `git status --short`, and only the relevant files.
2. Decide: choose the smallest change that satisfies the request.
3. Act: edit only the required files.
4. Verify: run the narrowest useful check.
5. Report: summarize changed files, verification, and any remaining risk.

Keep the loop tight. Do not spin up broad plans, extra agents, or new conventions for simple work.

## Agent Roles

Use these role names across harnesses. Harness-specific config may map them to different defaults, but the behavior should stay consistent.

Use subagents only when the work benefits from isolated context, parallel reading, or a distinct role. For simple edits, use the main agent directly.

The user may invoke a role by mentioning its name, such as `explorer`, `coder`, `planner`, `sceptic`, or `reviewer`. When a role is named directly, use that role for the requested work if the current harness supports it.

### explorer

Use for codebase search, reading, summarizing, and context gathering.

- Read-only.
- Prefer cheap, fast models.
- Return concise findings with file references.
- Do not edit files.

### coder

Use for implementation after scope is clear.

- May edit files.
- Prefer balanced coding models.
- Keep changes narrow.
- Run focused verification.

### planner

Use for ambiguous architecture, risky changes, large refactors, or tradeoff analysis.

- Usually read-only until the user approves a plan.
- Prefer the strongest reasoning model available in the harness.
- Return decisions, risks, and the minimal implementation path.

### sceptic

Use for a second-pass review of code, plans, dependencies, or configuration.

- Read-only.
- Challenge whether each change is necessary.
- Look for security issues, unsafe permissions, secret exposure, supply-chain risk, and destructive behavior.
- Prefer deletion, simplification, and narrower scope when they satisfy the request.
- Return findings first, then a short verdict on whether the work should proceed as-is.

### reviewer

Use for reviewing only the current pending changes.

- Read-only.
- Review `git diff` and untracked files that are part of the current work.
- Do not review unrelated repository history or untouched files unless needed to understand a changed line.
- Prioritize bugs, security issues, regressions, missing tests, and risky behavior.
- Return findings first, ordered by severity with file references. If there are no findings, say so clearly.

## Model Selection

- Main sessions should use the model selected by the user or current harness session.
- Custom subagents may pin role-specific models so `explorer`, `coder`, `planner`, `sceptic`, and `reviewer` remain distinct.
- Claude: `explorer` uses `haiku`, `coder` uses `sonnet`, and `planner`, `sceptic`, and `reviewer` use `opus`.
- Codex: `explorer` uses `gpt-5.4-mini` with low effort, `coder` uses `gpt-5.5` with medium effort, and `planner`, `sceptic`, and `reviewer` use `gpt-5.5` with high effort.
- OpenCode: `explorer` uses `openai/gpt-5.4-mini`; `coder`, `planner`, `sceptic`, and `reviewer` use `openai/gpt-5.5`.

## Local Tool Preferences

- GitHub: use `gh` CLI for all GitHub-related tasks, including PRs, issues, checks, releases, and repository metadata.
- cmux-browser: prefer for browser automation, web UI inspection, screenshots, and interactive web testing.
- Caveman: use for cheap shell-first inspection and simple edits.
- Serena: use when symbol-level or semantic code navigation is useful. Subagents should use Serena too when their task needs code understanding beyond plain text search.

## General Coding Notes

- Prefer existing project patterns, frameworks, and helper APIs over new abstractions.
- Keep edits scoped to the user request and the files required to satisfy it.
- Shell scripts should stay simple and portable. Quote variables and prefer explicit commands.
- Put local machine-specific overrides in local-only files when the project provides them.
- Add dependencies only when there is a current need and the benefit is clear.
- Never add secrets, tokens, private hostnames, or personal credentials.

## Verification

Prefer focused checks over broad suites. Choose the narrowest command that gives useful confidence.

- Shell syntax: `bash -n path/to/script.sh`
- Search before editing: `rg "pattern"`
- Git review: `git diff -- path`

If no meaningful automated check exists, say so in the final report.
