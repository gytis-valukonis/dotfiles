#!/usr/bin/env bash

set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'warn: %s\n' "$*" >&2
}

have() {
  command -v "$1" >/dev/null 2>&1
}

refresh_path_cache() {
  hash -r 2>/dev/null || true
}

functional() {
  local command_name="$1"

  have "$command_name" || return 1
  "$command_name" --version >/dev/null 2>&1
}

run() {
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '+'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

run_in_home() {
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '+ cd %q &&' "$HOME"
    printf ' %q' "$@"
    printf '\n'
  else
    (cd "$HOME" && "$@")
  fi
}

ensure_uv() {
  if have uv; then
    return
  fi

  if have brew; then
    log "Installing uv with Homebrew"
    run brew install uv
    return
  fi

  warn "uv is required for Serena. Install uv first: https://docs.astral.sh/uv/"
  return 1
}

ensure_serena() {
  ensure_uv

  if ! have serena; then
    log "Installing Serena"
    run uv tool install -p 3.13 serena-agent
    refresh_path_cache
  fi

  if have serena; then
    log "Initializing Serena"
    run serena init
  else
    warn "serena is still not on PATH after install; open a new shell or check uv's tool bin directory"
  fi
}

install_npx_agent_skills() {
  if [ "${NPX_AGENT_SKILLS_INSTALL:-1}" = "0" ]; then
    log "Skipping npx agent skill installs"
    return
  fi

  if ! have npx; then
    warn "npx is required to install agent skills. Install Node.js/npm first."
    return
  fi

  local specs=(
    "obra/superpowers@brainstorming"
    "manaflow-ai/cmux@cmux-browser"
    "anthropics/skills@frontend-design"
    "kunchenguid/lavish-axi@lavish"
    "vercel-labs/agent-skills@vercel-react-best-practices"
    "vercel-labs/agent-skills@web-design-guidelines"
  )
  local spec package skill

  for spec in "${specs[@]}"; do
    package="${spec%@*}"
    skill="${spec##*@}"

    if [ "$skill" = "cmux-browser" ] && [ "${CMUX_BROWSER_SKILL_INSTALL:-1}" = "0" ]; then
      log "Skipping cmux-browser skill install"
      continue
    fi

    log "Installing $skill skill"
    run_in_home npx -y skills add "$package" --skill "$skill" --global --yes --agent codex opencode
  done
}

install_codex_cli() {
  if have codex; then
    log "Codex CLI is already installed"
    return
  fi

  if have brew; then
    log "Installing Codex CLI with Homebrew"
    run brew install --cask codex
    refresh_path_cache
    return
  fi

  if have npm; then
    log "Installing Codex CLI with npm"
    run npm install -g @openai/codex
    refresh_path_cache
    return
  fi

  warn "Could not install Codex CLI automatically. Install manually: https://github.com/openai/codex"
}

install_claude_cli() {
  if have claude; then
    log "Claude Code CLI is already installed"
    return
  fi

  if have brew; then
    log "Installing Claude Code CLI with Homebrew"
    run brew install --cask claude-code
    refresh_path_cache
    return
  fi

  if have npm; then
    log "Installing Claude Code CLI with npm"
    run npm install -g @anthropic-ai/claude-code
    refresh_path_cache
    return
  fi

  warn "Could not install Claude Code CLI automatically. Install manually: https://code.claude.com/docs/en/setup"
}

install_opencode_cli() {
  if have opencode; then
    log "OpenCode CLI is already installed"
    return
  fi

  if have brew; then
    log "Installing OpenCode CLI with Homebrew"
    run brew install anomalyco/tap/opencode
    refresh_path_cache
    return
  fi

  if have npm; then
    log "Installing OpenCode CLI with npm"
    run npm install -g opencode-ai@latest
    refresh_path_cache
    return
  fi

  warn "Could not install OpenCode CLI automatically. Install manually: https://opencode.ai/docs/"
}

install_selected_cli_tools() {
  local selection="${AI_CLI_INSTALL_SELECTION:-}"

  if [ -z "$selection" ]; then
    if [ ! -t 0 ]; then
      warn "No TTY available for CLI selection; skipping Codex/Claude/OpenCode CLI installs"
      warn "Set AI_CLI_INSTALL_SELECTION to codex,claude,opencode, all, or skip for non-interactive use"
      return
    fi

    printf '\nInstall AI CLIs?\n'
    printf '  1) all\n'
    printf '  2) codex\n'
    printf '  3) claude\n'
    printf '  4) opencode\n'
    printf '  5) skip\n'
    printf 'Enter comma-separated choices [skip]: '
    read -r selection
  fi

  selection="${selection:-skip}"
  selection="$(printf '%s' "$selection" | tr '[:upper:]' '[:lower:]')"

  case ",$selection," in
    *,skip,*|*,none,*|" ,"|",,")
      log "Skipping AI CLI installs"
      return
      ;;
  esac

  case ",$selection," in
    *,all,*|*,1,*)
      install_codex_cli
      install_claude_cli
      install_opencode_cli
      return
      ;;
  esac

  case ",$selection," in
    *,codex,*|*,2,*) install_codex_cli ;;
  esac
  case ",$selection," in
    *,claude,*|*,claude-code,*|*,3,*) install_claude_cli ;;
  esac
  case ",$selection," in
    *,opencode,*|*,open-code,*|*,4,*) install_opencode_cli ;;
  esac
}

