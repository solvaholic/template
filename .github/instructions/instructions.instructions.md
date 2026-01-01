---
applyTo: "**/*.instructions.md"
---

# Path-Specific Instructions

These instructions apply when creating or updating path-specific instruction files (`*.instructions.md`).

## Purpose

Path-specific instructions provide context and guidelines for files matching specific patterns. They apply alongside repository-wide instructions, adding specialized knowledge for particular file types, directories, or workflows.

## File Naming

Name files descriptively before the `.instructions.md` extension:
- `testing.instructions.md` - Instructions for test files
- `api.instructions.md` - Instructions for API endpoints
- `scripts.instructions.md` - Instructions for automation scripts
- `config.instructions.md` - Instructions for configuration files

## File Structure

Every path-specific instruction file requires:

### YAML Frontmatter

```yaml
---
applyTo: "glob/pattern/**/*.py"
---
```

**Required field:**
- `applyTo`: Glob pattern(s) matching files where these instructions apply

**Optional fields:**
- `excludeAgent`: Agent to exclude (`"code-review"` or `"coding-agent"`)

**Multiple patterns:**
```yaml
---
applyTo: "src/**/*.ts,tests/**/*.test.ts"
---
```

### Markdown Body

After the frontmatter, write clear, actionable instructions:
- **Context**: What these files are and their purpose
- **Structure**: Expected file format, required sections, naming conventions
- **Guidelines**: Coding standards, testing requirements, documentation needs
- **Examples**: Show patterns to follow or avoid

## Best Practices

1. **Be specific to the file type** - Don't repeat general instructions from `copilot-instructions.md`
1. **Focus on patterns** - Highlight what makes these files special
1. **Include common mistakes** - Document pitfalls and how to avoid them
1. **Reference related files** - Link to schemas, types, or documentation
1. **Keep it current** - Update instructions when patterns change

## Location

Store all path-specific instructions in `.github/instructions/`:
```
.github/
  instructions/
    instructions.instructions.md   # This file
    testing.instructions.md
    api.instructions.md
    scripts.instructions.md
```

## Examples

### For Test Files
```yaml
---
applyTo: "**/*.test.ts,**/*.spec.ts"
---

# Test Files

All test files use Jest. Always include:
- Descriptive test names using `it('should ...')`
- Setup and teardown with `beforeEach`/`afterEach`
- Mock external dependencies
- Assertions checking both success and error cases

Run tests with `npm test` before committing.
```

### For Configuration
```yaml
---
applyTo: "**/config/*.json,**/config/*.yaml"
excludeAgent: "code-review"
---

# Configuration Files

Configuration files define environment-specific settings.

Never commit secrets - use environment variables.
Validate with `npm run validate-config` before deploying.
Document new fields in `docs/configuration.md`.
```

## When to Create Path-Specific Instructions

Create a new instruction file when:
- A file type has specific patterns or conventions
- Multiple files share structure or requirements
- Common mistakes occur in certain locations
- New developers need guidance on particular files

Don't create instructions for:
- One-off files with unique purposes
- Files covered adequately by repository-wide instructions
- Obvious or self-explanatory patterns
