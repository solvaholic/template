# template
@solvaholic's repository template

## What's included

This template provides:

- **GitHub Copilot configuration** - Repository-wide and path-specific instructions for AI assistance
- **Template sync workflow** - Automated updates from the template repository
- **VS Code settings** - File associations and agent configurations

## Quick start

1. **Review Copilot instructions** in `.github/copilot-instructions.md` and customize for your project
2. **Configure the sync workflow** in `.github/workflows/sync-from-template.yml` (runs weekly by default)
3. **Set repository settings** - branch protection, collaborators, etc.
4. **Replace this readme** with project-specific documentation

## GitHub Copilot configuration

Located in `.github/`:

- `copilot-instructions.md` - Repository-wide instructions for Copilot
- `instructions/` - Path-specific instructions:
  - `instructions.instructions.md` - Guide for creating path-specific instructions
  - `skills.instructions.md` - Guide for creating agent skills
  - `agents.instructions.md` - Guide for creating custom agents

**Note:** `.github/copilot-instructions.md` is excluded from template syncs (via `.templatesyncignore`) so you can customize it per repository.

## Template sync workflow

Automatically checks for updates from **[solvaholic/template](https://github.com/solvaholic/template)** weekly (Fridays at 05:17 UTC) and creates a pull request with changes.

**Features:**
- Uses `AndreasAugustin/actions-template-sync@v2` for robust conflict handling
- Respects `.templatesyncignore` exclusion rules
- Preserves repository-specific files (workflows, README, .gitignore, Copilot instructions)
- Manual trigger available via Actions tab

**Configuration:** `.github/workflows/sync-from-template.yml`

## Customization

### Exclude files from sync

Edit `.templatesyncignore` to prevent specific files from being overwritten during template syncs. Uses `.gitignore` syntax.

### Add custom agents or skills

Follow the guides in `.github/instructions/` to extend Copilot functionality for your project's workflows.
