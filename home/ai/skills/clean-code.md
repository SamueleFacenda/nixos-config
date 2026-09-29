---
name: clean-code
description: "This skill embodies the principles of \"Clean Code\" by Robert C. Martin (Uncle Bob). Use it to transform \"code that works\" into \"code that is clean.\" Supports two modes: Review (report only) and Refactor (apply changes)."
license: MIT
compatibility:
  - opencode
  - claude-code
metadata:
  version: "1.0.0"
  languages: ["python", "javascript", "typescript", "rust", "go", "nix", "c", "cpp", "java"]
---

# Clean Code Skill

This skill embodies the principles of "Clean Code" by Robert C. Martin (Uncle Bob). Use it to transform "code that works" into "code that is clean."

## 🧠 Core Philosophy
> "Code is clean if it can be read, and enhanced by a developer other than its original author." — Grady Booch

## Modes

### Review Mode (Report Only)
**Trigger:** "review", "audit", "check", "analyze"
- Scans code and reports findings with severity levels
- Does NOT modify files
- Provides structured report with findings table

### Refactor Mode (Apply Changes)
**Trigger:** "refactor", "fix", "clean up", "apply"
- Applies safe, mechanical transformations
- Follows safe order (lowest-to-highest risk)
- Requires explicit approval for behavior-changing changes

## When to Use
- **Writing new code**: To ensure high quality from the start.
- **Reviewing Pull Requests**: To provide constructive, principle-based feedback.
- **Refactoring legacy code**: To identify and remove code smells.
- **Improving team standards**: To align on industry-standard best practices.

## Workflow (6 Steps)

1. **Scope** — Identify target files/directories and mode (review vs refactor)
2. **Baseline** — Capture current state (git diff, test results, lint status)
3. **Scan** — Run analysis against rule table (static analysis + pattern matching)
4. **Report** — Generate findings table with severity, location, fix, references
5. **Apply** (Refactor only) — Execute changes in safe order with approval gates
6. **Summary** — Produce final report with behavior-changing suggestions and not-touched list

## Rule Table

| Rule | Description | Severity | Location | Fix | Reference |
|------|-------------|----------|----------|-----|-----------|
| naming | Intention-revealing, searchable, pronounceable names | High | Functions, classes, variables | Rename | §1 |
| disinformation | Avoid misleading names (e.g., `accountList` for Map) | Medium | Variables, types | Rename | §1 |
| function-size | Small functions (<20 lines, ideally <10) | High | Functions | Extract method | §2 |
| single-responsibility | One thing per function/class (SRP) | High | Functions, classes | Extract class/method | §2, §8 |
| abstraction-level | One level of abstraction per function | Medium | Functions | Extract method | §2 |
| arguments | 0-2 args ideal, 3+ needs justification | Medium | Functions | Parameter object | §2 |
| side-effects | No hidden global state changes | High | Functions | Return values, pass context | §2 |
| comments | Minimal; only WHY/ALGORITHM/TODO/FIXME/HACK/NOTE/LEGAL | Medium | All | Rewrite code or use allowed tags | §3 |
| formatting | Consistent vertical density, distance, indentation | Low | All | Formatter (prettier, rustfmt, etc.) | §4 |
| demeter | Law of Demeter - no train wrecks | Medium | Objects | Hide internals, use interfaces | §5 |
| error-handling | Exceptions over return codes, no null | High | Error paths | Use Result/Option, custom exceptions | §6 |
| testing | TDD: failing test first, F.I.R.S.T. principles | High | Tests | Write test before code | §7 |
| class-size | Small classes, single responsibility | Medium | Classes | Extract class | §8 |

## Safe Order (Risk-Based Application)

1. **Mechanical** — Formatting, whitespace, imports sorting (zero risk)
2. **Within File** — Rename local variables, extract private methods (low risk)
3. **Across File** — Move functions between files, rename internal APIs (medium risk)
4. **Across Files** — Rename public/internal APIs, change signatures (higher risk)
5. **Behavior-Changing** — Algorithm changes, logic modifications (requires approval)

## Severity Levels

| Level | Action | Examples |
|-------|--------|----------|
| **High** | Block/refactor immediately | Null passes, >3 args, God functions, missing tests |
| **Medium** | Refactor before merge | Deep nesting, train wrecks, misleading names, inconsistent formatting |
| **Low** | Fix when convenient | Minor formatting, comment style, import order |

## Guardrails (Never Without Explicit Approval)
- Public API signatures (breaking changes)
- UI text / user-facing strings
- Dependency versions (package.json, Cargo.toml, requirements.txt, flake.nix)
- Generated files (protobuf, GraphQL, ORM migrations)
- Database schemas / migrations
- Security-sensitive code (auth, crypto, secrets handling)
- Performance-critical paths

## Report Format

```markdown
## Clean Code Report — <target>

### Summary
- Files scanned: N
- High: X | Medium: Y | Low: Z
- Behavior-changing suggestions: N

### Findings Table
| Severity | File | Line | Rule | Description | Suggested Fix |
|----------|------|------|------|-------------|---------------|

### Behavior-Changing Suggestions
- [ ] <description> — requires approval

### Not Touched (Guardrails)
- <file>:<line> — <reason>

### Suggested Application Order
1. Mechanical fixes (formatting, imports)
2. Within-file refactors
3. Cross-file moves
4. Behavior-changing (with approval)
```

## Language-Specific Notes

### Python
- Use type hints; run mypy --strict
- Prefer `pathlib` over `os.path`
- Use `dataclasses`/`attrs` for DTOs

### Rust
- Leverage type system; avoid `unwrap()`/`expect()` in production
- Use `Result<T, E>` for fallible operations
- Run `clippy --all-targets --all-features`

### TypeScript/JavaScript
- Strict mode + noImplicitAny + noUncheckedIndexedAccess
- Prefer `import type` for type-only imports
- ESLint with typescript-eslint recommended rules

### Nix
- Use `nix fmt` for formatting
- Prefer `lib` functions over raw builtins
- Keep flake.nix under 500 lines; split into modules

## 🛠️ Implementation Checklist
- [ ] Is this function smaller than 20 lines?
- [ ] Does this function do exactly one thing?
- [ ] Are all names searchable and intention-revealing?
- [ ] Have I avoided comments by making the code clearer?
- [ ] Am I passing too many arguments (3+)?
- [ ] Is there a failing test for this change?
- [ ] Are there any behavior-changing modifications? (requires approval)

## Limitations
- Use this skill only when the task clearly matches the scope described above.
- Do not treat the output as a substitute for environment-specific validation, testing, or expert review.
- Stop and ask for clarification if required inputs, permissions, safety boundaries, or success criteria are missing.