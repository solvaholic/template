# template
@solvaholic's repository template

## What to do next

"So I created this repository from the template. Now what?"

1. Decide whether to use the included workflows (described below).
1. Configure repository settings, for example branch protection.
1. Confirm whether the included license and documentation are appropriate for this repository.
1. Replace this readme, which is in the `docs` directory.

## Included workflows

The workflows included with this template are enabled by default. View their results under this repository's _Actions_ tab.

### Lint Code Base

Runs **[github/super-linter](https://github.com/github/super-linter)** on each push to this repository, and adds the resulting status to the commit.

View or modify this workflow's configuration in `.github/workflows/linter.yml`.

### Sync changes from template

Periodically checks for changes in **[solvaholic/template](https://github.com/solvaholic/template)** and, if there are any, creates or updates a pull request in this repository to review the changes.

View or modify this workflow's configuration in `.github/workflows/sync-from-template.yml`.