setup_serena_claude_code() {
  if ! functional claude; then
    warn "Claude Code CLI not found or not functional; skipping Serena Claude Code setup"
    warn "If Claude was just installed, open a new shell and rerun this script"
    return
  fi

  if ! have serena; then
    warn "serena command not found; skipping Serena Claude Code setup"
    return
  fi

  log "Configuring Serena for Claude Code"
  if ! run serena setup claude-code; then
    warn "Serena Claude Code setup failed; continuing"
  fi
}

setup_serena_codex() {
  if ! functional codex; then
    warn "Codex CLI not found or not functional; skipping Serena Codex setup"
    warn "If Codex was just installed, open a new shell and rerun this script"
    return
  fi

  if ! have serena; then
    warn "serena command not found; skipping Serena Codex setup"
    return
  fi

  log "Configuring Serena for Codex"
  if ! run serena setup codex; then
    warn "Serena Codex setup failed; continuing"
  fi
}

opencode_config_file() {
  printf '%s/.config/opencode/opencode.json\n' "$HOME"
}

set_opencode_mcp_server() {
  local name="$1"
  shift
  local command_json="$1"
  local config
  config="$(opencode_config_file)"

  mkdir -p "$(dirname "$config")"

  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '+ configure opencode mcp %s in %s with command %s\n' "$name" "$config" "$command_json"
    return
  fi

  CONFIG_PATH="$config" MCP_NAME="$name" MCP_COMMAND_JSON="$command_json" python3 -c '
import json
import os
from pathlib import Path

path = Path(os.environ["CONFIG_PATH"])
name = os.environ["MCP_NAME"]
command = json.loads(os.environ["MCP_COMMAND_JSON"])

if path.exists() and path.read_text().strip():
    data = json.loads(path.read_text())
else:
    data = {}

data.setdefault("$schema", "https://opencode.ai/config.json")
data.setdefault("mcp", {})
data["mcp"][name] = {
    "type": "local",
    "command": command,
    "enabled": True,
    "timeout": 15000,
}

path.write_text(json.dumps(data, indent=2) + "\n")
'
}

setup_serena_opencode() {
  if ! have opencode; then
    warn "OpenCode CLI not found; configuring global OpenCode MCP anyway"
  fi

  if ! have serena; then
    warn "serena command not found; skipping Serena OpenCode setup"
    return
  fi

  log "Configuring Serena for OpenCode"
  set_opencode_mcp_server serena '["serena","start-mcp-server","--context=ide"]'
}

remove_cavecrew_opencode_agents() {
  local agents_dir="$HOME/.config/opencode/agents"
  local files=(
    "$agents_dir/cavecrew-builder.md"
    "$agents_dir/cavecrew-investigator.md"
    "$agents_dir/cavecrew-reviewer.md"
  )

  log "Removing Cavecrew OpenCode agents"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '+ rm -f'
    printf ' %q' "${files[@]}"
    printf '\n'
    return
  fi

  rm -f "${files[@]}"
}

install_caveman() {
  if [ "${CAVEMAN_INSTALL:-1}" = "0" ]; then
    log "Skipping Caveman install"
    remove_cavecrew_opencode_agents
    return
  fi

  if ! have curl; then
    warn "curl is required to install Caveman. Install manually: https://github.com/JuliusBrussee/caveman"
    remove_cavecrew_opencode_agents
    return
  fi

  local install_url="${CAVEMAN_INSTALL_URL:-https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh}"
  local install_args_text="${CAVEMAN_INSTALL_ARGS:-}"
  local install_args=()

  if [ -n "$install_args_text" ]; then
    read -r -a install_args <<<"$install_args_text"
  fi

  log "Installing Caveman"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '+ curl -fsSL %q -o /tmp/caveman-install.sh\n' "$install_url"
    printf '+ cd %q && bash /tmp/caveman-install.sh' "$HOME"
    if [ -n "$install_args_text" ]; then
      printf ' %q' "${install_args[@]}"
    fi
    printf '\n'
    remove_cavecrew_opencode_agents
    return
  fi

  local install_script
  install_script="$(mktemp "${TMPDIR:-/tmp}/caveman-install.XXXXXX.sh")"
  curl -fsSL "$install_url" -o "$install_script"
  if [ -n "$install_args_text" ]; then
    (cd "$HOME" && bash "$install_script" "${install_args[@]}")
  else
    (cd "$HOME" && bash "$install_script")
  fi
  rm -f "$install_script"
  remove_cavecrew_opencode_agents
}

main() {
  log "Setting up AI tooling"
  install_selected_cli_tools
  install_npx_agent_skills
  ensure_serena
  setup_serena_claude_code
  setup_serena_codex
  setup_serena_opencode
  install_caveman
  log "Done"
}

main "$@"
