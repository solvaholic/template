---
name: set-up-this-repo
description: >-
  Help a user customize this template repository for their project. Use when
  the user asks to "set up this repo", "customize the template", "configure
  this template", "help me get started", or has just created a new repo from
  solvaholic/template and wants help adapting it. Interview-driven: gathers
  intent, then runs pre-flight checks, edits AGENTS.md, README.md,
  .templatesyncignore, .gitignore, .vscode/extensions.json, and LICENSE,
  optionally scaffolds the chosen stack, validates, and commits.
---

# Set Up This Repo

## Purpose

Walk the user through adapting this template repository to their project.
Most files in a fresh template clone are placeholders. This skill replaces
them with project-specific content based on a short interview.

## When to Use

- User just created a repo from `solvaholic/template` and asks for help
  setting it up.
- User asks to "customize this template" or "configure the agent
  instructions for this project."
- User mentions they want to use this repo for a specific project but
  hasn't told the agent what the project is yet.

Do NOT use this skill for routine edits to an already-customized repo.

## Process

### 0. Pre-flight checks

Before any edits, run these quick checks and surface anything unusual.

- **Verify the remote.** Run `git remote -v`. If `origin` points at
  `solvaholic/template` itself (rather than a new repo created from the
  template), STOP and ask the user how to proceed. Possibilities:
  they're dogfooding, they haven't repointed the remote yet, or they
  cloned the wrong URL. Don't risk clobbering the template.
- **Note the working branch.** `git branch --show-current`. If they're
  on `main`, that's fine for a fresh clone; if they're on a feature
  branch already, ask whether to keep edits there.
- **Confirm the symlink.** `readlink .github/copilot-instructions.md`
  should print `../AGENTS.md`. If it doesn't, flag it before editing.
- **Check the Actions PR-creation toggle.** The template's
  `sync-from-template.yml` workflow opens PRs each week, which
  requires *Settings → Actions → General → Workflow permissions →
  Allow GitHub Actions to create and approve pull requests*. Run:

  ```sh
  gh api "/repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/permissions/workflow"
  ```

  If `can_approve_pull_request_reviews` is `false`, the workflow will
  push the sync branch but fail to open the PR. Offer to enable it:

  ```sh
  gh api -X PUT \
    "/repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions/permissions/workflow" \
    -f default_workflow_permissions=read \
    -F can_approve_pull_request_reviews=true
  ```

  If the user lacks admin perms or prefers the UI, walk them through
  the Settings path instead. Don't skip this step - it's the single
  most common cause of "the sync workflow seems broken" reports.

### 1. Interview the user

Ask one focused question at a time. Stop when you have enough to act.
Cover, in roughly this order:

- **Project intent.** What is this repository for? A library, app, set of
  notes, research, infra, etc.
- **Project name and one-line description.** Capture both early so they
  can be threaded into `README.md`, `AGENTS.md`, and any scaffolded
  config (e.g., `package.json`, `pyproject.toml`).
- **Audience.** Solo? Team? Public? This shapes README tone and whether
  to recommend branch protection.
- **Stack and tools.** Languages, frameworks, build/test commands. Capture
  the *commands that work*; agents need these in `AGENTS.md`. If the
  user is unsure, suggest a sensible default for their project intent
  rather than leaving it open.
- **License.** Offer concrete defaults rather than open-ended choice:
  MIT or Apache-2.0 for code; CC0 1.0 or CC BY 4.0 for content-heavy
  repos; Unlicense for "do whatever" code; "no license / private" for
  closed projects. Don't require a final decision now if the user is
  unsure - mark as a TODO.
