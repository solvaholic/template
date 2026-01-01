# Repository Instructions

This repository is a template for bootstrapping new projects.

## Purpose

When creating a new repository, use this template to quickly set up:
- Repository-wide Copilot instructions
- Path-specific instructions for different file types
- Agent skills for specialized tasks
- Custom agents for workflow automation

## Structure

```
.github/
  copilot-instructions.md           # This file - general instructions
  instructions/
    instructions.instructions.md    # How to create path-specific instructions
    skills.instructions.md          # How to create agent skills
    agents.instructions.md          # How to create custom agents
.vscode/
  settings.json                     # File associations and agent settings
```

## Using This Template

1. **Edit this file** to describe your project's purpose, architecture, and workflows
1. **Create path-specific instructions** following guidance in `.github/instructions/instructions.instructions.md`
1. **Add agent skills** as needed following `.github/instructions/skills.instructions.md`
1. **Define custom agents** if desired following `.github/instructions/agents.instructions.md`

## Key Principles

- **Keep instructions under 2 pages** - Be concise and task-focused
- **Document commands that work** - Include the correct order and common workarounds
- **Be explicit** - Use "always" and "never" to set clear expectations
- **Make it searchable** - Use clear terminology that agents and humans can find
- **Version control everything** - All instructions live in the repository

## Instruction Priority

When multiple instruction files apply:
1. Personal instructions (user-level, highest priority)
1. Repository instructions (this file and path-specific)
1. Organization instructions (lowest priority)

All relevant instructions combine - avoid conflicts between layers.

## Documentation

- [Copilot custom instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions)
- [Path-specific instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions#creating-path-specific-custom-instructions-1)
- [Agent skills](https://docs.github.com/en/copilot/concepts/agents/about-agent-skills)
- [Custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
