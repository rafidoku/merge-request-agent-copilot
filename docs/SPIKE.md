# Spike: How to create an agent in GitHub Copilot

| Concept | File | Purpose |
|---|---|---|
| Instructions | `.github/copilot-instructions.md` | Always-on repo rules |
| Skill | `.github/skills/<name>/SKILL.md` | Know-how loaded when the task matches `description` |
| Agent | `.github/agents/<name>.agent.md` | Specialist with its own prompt and tool set |

An agent file is Markdown with YAML frontmatter (`name`, `description`, `tools`, `include-custom-instructions`) followed by its instructions.

- `description` is the trigger: make it a concrete "Use when..." phrase.
- `tools` limits what the agent can do (e.g. `["read", "search"]` for a read-only reviewer).
- `include-custom-instructions: true` makes it follow the repo's instructions.

Locations: team `.github/agents/`, personal `~/.copilot/agents/`. Skills: `.github/skills/` and `~/.copilot/skills/`.

Run: CLI `copilot --agent <name> --prompt "..."` or `/agent`; VS Code agent selector in Chat.

Tip: let Copilot generate the file, then review `description`, `tools`, and the "why" behind each rule.

## Docs
- https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli
- https://docs.github.com/en/copilot/reference/custom-agents-configuration
- https://docs.github.com/en/copilot/concepts/agents/about-agent-skills
- https://code.visualstudio.com/docs/copilot/customization/overview
