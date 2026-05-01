# template
@solvaholic's repository template

## What's included

This template provides:

- **AGENTS.md** - AI agent instructions
- **.agents/skills/template-example/SKILL.md** - An example AI agent skill
- **.agents/skills/set-up-this-repo/SKILL.md** - An AI agent skill for adapting this template to your project
- **.github/workflows/sync-from-template.yml** - Automatic updates from the template repository
- **`.vscode/extensions.json`** - Recommended extensions

## Quick start

1. Open your new repository with your favorite AI agent, and ask it to use the `set-up-this-repo` skill

OR:

1. **Configure the sync workflow** in `.templatesyncignore` and `.github/workflows/sync-from-template.yml` (runs weekly by default)
1. **Set repository settings** - branch protection, collaborators, etc.
1. **Replace README.md** with project-specific documentation
1. **Replace AGENTS.md** with project-specific instructions

## AI agent instructions

Located in `AGENTS.md` and symlinked from `.github/copilot-instructions.md`:

- `AGENTS.md` - Repository-wide instructions for AI agents

**Note:** `AGENTS.md` is excluded from template syncs (via `.templatesyncignore`) so you can customize it per repository.

## AI agent skills

Located in `.agents/skills/`:

- `template-example/SKILL.md` - An example skill definition, illustrates how to use the files and paths
- `set-up-this-repo/SKILL.md` - AI agent instructions for helping the user set up this repository for their project

## Template sync workflow

Automatically checks for updates from **[solvaholic/template](https://github.com/solvaholic/template)** weekly (Fridays at 05:17 UTC) and creates a pull request with changes.

**Features:**
- Uses `AndreasAugustin/actions-template-sync@v2` for robust conflict handling
- Respects `.templatesyncignore` exclusion rules
- Preserves repository-specific files (workflows, README, .gitignore, agent instructions)
- Manual trigger available via Actions tab

**Configuration:** `.github/workflows/sync-from-template.yml`

**Prerequisite:** GitHub Actions must be allowed to create pull
requests in your repository. Without this, the workflow will push a
branch but fail to open the PR (with a `GitHub Actions is not
permitted to create or approve pull requests` error in the log).

To enable it, go to **Settings → Actions → General → Workflow
permissions** and check **"Allow GitHub Actions to create and approve
pull requests"**, or run:

```sh
gh api -X PUT /repos/OWNER/REPO/actions/permissions/workflow \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=true
```

The `set-up-this-repo` skill handles this during onboarding, and the
workflow surfaces a remediation hint in the job log if a sync fails.

## Customization

### Exclude files from sync

Edit `.templatesyncignore` to prevent specific files from being overwritten during template syncs. Uses `.gitignore` syntax.

### Add agent instructions or skills

Use `AGENTS.md` and `.agents/skills/*` to extend agent functionality for your project's workflows.
