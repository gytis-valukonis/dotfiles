# AI Skills

These are global skills currently installed through `npx skills` and restored by `scripts/setup_ai_tooling.sh`.

Run:

```bash
scripts/setup_ai_tooling.sh
```

Skip these installs with `NPX_AGENT_SKILLS_INSTALL=0`. Skip only `cmux-browser` with `CMUX_BROWSER_SKILL_INSTALL=0`.

## npx Skills

| Skill | Source | Notes |
| --- | --- | --- |
| `brainstorming` | `obra/superpowers@brainstorming` | Design/spec workflow before implementation. |
| `cmux-browser` | `manaflow-ai/cmux@cmux-browser` | Browser automation through cmux. |
| `frontend-design` | `anthropics/skills@frontend-design` | Distinctive UI design guidance. |
| `lavish` | `kunchenguid/lavish-axi@lavish` | HTML review artifacts through `npx -y lavish-axi`. |
| `vercel-react-best-practices` | `vercel-labs/agent-skills@vercel-react-best-practices` | React/Next.js performance rules. |
| `web-design-guidelines` | `vercel-labs/agent-skills@web-design-guidelines` | Vercel Web Interface Guidelines review. |

## Non-npx Skills

- Caveman skills are installed by `install_caveman` in `scripts/setup_ai_tooling.sh` and mirrored under `.config/opencode/skills`.
- `vercel-web-interface-review` is Codex-only and vendored under `.codex/skills/vercel-web-interface-review` because it is not discoverable through `npx skills find`.

Audit current global skills with:

```bash
npx skills list -g --json
```
