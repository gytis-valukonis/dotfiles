#!/bin/sh
# UserPromptSubmit hook: restate the non-negotiable AGENTS.md rules every turn so
# they do not get buried as the session grows.
set -eu

emit_rules() {
  [ -f "$1" ] || return 0
  awk '/<!-- rules:begin -->/ { on = 1; next } /<!-- rules:end -->/ { on = 0 } on' "$1"
}

rules=$(
  emit_rules "$HOME/AGENTS.md"
  emit_rules "$HOME/AGENTS.local.md"
)

[ -n "$rules" ] || exit 0

printf 'AGENTS.md rules, highest precedence, restated for this turn:\n%s\n' "$rules"