- **Conventions.** Style guides, commit conventions, review expectations.
- **Agent role.** What should an AI agent help with vs. avoid? Any
  project-specific guardrails (e.g., "never commit to main", "always run
  tests before pushing").

The user may:

- Link to notes, websites, or prior AI chat sessions. Read them when
  practical; otherwise summarize what you'd want from them.
- Ask you to brainstorm. Help them think it through, but suggest they
  capture decisions outside this chat for later reference.
- Ask you to prototype with incomplete info. Make sensible defaults,
  then call out each assumption as a TODO the user should revisit.

### 2. Customize the repository

Make these edits based on the interview. Confirm before destructive
changes (deleting files, rewriting `AGENTS.md` from scratch).

- **`AGENTS.md`** - Replace template content with project-specific
  instructions: purpose, structure, build/test/lint commands, conventions,
  agent guardrails. Keep it focused; aim for under two pages.
- **`README.md`** - Replace template content with a project README:
  what it is, how to use it, how to contribute. Remove template-meta
  sections (template sync, "what's included") unless the user wants
  to keep them.
- **`.templatesyncignore`** - Don't try to predict what the user will
  want to exclude from future template syncs; the right time to decide
  is when a sync PR actually shows up. Instead, **remind the user** that
  this file exists, what it does (preserves listed files from being
  overwritten by template sync PRs), and that they can edit it later
  when reviewing a sync PR. Common preservation rules are already in
  place; show the file so the user sees what's preserved by default.
- **`.gitignore`** - Read the existing file first. Append ecosystem-
  specific entries based on the stack (e.g., `node_modules/`,
  `__pycache__/`, `.venv/`, `dist/`). Don't duplicate entries already
  present.
- **`.vscode/extensions.json`** - Recommend extensions matching the
  stack (e.g., `ms-python.python` for Python, `dbaeumer.vscode-eslint`
  for JS/TS). Keep the list short.
- **`LICENSE` (and optionally `LICENSE-content`)** - Add the license
  the user chose in the interview. For dual-licensed repos (code +
  prose), add a second file (e.g., `LICENSE-content`) and reference
  both in `README.md`. Skip if the user opted out or is undecided -
  leave a TODO in `README.md` instead.

After the edits, verify the symlink still resolves:
`readlink .github/copilot-instructions.md` must print `../AGENTS.md`.
If you used `rm` + recreate on `AGENTS.md`, the symlink survives, but
double-check.

### 3. (Optional) Scaffold the stack

Ask whether the user wants you to scaffold the stack you discussed
(e.g., `package.json` + a hello-world entry point, `pyproject.toml` +
`src/`, `mkdocs.yml` + `docs/`, a CI workflow). Default to **asking,
not assuming** - some users want only the agent-instruction edits.

When scaffolding:

- Keep it minimal. Get the user to a working `build` and `test` (or
  equivalent) command, nothing more.
- Use the project name and description from the interview.
- Reference any commands you scaffold in `AGENTS.md` so the recorded
  conventions match reality.

### 4. Validate

Where practical, run the commands you just configured to make sure
they work before declaring done. Examples:

- `npm install && npm run build` (or test/lint) for Node projects.
- `uv sync && uv run <build-command>` for Python projects using uv.
- A linter pass to catch obviously broken config.

If validation requires network access, credentials, or tools the user
hasn't installed, skip it and note what they should run themselves.

### 5. Commit the changes

Show the user a summary of what changed and let them decide how to
commit: a single commit on the current branch, a feature branch + PR,
or staged for them to review. Don't push without their say-so.

### 6. Recommend repository settings

These can't be set from inside the repo. List them so the user can apply
them in GitHub:

- Branch protection on the default branch (require PRs, require status
  checks).
- Required reviewers if the project has collaborators.
- Default branch name if it should differ from `main`.
- Enable/disable Issues, Discussions, Wiki, Projects to match the
  project's needs.
- Secret scanning and Dependabot if the repo will hold code.

### 7. Decide what to do with the example skill

The `.agents/skills/template-example/` skill is a layout demo, not
useful in production. Offer to:

- Delete it now that the user has seen the pattern, or
- Keep it as a reference until they've authored their first real skill.

### 8. Decide what to do with this skill

Do this **last**, after all other steps are committed. Once the repo is
customized, this skill has served its purpose. Offer to:

- Delete `.agents/skills/set-up-this-repo/` (recommended for most
  projects), or
- Modify it to assist with future revisions specific to this project,
  or
- Keep it as-is in case the repo is re-cloned later.

## Boundaries

- Will: edit files in this repository, suggest GitHub settings, interview
  the user to gather requirements, and toggle the Actions
  PR-creation setting via `gh api` when the user authorizes it.
- Will NOT: change other GitHub repo settings directly, push commits
  without the user's confirmation, or invent project facts the user
  didn't provide. Mark assumptions as TODOs instead.

## Gotchas

- `.github/copilot-instructions.md` is a symlink to `AGENTS.md`. Edit
  `AGENTS.md`; the symlink follows. If you delete and recreate
  `AGENTS.md` (e.g., `rm` + `create`), the symlink survives - but
  verify with `readlink .github/copilot-instructions.md` before
  declaring done.
- Always run `git remote -v` before editing. If `origin` is
  `solvaholic/template`, you're inside the template itself, not a
  fresh clone of it. Stop and confirm with the user.
- `.templatesyncignore` controls future syncs from `solvaholic/template`.
  Files listed there will not be overwritten by sync PRs.
- The user's project facts trump everything in the template. If a
  template default conflicts with what they describe, change the
  template default.
