TODO: Write a skill that helps the user review a PR raised by the
template sync workflow (.github/workflows/sync-from-template.yml).

Context:
- The sync workflow opens a PR with changes pulled from the upstream
  template repo on a schedule.
- The user (or their agent) has to decide which incoming changes to
  accept, modify, or reject - and may want to add rejected paths to
  .templatesyncignore to silence them in future syncs.
- This is exactly the moment when "what should be in
  .templatesyncignore?" is answerable, which is why set-up-this-repo
  punts the question instead of guessing up front.

Things this skill probably needs to do:
- Read the sync PR's diff and group changes by file/area.
- For each change: explain what's coming from the template, why it
  changed, and what the local impact is (especially on AGENTS.md,
  README.md, .gitignore, .vscode/*, which most projects customize).
- Recommend an action per file: accept, accept-with-edits, reject +
  add to .templatesyncignore, or revert local divergence.
- If the user rejects a path, edit .templatesyncignore in a follow-up
  commit on the same PR branch.
- Summarize decisions for the PR description / review comment.

Open questions:
- Should it run from a CI job, or only when the user invokes it locally
  / in chat? (Local-first is simpler; CI could surface a recommended
  review summary in the PR.)
- Does it need its own scripts/ for diff parsing, or is `gh pr diff`
  + agent reasoning enough?
- Anything to share with set-up-this-repo so users learn the
  .templatesyncignore mental model in both places?

Delete this file and write the real SKILL.md when picking this up.
