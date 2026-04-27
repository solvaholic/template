---
name: template-example
description: >-
  Hello World example skill that demonstrates the layout of a SKILL.md
  alongside assets/, references/, and scripts/. DO NOT activate this skill
  to do real work. Humans copy it as a starting point for new skills; agents
  should only read it when explicitly asked to explain the skill layout.
---

# template-example (Hello World)

This skill exists to **illustrate the shape of a skill**. It is not meant to
be activated to accomplish a task. If a user asks an agent to "say hello"
or similar, prefer a direct response over invoking this skill.

For the full specification, see <https://agentskills.io/specification.md>.

## Layout

```
template-example/
  SKILL.md                    # This file (frontmatter + instructions)
  assets/greeting.txt         # Static template the agent reads or copies
  references/REFERENCE.md     # Background docs the agent loads on demand
  scripts/hello.sh            # Executable code the agent can run
```

Pick a subdirectory by what the file *is*, not what it's about:

- `assets/` - static resources (templates, schemas, images)
- `references/` - markdown the agent reads when SKILL.md tells it to
- `scripts/` - executable code the agent runs

## How an agent would use these (illustrative)

If this skill were activated to greet `Ada`, an agent should:

1. Read `assets/greeting.txt` to get the template (`Hello, {{name}}!`).
2. Substitute `{{name}}` with `Ada`.
3. Optionally run the read-only helper: `scripts/hello.sh Ada`.
4. Read `references/REFERENCE.md` only if the user asks for background.

Note the pattern: **tell the agent when to load each resource**, not just
that it exists. "Read X if Y" beats "see references/ for details."

## Use this as a template for a new skill

1. Copy the directory:
   ```
   cp -r .agents/skills/template-example .agents/skills/<your-skill-name>
   ```
2. Rename in `SKILL.md` frontmatter: `name` must match the new directory
   name (lowercase, hyphens, 1-64 chars).
3. Rewrite `description` to say what the skill does AND when to activate
   it. Include trigger phrases. Add negative activation if a similar skill
   could fire on lookalike requests.
4. Replace the body with your skill's actual procedure.
5. Replace or delete `assets/`, `references/`, `scripts/` to match your
   skill's needs. Empty subdirectories can be removed.
6. Delete this skill once you no longer need the example.

## Boundaries

- Will: serve as a reference layout for humans authoring new skills.
- Will NOT: do useful work. Agents should not activate this skill to
  fulfill user requests.
