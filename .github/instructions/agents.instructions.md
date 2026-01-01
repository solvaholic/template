---
applyTo: "**/*.agent.md"
---

# Custom Agents

These instructions apply when creating or updating custom agent files (`*.agent.md`).

## Purpose

Custom agents are specialized AI assistants with specific instructions, tool access, and capabilities. They enable:
- **Role-based workflows** - Different agents for planning, implementation, review
- **Constrained capabilities** - Limit tools to appropriate actions (read-only for research, full editing for implementation)
- **Guided processes** - Chain agents together with handoffs for multi-step workflows
- **Team personas** - Multiple specialized agents collaborating on complex tasks

## File Naming

Name files with the agent's identifier before `.agent.md`:
- `planner.agent.md` - Planning and architecture agent
- `implementer.agent.md` - Code implementation agent
- `reviewer.agent.md` - Code review agent
- `designer.agent.md` - Design-focused agent

## File Location

Store custom agents in `.github/agents/` for repository-wide availability:
```
.github/
  agents/
    planner.agent.md
    implementer.agent.md
    reviewer.agent.md
```

Agents in this location are automatically discovered and available to all team members.

## File Structure

Every custom agent file requires:

### YAML Frontmatter

```yaml
---
name: agent-name
description: Brief description of agent's purpose
tools:
  - tool-name
  - another-tool
---
```

**Common fields:**
- `name`: Agent identifier (required)
- `description`: Clear purpose statement (required)
- `tools`: Array of available tools (optional, controls capabilities)
- `argument-hint`: Placeholder text for input field (optional)
- `model`: Specific model to use (optional)
- `handoffs`: Workflow transitions to other agents (optional)
- `infer`: Auto-detect when agent should be used (optional)
- `target`: Where agent runs - `tab`, `editor-inline`, `terminal-inline`, `notebook-inline` (optional)
- `mcp-servers`: Model Context Protocol servers to connect (optional)

### Markdown Body

After frontmatter, provide detailed instructions:
- **Role**: What persona or perspective this agent represents
- **Responsibilities**: Specific tasks this agent handles
- **Guidelines**: How the agent should approach problems
- **Constraints**: What the agent should avoid or prioritize
- **Output format**: Expected structure of agent's responses

## Tool Restriction Patterns

Control agent capabilities by specifying tools in frontmatter:

### Read-Only (Planning, Research)
```yaml
tools:
  - semantic_search
  - read_file
  - list_dir
  - grep_search
  - file_search
  - fetch_webpage
```

### Full Access (Implementation)
```yaml
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
  - semantic_search
```

### Specialized (Code Review)
```yaml
tools:
  - read_file
  - grep_search
  - get_errors
  - semantic_search
```

Omit `tools` field to allow default tool set for the agent type.

## Handoffs

Create guided workflows by chaining agents together:

```yaml
handoffs:
  - label: Start Implementation
    agent: implementer
    prompt: Implement the plan outlined above, following the architecture decisions.
    send: false
  - label: Request Review
    agent: reviewer
    prompt: Review the implementation for quality and adherence to requirements.
    send: true
```

**Handoff fields:**
- `label`: Button text shown to user (required)
- `agent`: Name of agent to hand off to (required)
- `prompt`: Message sent to next agent (required)
- `send`: Auto-submit prompt (true) or let user edit (false) (optional, default: false)

## Example Agents

### Planning Agent

```yaml
---
name: planner
description: Architectural planning and design decisions
tools:
  - semantic_search
  - read_file
  - list_dir
  - grep_search
argument-hint: Describe what you want to plan or design...
handoffs:
  - label: Begin Implementation
    agent: implementer
    prompt: Implement this plan step by step.
    send: false
---

# Planning Agent

You are an expert software architect focused on planning and design.

## Role

Create detailed, actionable plans before implementation begins.

## Responsibilities

- Analyze requirements and constraints
- Design system architecture and component structure
- Identify dependencies and potential issues
- Create step-by-step implementation plans
- Document decisions and rationale

## Guidelines

- Always search the codebase for existing patterns
- Consider backwards compatibility
- Break complex changes into incremental steps
- Highlight risks and unknowns
- Recommend tools and approaches

## Output Format

Provide:
1. **Overview**: Summary of the plan
1. **Architecture**: Component structure and relationships
1. **Steps**: Numbered, actionable implementation tasks
1. **Considerations**: Risks, dependencies, alternatives
1. **Validation**: How to verify success

Do not implement code - focus on planning only.
```

### Implementation Agent

```yaml
---
name: implementer
description: Code implementation following established plans
tools:
  - read_file
  - create_file
  - replace_string_in_file
  - run_in_terminal
  - semantic_search
  - get_errors
argument-hint: What should I implement?
handoffs:
  - label: Request Review
    agent: reviewer
    prompt: Please review this implementation.
    send: true
---

# Implementation Agent

You are an expert developer focused on implementing planned features.

## Role

Execute implementation plans with clean, tested code.

## Responsibilities

- Implement features according to plans
- Write idiomatic, maintainable code
- Add appropriate tests
- Handle errors and edge cases
- Update documentation

## Guidelines

- Follow existing code patterns and style
- Make small, focused changes
- Test after each significant change
- Fix errors immediately before proceeding
- Document complex logic with comments

## Output Format

- Implement requested changes directly
- Run tests to verify functionality
- Report completion with summary of changes
- Highlight any deviations from plan

Focus on implementation - delegate planning and review to specialized agents.
```

## Best Practices

1. **Single responsibility** - Each agent has a clear, focused purpose
1. **Appropriate tools** - Match capabilities to agent's role
1. **Clear boundaries** - Define what agent does and doesn't do
1. **Workflow integration** - Use handoffs for multi-stage processes
1. **Consistent style** - Keep instructions concise and actionable
1. **Human-readable** - Agents and developers should both understand

## When to Create Custom Agents

Create a custom agent when:
- A workflow has distinct phases requiring different capabilities
- You want role-based personas (designer, implementer, reviewer)
- Tool restriction improves quality (read-only for planning)
- Multi-agent collaboration enables better outcomes

Don't create agents for:
- Tasks handled well by default agents
- One-off or rare scenarios
- Simple operations not needing specialization

## Agent Discovery

Agents in `.github/agents/` are:
- Automatically detected by VS Code
- Available in Copilot chat with `@agent-name` syntax
- Shared with all repository collaborators
- Version controlled with code

## Maintenance

- **Keep instructions focused** - Avoid overlap with repository-wide instructions
- **Update tool lists** - Adjust capabilities as needs evolve
- **Refine handoffs** - Improve workflow transitions based on usage
- **Test regularly** - Verify agents behave as intended
- **Document changes** - Note when agent behavior or scope changes
