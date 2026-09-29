---
name: coding-rules
description: "Enforced coding standards: clean code, minimal comments, current-state documentation, no diff-anchored writing. Includes strict typing, import grouping, line length, naming conventions, log levels, and pre-commit gates."
category: "coding"
tags: ["clean-code", "comments", "documentation", "style", "rules", "uncle-bob", "strict-typing", "import-grouping", "naming-conventions", "log-levels", "pre-commit-gates"]
provides:
  commands: ["rules-check", "rules-fix", "rules-explain"]
  hooks: ["pre-commit", "post-edit", "pre-push"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Coding Rules & Guidelines

This document defines the mandatory coding standards for all projects. These rules are enforced via pre-commit hooks, CI checks, and agent behavior.

## Core Philosophy

> **"Code is clean if it can be read, and enhanced by a developer other than its original author."** — Grady Booch

Based on *Clean Code* by Robert C. Martin (Uncle Bob) and modern software engineering practices.

---

## 1. Comments - Minimal & Purposeful

### Rule: Prefer Clean Code Over Comments
```python
# ❌ BAD - Explains WHAT (obvious from code)
def calculate_total(items):
    total = 0
    for item in items:
        total += item.price  # Add price to total
    return total

# ✅ GOOD - Self-documenting code
def calculate_order_total(order_items: list[OrderItem]) -> Money:
    return sum(item.price for item in order_items)
```

### Allowed Comment Types (Only When Necessary)

| Type | Purpose | Example |
|------|---------|---------|
| **WHY** | Explain non-obvious reasoning | `# Using UUID v7 for time-ordered IDs` |
| **ALGORITHM** | Complex algorithm explanation | `# Rabin-Karp: rolling hash for O(n+m)` |
| **TODO/FIXME/HACK** | Temporary markers with ticket ref | `# TODO(#123): Remove after v2 migration` |
| **NOTE** | Important caveat | `# NOTE: API rate limited to 100/min` |
| **LEGAL/LICENSE** | Required headers | `# Copyright 2024, MIT License` |

### Forbidden Comment Types

| Type | Why Forbidden |
|------|---------------|
| **WHAT** | Code explains itself |
| **HOW** | Implementation detail, not intent |
| **REDUNDANT** | Repeats code in English |
| **MUMBLING** | Unclear, vague |
| **NOISE** | Clutter, position markers |
| **DIFF-ANCHORED** | References past state/git history |

### Comment Style
```python
# Single line for brief comments
# Multi-line for algorithms (only when necessary)
"""
Rabin-Karp string search:
- Compute hash of pattern
- Roll hash through text
- Verify match on hash collision
"""
```

---

## 2. Documentation - Current State Only

### Rule: Describe What Is, Not What Was

```markdown
# ❌ BAD - Diff-anchored, references past
## Authentication
This module **was refactored** to **replace** the old JWT implementation
**which used** RS256. The **new** version **now uses** ES256.

# ✅ GOOD - Current state only
## Authentication
This module implements JWT authentication using ES256 elliptic curve signatures.
Tokens contain user ID, roles, and expiration. Validation checks signature,
expiration, and audience claim.
```

### Forbidden Patterns
- "was changed to", "replaced", "updated from", "previous version"
- "before/after", "old/new", "legacy", "deprecated" (in docs, use code markers)
- Git references: "commit abc123", "PR #456", "in v1.2"
- Changelog-style writing in documentation

### Documentation Structure
```markdown
# Module/Component Name

## Purpose
One paragraph: what this does and why it exists.

## Interface
- Public API (functions, classes, endpoints)
- Input/output types
- Error conditions

## Behavior
- Key algorithms or logic
- State management
- Concurrency model

## Configuration
- Environment variables
- Config file options
- Defaults

## Dependencies
- External services
- Internal modules
- Version requirements

## Examples
```python
# Minimal usage example
result = authenticate(token)
```
```

---

## 3. Clean Code Principles (Uncle Bob)

### SOLID Principles

| Principle | Rule |
|-----------|------|
| **SRP** | One reason to change per module/class/function |
| **OCP** | Open for extension, closed for modification |
| **LSP** | Subtypes must be substitutable |
| **ISP** | Many specific interfaces > one general |
| **DIP** | Depend on abstractions, not concretions |

### Additional Principles

| Principle | Rule |
|-----------|------|
| **DRY** | Don't Repeat Yourself - extract common logic |
| **KISS** | Keep It Simple, Stupid - favor simplicity |
| **YAGNI** | You Aren't Gonna Need It - don't over-engineer |
| **TDD** | Test-Driven Development - test first |

### Metrics (Enforced)

| Metric | Limit | Tool |
|--------|-------|------|
| Function lines | ≤ 20 | `ruff`, `clippy`, `eslint` |
| Function parameters | ≤ 3 | `ruff`, `clippy`, `eslint` |
| Class lines | ≤ 100 | `ruff`, `clippy`, `eslint` |
| Nesting depth | ≤ 4 | `ruff`, `clippy`, `eslint` |
| Cognitive complexity | ≤ 15 | `sonar`, `codeclimate` |

---

## 4. Naming Conventions

### General Rules
- **Descriptive, searchable, pronounceable**
- **No abbreviations** (except domain-standard: `id`, `url`, `api`, `db`)
- **No encoding** (no `str_name`, `i_count`, `_private`)

### By Language

#### Python
```python
# ✅ GOOD
class UserRepository:
    def find_by_email(self, email: str) -> Optional[User]: ...

MAX_RETRY_ATTEMPTS = 3
DEFAULT_TIMEOUT_SECONDS = 30

# ❌ BAD
class UserRepo:
    def get_user(self, e): ...
MAX_RETRY = 3
```

#### Rust
```rust
// ✅ GOOD
struct UserRepository;
impl UserRepository {
    fn find_by_email(&self, email: &str) -> Option<User> { ... }
}

const MAX_RETRY_ATTEMPTS: u32 = 3;

// ❌ BAD
struct UserRepo;
impl UserRepo {
    fn get_user(&self, e: &str) -> Option<User> { ... }
}
```

#### TypeScript
```typescript
// ✅ GOOD
interface UserRepository {
  findByEmail(email: string): Promise<User | null>;
}

const MAX_RETRY_ATTEMPTS = 3;

// ❌ BAD
interface UserRepo {
  getUser(e: string): Promise<User | null>;
}
```

#### Nix
```nix
# ✅ GOOD
my-package = pkgs.stdenv.mkDerivation {
  pname = "my-package";
  version = "1.0.0";
  buildInputs = with pkgs; [ python3 ];
};

# ❌ BAD
myPack = pkgs.stdenv.mkDerivation {
  pname = "myPack";
  src = ./.;
};
```

---

## 5. Functions

### Rules
1. **Small** - ≤ 20 lines, ideally ≤ 10
2. **One thing** - Do one thing well
3. **One level of abstraction** - Don't mix high/low level
4. **Descriptive names** - Verbs for actions, nouns for values
5. **Few arguments** - 0 ideal, 1-2 ok, 3+ needs justification
6. **No side effects** - Pure functions preferred
7. **No output arguments** - Return values instead

### Examples
```python
# ❌ BAD - Does multiple things, side effects, many args
def process_user_data(user, db, cache, logger, config):
    user.validate()
    db.save(user)
    cache.invalidate(user.id)
    logger.info(f"Saved {user.name}")
    if config.send_email:
        send_welcome_email(user.email)

# ✅ GOOD - Small, focused, pure
def validate_user(user: User) -> ValidationResult: ...

def save_user(db: Database, user: User) -> UserId: ...

def invalidate_cache(cache: Cache, user_id: UserId) -> None: ...

def send_welcome_email(email: Email) -> None: ...

# Composition
def register_user(user: User, deps: Dependencies) -> Result:
    validation = validate_user(user)
    if not validation.valid:
        return Err(validation.errors)
    user_id = save_user(deps.db, user)
    invalidate_cache(deps.cache, user_id)
    send_welcome_email(user.email)
    return Ok(user_id)
```

---

## 6. Error Handling

### Rules
- **Exceptions over return codes** - Cleaner logic flow
- **Fail fast** - Validate early, crash early
- **Context in errors** - Include what, where, why
- **No empty catch blocks** - Always handle or re-raise
- **Custom exceptions** - Domain-specific error types

```python
# ❌ BAD
def divide(a, b):
    try:
        return a / b
    except:
        return None

# ✅ GOOD
class DivisionError(ValueError):
    def __init__(self, dividend: float, divisor: float):
        self.dividend = dividend
        self.divisor = divisor
        super().__init__(f"Cannot divide {dividend} by {divisor}")

def divide(dividend: float, divisor: float) -> float:
    if divisor == 0:
        raise DivisionError(dividend, divisor)
    return dividend / divisor
```

---

## 7. Testing (Enforced)

### Rules
- **Tests required** for all new code
- **TDD preferred** - Red, Green, Refactor
- **Coverage ≥ 80%** overall, 100% for critical paths
- **Fast unit tests** - < 100ms each
- **Deterministic** - No flaky tests
- **Descriptive names** - `test_should_return_error_when_input_invalid`

---

## 8. Formatting (Enforced by Tools)

| Language | Tool | Config |
|----------|------|--------|
| Nix | `nix fmt` | Built-in |
| Python | `ruff format` | `pyproject.toml` |
| Rust | `rustfmt` | `rustfmt.toml` |
| TypeScript | `prettier` | `.prettierrc` |
| Go | `gofmt` | Built-in |
| C/C++ | `clang-format` | `.clang-format` |
| Lua | `stylua` | `stylua.toml` |
| Markdown | `prettier` | `.prettierrc` |
| YAML | `prettier` | `.prettierrc` |
| JSON | `prettier` | `.prettierrc` |
| TOML | `taplo format` | `taplo.toml` |

---

## 9. Git Workflow (Enforced)

### Commits
- **Conventional Commits** - `type(scope): description`
- **Atomic** - One logical change per commit
- **Signed** - GPG signed commits required

### Branches
- **Feature branches** - `feature/short-description`
- **No direct pushes** to main
- **PR required** - Review + CI pass

---

## 10. Security (Enforced)

### Rules
- **No secrets in code** - Use environment variables
- **Parameterized queries** - No string interpolation in SQL
- **Input validation** - All external input validated
- **Dependency scanning** - Automated in CI
- **Secret scanning** - Pre-commit + CI

---

## Enforcement

### Pre-commit Hooks (`.pre-commit-config.yaml`)
```yaml
repos:
  # Formatting
  - repo: local
    hooks:
      - id: nix-fmt
        name: nix fmt
        entry: nix fmt
        language: system
        files: '\.nix$'
        
  # Python
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.5.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
      
  # Rust
  - repo: https://github.com/doublify/pre-commit-rust
    rev: v1.0
    hooks:
      - id: fmt
      - id: clippy
      
  # General
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-toml
      
  # Security
  - repo: https://github.com/returntocorp/semgrep
    rev: v1.95.0
    hooks:
      - id: semgrep
        args: [--config=auto, --error]
        
  - repo: https://github.com/awslabs/git-secrets
    rev: 1.3.0
    hooks:
      - id: git-secrets
```

### CI Checks
```nix
# flake.nix checks
checks = {
  format = pkgs.runCommand "format" { } ''
    nix fmt --check
    ruff format --check
    cargo fmt --check
    prettier --check .
  '';
  
  lint = pkgs.runCommand "lint" { } ''
    ruff check
    cargo clippy -- -D warnings
    eslint .
  '';
  
  test = pkgs.runCommand "test" { } ''
    pytest --cov-fail-under=80
    cargo test
    npm test
  '';
  
  security = pkgs.runCommand "security" { } ''
    semgrep --config=auto --error .
    bandit -r src
    cargo audit
    pip-audit
    npm audit --audit-level=high
    git-secrets --scan
    trivy fs --severity HIGH,CRITICAL .
  '';
  
  all = pkgs.runCommand "all" {
    buildInputs = [ self.checks.format self.checks.lint self.checks.test self.checks.security ];
  } '';
};
```

---

## Agent Behavior Rules

When using AI agents (opencode, claude-code), they MUST follow these rules:

1. **Never add WHAT/HOW comments** - Only WHY/ALGORITHM/TODO/NOTE/LEGAL
2. **Never write diff-anchored docs** - Current state only
3. **Never reference git history** in code or docs
4. **Follow Clean Code** - Small functions, good names, SOLID
5. **Write tests first** - TDD approach
6. **Run formatters/linters** before completing tasks
7. **Use conventional commits** for all commits
8. **Update changelog** on every merge
9. **Run security scans** on changes
10. **Prefer stdlib/native** over dependencies (YAGNI)

---

## Violation Handling

| Severity | Action |
|----------|--------|
| **Critical** | Block commit/push (security, secrets, build break) |
| **Error** | Block commit (format, lint, test fail) |
| **Warning** | Allow with review (complexity, style) |
| **Info** | Report only (best practices) |

---

## Exceptions

Exceptions require:
1. **Explicit justification** in code comment (`# EXCEPTION: ...`)
2. **Ticket reference** linking to discussion
3. **Review approval** from team lead
4. **Expiration date** for temporary exceptions

```python
# EXCEPTION(TICKET-123): Using global cache for performance
# Expires: 2024-12-31
# Reviewed by: @team-lead
_global_cache = {}
```