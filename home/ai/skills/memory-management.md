---
name: memory-management
description: "Global and project memory management for AI agents: shared context, persistence, synchronization between opencode and claude. Includes auto-features for session handoff, compaction injection, and project bootstrap."
category: "memory"
tags: ["memory", "context", "persistence", "sync", "harness-memory", "lemma", "honcho", "auto-sync", "bootstrap"]
provides:
  commands: ["memory-store", "memory-recall", "memory-sync", "memory-list", "memory-clear", "memory-migrate"]
  hooks: ["pre-task", "post-task", "session-start", "session-end"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Memory Management Skill

This skill manages persistent, shared memory across AI agent sessions and between opencode and claude-code.

## When to Use
- Storing project context, decisions, and patterns
- Sharing knowledge between opencode and claude-code
- Maintaining continuity across sessions
- Building institutional knowledge

## Architecture

### Three-Layer Memory

```
┌─────────────────────────────────────────────────────────┐
│                    GLOBAL MEMORY                         │
│  ~/.config/opencode/global-memory.md                    │
│  ~/.config/claude/global-memory.md                      │
│  Shared: user preferences, common patterns,             │
│          cross-project knowledge, nix expertise         │
└─────────────────────────────────────────────────────────┘
                          ↑ sync
┌─────────────────────────────────────────────────────────┐
│                    PROJECT MEMORY                        │
│  .opencode/project-memory.md                            │
│  .claude/project-memory.md                              │
│  Project-specific: architecture, decisions,             │
│                    conventions, gotchas                 │
└─────────────────────────────────────────────────────────┘
                          ↑ sync
┌─────────────────────────────────────────────────────────┐
│                    SESSION MEMORY                        │
│  In-memory + MCP servers (harness-memory, lemma)        │
│  Transient: current task context, temporary findings    │
└─────────────────────────────────────────────────────────┘
```

### MCP Memory Servers

| Server | Purpose | Persistence | Query |
|--------|---------|-------------|-------|
| **harness-memory** | Key-value + search | SQLite | SQL-like |
| **lemma** | Biological memory | SQLite + vector | Semantic |
| **honcho** | JSON log + provenance | JSON lines | Structured |

## Commands

### `/memory-store <key> <value> [--scope=SCOPE] [--tags=TAG1,TAG2]`
Store a memory entry.
- `--scope`: global|project|session (default: project)
- `--tags`: Comma-separated tags for categorization

Examples:
```
/memory-store "project-architecture" "Microservices with event-driven communication" --scope=project --tags=architecture,decision
/memory-store "nix-flake-pattern" "Use flake-utils.lib.eachDefaultSystem for cross-platform" --scope=global --tags=nix,pattern
/memory-store "api-rate-limit" "100 req/min per IP" --scope=project --tags=api,config
```

### `/memory-recall <key> [--scope=SCOPE]`
Retrieve a memory entry.
- `--scope`: global|project|session|all (default: all)

### `/memory-search <query> [--scope=SCOPE] [--tags=TAG1,TAG2]`
Search memory by content or tags.

### `/memory-list [--scope=SCOPE] [--tags=TAG1,TAG2]`
List all memory entries.

### `/memory-sync [--direction=DIR]`
Sync memory between opencode and claude-code.
- `--direction`: opencode-to-claude|claude-to-opencode|both (default: both)

### `/memory-clear [--scope=SCOPE] [--confirm]`
Clear memory (use with caution).

## Memory Formats

### Global Memory (Markdown)
```markdown
# Global Memory

## User Preferences
- Editor: neovim
- Shell: zsh
- Theme: dark

## Cross-Project Patterns

### Nix Flakes
- Always use `flake-utils.lib.eachDefaultSystem`
- Pin nixpkgs to specific commit
- Use `pkgs.lib.cleanSourceWith` for source filtering

### Python Projects
- Use `pyproject.toml` with `ruff` for linting
- `pytest` with `pytest-cov` for testing
- Type hints required

### Rust Projects
- `cargo clippy -- -D warnings` in CI
- `rustfmt` for formatting
- `proptest` for property-based testing

## Common Commands
- `nix flake check` - Validate flake
- `nix build .#checks.all` - Run all checks
- `direnv allow` - Enable direnv

## Learned Patterns
- [2024-09-15] Use `builtins.filter` instead of `lib.filter` in flake outputs
- [2024-09-10] `ruff` replaces `black`, `isort`, `flake8`, `pylint`
```

### Project Memory (Markdown)
```markdown
# Project Memory: my-awesome-project

## Architecture
- **Type**: CLI application
- **Language**: Rust
- **Framework**: clap + tokio
- **Data**: SQLite with sqlx

## Key Decisions
- [2024-09-15] Use `sqlx` for compile-time SQL verification
- [2024-09-14] Event sourcing for audit trail
- [2024-09-10] No ORM - direct SQL with sqlx

## Conventions
- Error handling: `thiserror` + `anyhow`
- Async: `tokio` with `tracing` for logging
- Config: `figment` with TOML files
- Testing: `sqlx` test fixtures + `mockall`

## Gotchas
- `sqlx` requires database running for `cargo check` (use `sqlx-cli prepare`)
- `tokio::spawn` tasks must be `'static` - use `Arc` for sharing
- Nix flake needs `rust-overlay` for nightly features

## API Endpoints
- `GET /api/v1/users` - List users
- `POST /api/v1/users` - Create user
- `GET /api/v1/users/:id` - Get user

## Environment Variables
- `DATABASE_URL` - SQLite path
- `RUST_LOG` - Logging level
- `SERVER_PORT` - Default 8080
```

## Auto-Sync Hooks

### Session Start
```bash
# Load project memory
/memory-recall "" --scope=project

# Load relevant global memory
/memory-recall "" --scope=global --tags=nix,pattern
```

### Pre-Task
```bash
# Search for relevant context
/memory-search "authentication" --scope=project
/memory-search "sqlx" --scope=global
```

### Post-Task
```bash
# Store new findings
/memory-store "task-finding-$(date +%s)" "Discovered: ..." --scope=project --tags=finding
```

### Session End
```bash
# Sync to global if valuable
/memory-sync --direction=opencode-to-claude
```

## Integration with Agents

### Opencode Configuration
```json
{
  "memory": {
    "global": {
      "enabled": true,
      "path": "~/.config/opencode/global-memory.md",
      "syncInterval": 300
    },
    "project": {
      "enabled": true,
      "path": ".opencode/project-memory.md",
      "autoLoad": true
    },
    "shared": {
      "enabled": true,
      "mcpServers": ["harness-memory", "lemma", "honcho"]
    }
  }
}
```

### Claude Code Configuration
```json
{
  "memory": {
    "global": {
      "enabled": true,
      "path": "~/.config/claude/global-memory.md"
    },
    "project": {
      "enabled": true,
      "path": ".claude/project-memory.md",
      "autoLoad": true
    },
    "shared": {
      "enabled": true,
      "mcpServers": ["harness-memory", "lemma", "honcho"]
    }
  }
}
```

## MCP Memory Operations

### Harness Memory (Key-Value)
```bash
# Store
/mcp call harness-memory memory_store '{"key": "arch-decision", "value": "Use event sourcing", "tags": ["architecture", "decision"]}'

# Recall
/mcp call harness-memory memory_recall '{"key": "arch-decision"}'

# Search
/mcp call harness-memory memory_search '{"query": "event", "tags": ["architecture"]}'
```

### Lemma (Semantic)
```bash
# Store with confidence
/mcp call lemma store '{"content": "Use sqlx for compile-time SQL checks", "confidence": 0.9, "tags": ["rust", "database"]}'

# Recall similar
/mcp call lemma recall '{"query": "database compile time", "threshold": 0.7}'
```

### Honcho (Structured Log)
```bash
# Store with provenance
/mcp call honcho append '{"agent": "opencode", "task": "refactor auth", "finding": "JWT validation missing", "confidence": 0.95}'

# Query
/mcp call honcho query '{"agent": "opencode", "tags": ["security"]}'
```

## Best Practices

1. **Store decisions, not code** - Code is in git
2. **Tag consistently** - Use standard tags: `architecture`, `decision`, `pattern`, `gotcha`, `config`, `finding`
3. **Sync regularly** - At least per session
4. **Review periodically** - Clean outdated entries
5. **Project memory in repo** - Commit `.opencode/project-memory.md` and `.claude/project-memory.md`
6. **Global memory personal** - Don't commit global memory

## Migration from CLAUDE.md

If you have existing `CLAUDE.md` files:

```bash
# Split into global and project
/memory-migrate --from=CLAUDE.md --global=~/.config/claude/global-memory.md --project=.claude/project-memory.md

# Sync to opencode
/memory-sync --direction=claude-to-opencode
```

## Auto-Features (Bootstrap Plugin)

The bootstrap plugin (enabled via MCP or agent config) provides these automatic behaviors:

1. **Session Handoff on `session.end`** — Automatically writes `SESSION_HANDOFF.md` to project memory with:
   - Current task summary
   - Key decisions made
   - Open TODOs and blockers
   - Next steps
   - Relevant context for resumption

2. **Compaction Context Injection** — Before context compaction, injects relevant project memory into the summary so compressed context retains critical project knowledge.

3. **Project Context Bootstrap** — On `session.start` in a new project, automatically:
   - Reads `.opencode/project-memory.md` and `.claude/project-memory.md`
   - Loads relevant global memory entries (tagged with project language/framework)
   - Primes MCP memory servers with project-specific keys

## Configuration

| Scope | Config File Path |
|-------|------------------|
| **Global** | `~/.config/memory-history/config.json` |
| **Project** | `<project>/.memory-history.json` |

Example `config.json`:
```json
{
  "globalMemoryPath": "~/.config/opencode/global-memory.md",
  "projectMemoryPath": ".opencode/project-memory.md",
  "mcpServers": ["harness-memory", "lemma", "honcho"],
  "autoSync": true,
  "syncInterval": 300,
  "tags": ["architecture", "decision", "pattern", "gotcha", "config", "finding"]
}
```