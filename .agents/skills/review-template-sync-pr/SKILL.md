---
name: review-template-sync-pr
description: >-
  Help the user review and resolve a PR opened by the template sync workflow
  (.github/workflows/sync-from-template.yml in repos cloned from
  solvaholic/template). Use when the user says "review the template sync
  PR", "review template sync", "what should I do with this template sync
  PR", "triage the chore/sync-from-template PR", or when an open PR is
  labeled `template-sync` and the user asks for help deciding what to
  accept, reject, or add to .templatesyncignore. DO NOT use for general
  PR review - use solv-pr-review for that. DO NOT use for PRs targeting
  solvaholic/template itself, or for unrelated bot PRs.
---

# Review Template Sync PR

## Purpose

Walk the user through triaging a PR opened by the
`AndreasAugustin/actions-template-sync` step in
`.github/workflows/sync-from-template.yml`. For each file in the diff,
recommend a clear action (accept / accept-with-edits / reject + ignore /
revert local) and apply the chosen mechanical changes on the PR branch
so merging the PR leaves the repo in the desired state and future syncs
stay quiet.

This is the companion to `set-up-this-repo`, which intentionally does
not guess `.templatesyncignore` entries up front. The right time to
decide what to preserve is when a sync PR actually surfaces the
conflict; that is exactly when this skill activates.

## When to Use

Activate when **all** of these hold:

- The current repository is a clone of `solvaholic/template`, NOT
  `solvaholic/template` itself.
- There is an open PR whose head branch starts with
  `chore/sync-from-template`, label includes `template-sync`, and title
  matches `Pull updates from solvaholic/template` (the workflow's
  defaults).
- The user wants help deciding what to do with that PR.

If only some of these hold, stop and confirm with the user before
proceeding. For arbitrary PR review, fall back to `solv-pr-review`.

## Process

### 1. Pre-flight (read-only)

Run these checks before touching anything. If any fails, stop and ask
the user how to proceed - do not attempt to "fix" the situation.

```bash
# Confirm we are NOT inside solvaholic/template itself.
gh repo view --json nameWithOwner -q .nameWithOwner

# Confirm clean worktree (we may revert files later).
git status --short

# Find the open sync PR.
gh pr list \
  --label template-sync \
  --state open \
  --json number,title,headRefName,baseRefName,author,url
```

Handle the result:

- **Repo is `solvaholic/template`**: stop. This skill does not apply.
- **Worktree is dirty**: ask the user to stash or commit before
  continuing. Reverts later in the procedure assume a clean tree.
- **Zero matching PRs**: tell the user there is nothing to review and
  stop. Do not invent work.
- **More than one matching PR**: list them, sorted by `createdAt`
  descending, and tell the user that only the newest will survive
  the next scheduled run (because of `is_pr_cleanup`, see Gotchas).
  Default to triaging the newest; ask before triaging an older one.
  Do not pick one silently.
- **Single match**: continue with that PR number as `<n>`.

Sanity-check the match against multiple signals (head branch prefix,
label, title, and that the author is typically `github-actions[bot]`).
A label alone is not enough - users sometimes label PRs by hand.

### 2. Gather the diff and metadata (read-only)

```bash
gh pr view <n> --json number,title,author,headRefName,baseRefName,labels,files,url
gh pr diff <n>

# Categorize file changes by type, including renames/deletes.
git fetch origin
git diff --name-status origin/<base>...origin/<head>
git diff --summary       origin/<base>...origin/<head>
```

Note specifically:

- **Deletes** (`D` in `--name-status`): the template removed a file
  upstream. Sync may try to delete it locally too. Treat deletions as
  their own bucket - they are often riskier than edits.
- **Mode changes / symlinks** (`--summary` shows `mode change`):
  `.github/copilot-instructions.md` is a symlink to `../AGENTS.md`
  (mode `120000`). Sync occasionally tries to materialize it as a
  regular file. Verify with:
  ```bash
  git ls-tree origin/<head> -- .github/copilot-instructions.md
  ```
  Mode `120000` = symlink (good). Mode `100644` = file (will break the
  symlink contract; reject this part of the diff).
- **Renames** (`R` in `--name-status`): inspect both old and new paths.
- **Binary files**: `gh pr diff` shows them as "Binary files differ" -
  flag for explicit user decision.
- **`~HEAD` conflict markers**: any path ending in `~HEAD` (e.g.,
  `.github/copilot-instructions.md~HEAD`) means the sync action could
  not auto-merge that file and dropped a conflict copy alongside it.
  Treat the underlying path as `accept-with-edits`: resolve the
  conflict on the PR branch (usually by keeping the local version and
  deleting the `~HEAD` file), and tell the user about the conflict
  explicitly. These are easy to miss because they look like new files.

