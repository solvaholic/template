---
applyTo: "**/SKILL.md"
---

# Agent Skills

These instructions apply when creating or updating agent skill files (`SKILL.md`).

## Purpose

Agent skills are reusable knowledge modules that agents load when relevant to the current task. Each skill contains specialized instructions, examples, and optional helper scripts that agents can reference during their work.

## When to Create a Skill

Create a skill for:
- **Repeatable processes** - Multi-step workflows that agents perform regularly
- **Specialized knowledge** - Domain expertise not in general instructions
- **Tool-specific guidance** - How to use particular tools or frameworks
- **Common patterns** - Solutions to recurring problems or tasks

Don't create skills for:
- One-time tasks or unique situations
- Information better suited to path-specific instructions
- General knowledge already in repository instructions

## Folder Structure

Each skill lives in its own subdirectory under `.github/skills/`:

```
.github/
  skills/
    skill-name/
      SKILL.md              # Required: skill definition
      example.py            # Optional: helper scripts
      template.json         # Optional: templates or schemas
      README.md             # Optional: human documentation
```

**Directory naming:**
- Use lowercase with hyphens for spaces
- Be descriptive: `database-migration`, `api-testing`, `docker-deployment`
- Keep names concise but clear

## SKILL.md Format

Every `SKILL.md` file must have:

### YAML Frontmatter

```yaml
---
name: skill-name
description: Brief description of what this skill does and when to use it
---
```

**Required fields:**
- `name`: Unique identifier, lowercase with hyphens (matches directory name)
- `description`: Clear, concise explanation helping agents decide when to use this skill

**Optional fields:**
- `license`: License information if skill includes licensed code or content

### Markdown Body

After the frontmatter, provide:

1. **Overview**: What the skill helps accomplish
1. **When to Use**: Specific scenarios where this skill applies
1. **Process**: Step-by-step instructions or guidelines
1. **Examples**: Concrete demonstrations of the skill in action
1. **Resources**: References to scripts, templates, or external docs in the skill directory

## How Skills Work

1. **Agent analyzes the prompt** and decides if any skills are relevant
1. **Agent loads matching skills** by injecting `SKILL.md` content into context
1. **Agent applies skill knowledge** to the current task
1. **Agent references resources** in the skill directory as needed

Agents automatically discover skills - no explicit invocation required.

## Best Practices

1. **Write for agents and humans** - Skills should be readable by both
1. **Focus the description** - Be specific about when the skill applies
1. **Include working examples** - Show concrete usage, not just theory
1. **Reference helper files** - Mention scripts/templates and their purpose
1. **Keep it modular** - One skill per specialized capability
1. **Document assumptions** - State prerequisites or dependencies clearly

## Example Structure

### Database Migration Skill

```
.github/skills/database-migration/
  SKILL.md
  migration-template.sql
  rollback-template.sql
```

**SKILL.md:**
```yaml
---
name: database-migration
description: Create and apply database migrations safely with rollback support
---

# Database Migration Skill

## When to Use

Use this skill when creating, reviewing, or applying database schema changes.

## Process

1. **Create migration file**: Use `migration-template.sql` in this directory
1. **Name with timestamp**: `YYYYMMDD_HHMMSS_description.sql`
1. **Include rollback**: Always provide a corresponding rollback in `rollback-template.sql`
1. **Test locally**: Apply and rollback on development database
1. **Document changes**: Update schema documentation in `docs/schema.md`

## Migration Template

See `migration-template.sql` for the standard format including:
- Transaction wrappers
- Conditional execution
- Error handling
- Rollback procedures

## Validation

Before committing:
- Run `npm run migrate:validate` to check syntax
- Ensure idempotency (can run multiple times safely)
- Test rollback procedure completely

## Resources

- `migration-template.sql`: Standard migration structure
- `rollback-template.sql`: Rollback procedure format
- See `docs/database.md` for connection details
```

## Location Precedence

Skills can exist in multiple locations with different precedence:
1. Repository: `.github/skills/` (repository-specific, recommended)
1. User profile: Custom location (personal skills across projects)

Repository skills take precedence for team collaboration.

## Maintenance

- **Update regularly**: Keep skills current as processes evolve
- **Archive obsolete skills**: Remove or move deprecated skills to `archived/`
- **Version control**: Commit skill changes with clear messages
- **Review impact**: Consider how skill changes affect agents' behavior
