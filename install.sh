#!/usr/bin/env bash
# Install Copilot agents from fikar46/copilot-agent-team.
# Usage:
#   install.sh                      all agents into ./.github (project)
#   install.sh -g                   all agents into ~/.copilot (personal)
#   install.sh qa-engineer tech-ops pick specific agents
#   install.sh -g qa-engineer       combine
set -euo pipefail

REPO="fikar46/copilot-agent-team"
BRANCH="main"
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"
ALL="product-owner system-analyst ui-ux-designer frontend-engineer backend-engineer qa-engineer expert-engineer tech-ops code-reviewer rca-analyst"

BASE=".github"
if [ "${1:-}" = "-g" ] || [ "${1:-}" = "--global" ]; then
  BASE="$HOME/.copilot"
  shift
fi
AGENTS="${*:-$ALL}"

mkdir -p "$BASE/agents"
for a in $AGENTS; do
  curl -fsSL "$RAW/.github/agents/$a.agent.md" -o "$BASE/agents/$a.agent.md" \
    && echo "installed agent: $a" || { echo "not found: $a" >&2; rm -f "$BASE/agents/$a.agent.md"; }
done

case " $AGENTS " in
  *" rca-analyst "*)
    mkdir -p "$BASE/skills/rca-method"
    curl -fsSL "$RAW/.github/skills/rca-method/SKILL.md" -o "$BASE/skills/rca-method/SKILL.md"
    echo "installed skill: rca-method";;
esac

echo "Done -> $BASE. Run 'copilot' then '/agent' to see them."
