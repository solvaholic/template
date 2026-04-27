# AGENTS.md

This file is the default instruction set for any AI coding agent that
opens this repository. It follows the [agents.md][agents-md] convention:
a single, agent-agnostic Markdown file at the repository root that any
agent can read for project context. `.github/copilot-instructions.md` is
a symlink to this file so GitHub Copilot picks it up too.

This is a fresh clone of [solvaholic/template][template]. The content
below is **placeholder** - it describes the template itself. Replace it
with instructions specific to your project. The fastest way is to ask
your AI agent to use the `set-up-this-repo` skill in
`.agents/skills/set-up-this-repo/`.

[agents-md]: https://agents.md
[template]: https://github.com/solvaholic/template

## Repository purpose (placeholder)

This repository was bootstrapped from a template designed to give
AI agents and their human collaborators a sensible starting point:

- `AGENTS.md` (this file) for repository-wide agent instructions.
- `.agents/skills/` for reusable, agent-invokable procedures.
- `.github/workflows/sync-from-template.yml` to pull future template
  updates as PRs.
- `.vscode/extensions.json` for editor recommendations.

When you customize the repo, replace this section with: what the project
is, who uses it, and what success looks like.

## How to use this repo with an AI agent

If this is a freshly created repository:

1. Open the repo with the agent of your choice (Copilot CLI, Claude Code,
   Cursor, Aider, etc.). Most modern agents read `AGENTS.md` automatically.
2. Ask the agent to **use the `set-up-this-repo` skill**. It will
   interview you about the project and update this file, `README.md`,
   `.templatesyncignore`, `.gitignore`, and `.vscode/extensions.json`.
3. Once the repo is customized, delete `.agents/skills/template-example/`
   and (optionally) `.agents/skills/set-up-this-repo/`.

## Project conventions (placeholder)

Replace the bullets below with conventions that actually apply to this
project. Be concrete; agents follow specifics better than generalities.

- **Build:** _command goes here_
- **Test:** _command goes here_
- **Lint / format:** _command goes here_
- **Style:** _link to style guide or describe in one sentence_
- **Commit messages:** _conventional commits, plain prose, etc._
- **Branching:** _e.g., feature branches off `main`, no direct pushes_

## Guidance for agents (placeholder)

Use the rules below as a starting point. Tighten or replace them based on
how you actually want agents to behave in this repo.

- Prefer small, focused changes. Propose the approach for non-trivial work
  before implementing it.
- Run the project's build/lint/test commands before declaring a task done.
- Don't commit secrets, generated artifacts, or large binaries.
- Don't rewrite git history on shared branches without explicit consent.
- Document desired behavior (tests, specs, or docs) before implementing it
  when practical.

## How AGENTS.md is meant to work

`AGENTS.md` is intentionally simple: one Markdown file, at the repo root,
that any agent can read. Keep it focused and under roughly two pages.
Move long-form material (architecture docs, runbooks, style guides) into
linked files and reference them here.

For more, see <https://agents.md>.