Cache the current `.templatesyncignore` contents - you will edit it
later.

### 3. Classify each changed file

Group files into the buckets below and assign a default
recommendation. Defaults assume a typical downstream repo that ran
`set-up-this-repo` and customized agent/identity files.

| Bucket | Examples | Default recommendation |
| --- | --- | --- |
| **Project identity** | `AGENTS.md`, `README.md`, `LICENSE`, `LICENSE-content` | Reject + add to `.templatesyncignore` if not already covered. These were customized in `set-up-this-repo`. |
| **Agent symlink** | `.github/copilot-instructions.md` | Reject any change that breaks the symlink to `../AGENTS.md`. Accept only if the file remains a symlink with the correct target. |
| **Ignore rules** | `.gitignore`, `.templatesyncignore` | Manual merge. Take template additions that match the project's stack; keep local additions. Rarely a clean accept. |
| **Editor / tooling** | `.vscode/*`, `.editorconfig` | Reject if the user customized; accept if untouched locally. Check `git log --oneline -- <path>` to decide. |
| **Skills** | `.agents/skills/**` | Accept new shared skills. Reject re-introduction of `template-example/` or `set-up-this-repo/` if the user already removed them. |
| **Workflows** | `.github/workflows/*.yml` | `.templatesyncignore` already preserves all workflows except `sync-from-template.yml`, so most should not appear. If `sync-from-template.yml` itself changed, scrutinize carefully - a push to it triggers another run. |
| **Dependency / build manifests** | `package.json`, lockfiles, `pyproject.toml`, `uv.lock`, `go.mod`, `Cargo.toml`, `Makefile`, `tsconfig*.json` | Do not blind-accept. Validate locally before recommending accept. Often reject in customized repos. |
| **Repository governance** | `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `CODEOWNERS`, `.github/ISSUE_TEMPLATE/**`, `.github/pull_request_template.md` | Project-specific. Accept selectively; usually reject if locally customized. |
| **GitHub automation** | `.github/dependabot.yml`, CodeQL config, actionlint config, release config | Security- and permissions-sensitive. Review changed permissions and triggers explicitly before accepting. |
| **Dev environment** | `.devcontainer/**`, `.env.example`, `.node-version`, `.python-version`, `.tool-versions` | Affects every contributor. Reject if locally customized; otherwise accept and call it out in the summary. |
| **Deletions (any path)** | files removed upstream | Treat as its own decision. Default: reject the deletion (keep the local file) and add the path to `.templatesyncignore` so future syncs stop trying. |
| **Everything else** | - | Case by case. State your reasoning in the summary. |

For each file, record one of:

- `accept` - take the template's version as-is.
- `accept-with-edits` - take the template's version, then make follow-
  up local edits.
- `reject + ignore` - keep the local version; add the path to
  `.templatesyncignore` so it stops appearing in future syncs.
- `revert-local` - the local file diverged unintentionally; take the
  template's version and treat it as the new local baseline.

### 4. Apply mechanical changes on the PR branch

Default flow: edit on the sync PR's head branch so a single merge
captures both the kept template changes and the new ignore entries.

```bash
# Check out the PR branch.
gh pr checkout <n>

# For each "reject + ignore" file: restore the local version and
# append the path to .templatesyncignore.
git restore --source=origin/<base> -- <path>
# (then edit .templatesyncignore - see below)

# For each "accept-with-edits": leave the template version, make the
# additional edits, and stage them.
```

Update `.templatesyncignore` in one batch. Group new entries under a
comment so the next reviewer understands intent, e.g.:

```gitignore
# Rejected during template sync review on <date>: project-customized
AGENTS.md
README.md
```

Commit and push:

```bash
git add -A
git commit -m "chore: reject template-sync changes for customized files

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push
```

If `git push` is denied (the bot owns the branch and your token lacks
write access), fall back to a follow-up branch:

```bash
git switch -c chore/template-sync-followup
git push -u origin chore/template-sync-followup
gh pr create --base <base> --title "Follow-up: update .templatesyncignore from sync review" --body "..."
```

Then ask the user whether to close the original sync PR (the next
scheduled run will recreate it; with the new ignore entries merged
first, the recreated PR will be smaller).

### 5. Validate

After edits, confirm the result before declaring done.

```bash
git status --short
git diff --name-status origin/<base>...HEAD
git ls-tree HEAD -- .github/copilot-instructions.md   # expect mode 120000
```

For changed tooling, run lightweight validation if the project defines
it (e.g., the repo's own `npm test`, `pytest`, lint command). Skip if
validation needs network/credentials the agent lacks; tell the user
what to run.

### 6. Summarize for the PR

Post a single review comment on the sync PR using this template. One
row per file. Keep `decision` and `action taken` separate so it is
obvious where the agent recommended something but could not apply it.

```markdown
## Template sync review

| File | Bucket | Decision | Action taken | Rationale |
| --- | --- | --- | --- | --- |
| AGENTS.md | Project identity | reject + ignore | restored + added to .templatesyncignore | Customized in set-up-this-repo |
| .vscode/extensions.json | Editor / tooling | accept | none (kept template version) | Matches local stack |
| ... | ... | ... | ... | ... |

**.templatesyncignore additions:** `AGENTS.md`, `README.md`, ...

**Notes for the human reviewer:** <call out anything risky, e.g.,
workflow permissions changes, dependency bumps, or items you could not
auto-apply.>
```

Do **not** approve or merge the PR. Leave that decision to the user.

Always end the summary with a one-line reminder of the cleanup risk,
e.g.:

> ⚠️ The sync workflow uses `is_pr_cleanup: "true"`. If a new
> upstream commit lands before this PR merges, the next scheduled
> run (Fridays 0517 UTC) will close this PR without merging. Merge
> it, or cherry-pick the kept changes onto `main`, before then.

## Boundaries

- Will: read PR diff and metadata, classify changes, edit
  `.templatesyncignore`, restore files via `git restore`, push commits
  to the sync PR branch (or open a follow-up branch if blocked), and
  post a review comment summarizing decisions.
- Will NOT: approve or merge the PR, force-push, rewrite history on
  shared branches, change repo settings, or bypass branch protection.
- Will NOT: edit `.templatesyncignore` to silence a path without also
  recording the decision in the PR review comment.

## Gotchas

- **`.templatesyncignore` is forward-looking.** Adding a path to it
  does NOT remove that path from the current PR's diff. You must also
  `git restore` the file on the PR branch in the same commit.
  Otherwise the PR still ships the unwanted change.
- **Closing without merging brings it back.** The workflow runs on a
  weekly cron (`17 5 * * 5`) and on push to `sync-from-template.yml`.
  Closing the PR without merging means the same diff returns next
  Friday. Either merge (with rejections applied) or merge a follow-up
  PR that updates `.templatesyncignore` first.
- **`is_pr_cleanup: "true"` auto-closes stale sync PRs.** The
  workflow passes `is_pr_cleanup: "true"` to
  `AndreasAugustin/actions-template-sync`. When a new sync run finds
  a different upstream template hash, it opens a new
  `chore/sync-from-template_<newhash>` branch/PR and **closes any
  open sync PR whose head hash differs - without merging**. Any
  unmerged decisions on the older PR are lost (the branch may also
  be deleted depending on repo settings). Before the next scheduled
  run, either merge the PR you just reviewed, cherry-pick its kept
  changes onto a follow-up branch, or push the same `.templatesyncignore`
  additions to `main` directly. **Warn the user about this whenever
  you finish a review without merging.** When multiple sync PRs are
  already open with different hashes, only the newest will survive
  the next run - prefer triaging the newest first and porting any
  decisions from older PRs onto it.
- **`.github/copilot-instructions.md` is a symlink** to `../AGENTS.md`
  (mode `120000`). Some sync runs try to materialize it as a regular
  file. Always verify mode `120000` after edits with
  `git ls-tree HEAD -- .github/copilot-instructions.md`.
- **Editing `sync-from-template.yml` triggers another run.** The
  workflow has a `push` trigger on its own path. If the sync PR
  modifies that file and you push more commits to the branch, expect
  an extra workflow run.
- **PR author is `github-actions[bot]`.** Pushing to its branch
  requires write access on the repo; a personal access token may be
  needed if branch protection blocks the bot's branches. If push is
  denied, use the follow-up branch fallback in step 4.
- **Workflows are already broadly preserved.** `.templatesyncignore`
  defaults to `.github/workflows/*` with `!sync-from-template.yml` as
  the only exception. If a non-`sync-from-template.yml` workflow shows
  up in the diff, something is off - confirm before accepting.
- **`.templatesyncignore` uses `.gitignore` syntax** with one quirk:
  the action matches paths against the *file list*, not the working
  tree. Directory entries (`.vscode`) match files inside the
  directory; trailing slashes are not required.

## False positives

- Whitespace-only or line-ending diffs on `AGENTS.md` / `README.md`
  occasionally appear when the upstream template was edited from a
  different OS. These are not "real" template updates - reject and
  move on.
- A diff that only changes the date or comment header in
  `.templatesyncignore` itself is cosmetic; safe to accept.

## Cross-references

- `set-up-this-repo` - sibling skill that initially customizes a
  template clone. It explicitly punts on `.templatesyncignore` so this
  skill can pick it up later.
- `solv-pr-review` - use for general PR review; this skill is only for
  sync PRs.
