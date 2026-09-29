---
name: changelog
description: "Generate comprehensive changelogs from git history, specs, and reviews. Produces five standard outputs: summary, user-impact, implementation, tech-debt, and docs-updates. Integrates with dev-review and git workflow."
category: "documentation"
tags: ["changelog", "keepachangelog", "release", "versioning", "documentation", "dev-review", "git-history", "spec-mapping"]
provides:
  commands: ["dev-changelog", "changelog-add", "changelog-release", "changelog-show", "changelog-validate"]
  hooks: ["pre-commit", "post-merge", "post-review"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Changelog Skill

This skill generates comprehensive changelogs from git history, specifications, and review feedback. It follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format for the main CHANGELOG.md, and produces five detailed analysis files under `plans/features/{feature}/` for deep context preservation and handoff.

## When to Use
- After a successful `/dev-review` passes
- At sprint/milestone end
- During handoff to another developer
- When resuming work after a break

## Usage Patterns

```
/dev-changelog <feature> [--since=<tag|date>] [--pr=<num>]
```

- `<feature>`: Feature name or branch name (e.g., "billing", "feature/user-auth")
- `--since`: Starting point for git history (default: last release tag)
- `--pr`: Specific PR number to analyze

## Output Structure

Generates five files under `plans/features/{feature}/`:

| File | Purpose |
|------|---------|
| `summary.md` | High-level narrative of what changed and why |
| `user-impact.md` | Table of user-visible changes with impact levels |
| `implementation.md` | Technical detail mapping commits → specs → use-cases |
| `tech-debt.md` | Extracted TODOs, incomplete items, review feedback |
| `docs-updates.md` | Mapping of new/changed APIs to documentation needs |

## Format (Keep a Changelog 1.1.0)

```markdown
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- New feature X
### Changed
- Updated Y to Z
### Deprecated
- Old method A
### Removed
- Deprecated B
### Fixed
- Bug in C
### Security
- Vulnerability D patched

## [1.2.0] - 2024-09-15
### Added
- Feature X
### Changed
- Updated Y
### Fixed
- Bug Z
```

## Section Order (Required)
1. **Added** - New features
2. **Changed** - Changes in existing functionality
3. **Deprecated** - Soon-to-be removed features
4. **Removed** - Removed features
5. **Fixed** - Bug fixes
6. **Security** - Vulnerability fixes

## Commands

### `/changelog-add <type> <description> [--scope=SCOPE] [--breaking]`
Add an entry to the Unreleased section.
- `type`: added|changed|deprecated|removed|fixed|security
- `description`: Brief description of the change
- `--scope`: Optional scope (e.g., "api", "cli", "ui")
- `--breaking`: Mark as breaking change

Examples:
```
/changelog-add added "User authentication with OAuth2" --scope=auth
/changelog-add fixed "Memory leak in data processor" --scope=core
/changelog-add changed "Updated API response format" --scope=api --breaking
```

### `/changelog-release <version> [--date=DATE]`
Release the Unreleased section as a new version.
- `version`: Semantic version (e.g., "1.2.0")
- `--date`: Release date (default: today)

This:
1. Renames "## [Unreleased]" to "## [1.2.0] - 2024-09-15"
2. Creates new "## [Unreleased]" section
3. Updates links if using link references

### `/changelog-show [version]`
Show changelog entries. Without version, shows Unreleased.

### `/changelog-validate`
Validate changelog format:
- Correct section order
- Valid version format
- Date format (YYYY-MM-DD)
- Link references resolve
- No empty sections (optional)

## Automation

### Pre-commit Hook
Add to `.pre-commit-config.yaml`:
```yaml
- repo: local
  hooks:
    - id: changelog-validate
      name: Validate Changelog
      entry: changelog-validate
      language: system
      files: 'CHANGELOG\.md$'
```

### CI/CD Integration
```yaml
# GitHub Actions
- name: Validate Changelog
  run: /changelog-validate

- name: Auto-add entry
  if: github.event_name == 'pull_request'
  run: |
    TYPE=$(echo "${{ github.event.pull_request.labels }}" | jq -r '.[] | select(.name | startswith("type:")) | .name | split(":")[1]')
    /changelog-add "$TYPE" "${{ github.event.pull_request.title }}" --scope="${{ github.event.repository.name }}"
```

## Best Practices

1. **Write for users** - Not for developers (no internal refs)
2. **Group related changes** - One entry per feature/fix
3. **Link to issues/PRs** - `[#123]` format
4. **No "Unreleased" edits on release** - Rename, don't edit
5. **Start new Unreleased** - After every release
6. **One line per entry** - Concise, imperative mood
7. **Semantic versioning** - Match changelog versions to semver

## Link References (Optional)

```markdown
[Unreleased]: https://github.com/user/repo/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/user/repo/releases/tag/v1.1.0
```

Update on release:
```
/changelog-release 1.2.0 --update-links
```

## Integration with Git Workflow

Works with `/git-workflow` skill:
- Feature branches → add entries on merge
- Release branches → run `/changelog-release`
- Hotfix branches → add to both release and unreleased

## Analysis Steps

1. **Collect Git Changes**: Run `git log --since=<tag|date> --oneline` to get commits. Use `git diff` for detailed changes.
2. **Read Specs/Use-Cases**: Load relevant SPEC.md and USE-CASES.md files from `specs/` or `docs/`.
3. **Map Changes**: For each changed file, map to spec items and use-cases. Mark completeness (✓/○/✗).
4. **Extract Tech Debt**: Grep for `TODO`, `FIXME`, `HACK`, `XXX`, `DEPRECATED`. Compare spec vs implementation. Note review comments from PR.
5. **Identify Doc Updates**: Build mapping table (new API → API reference, new UI → user guide, config changes → config docs, etc.).

## User Impact Analysis

Produce a table in `user-impact.md`:

| What Changed | Where | Why | Impact Level |
|--------------|-------|-----|--------------|
| OAuth2 login added | /auth/login | User request for SSO | **Visible** |
| API response format changed | /api/v1/users | Breaking change for v2 | **Breaking** |
| Memory leak fixed | core/processor | Internal optimization | **Behind-the-scenes** |

**Impact Levels:**
- **Breaking** — Existing integrations/scripts will fail
- **Visible** — User sees new/changed UI, behavior, or error messages
- **Behind-the-scenes** — No user-visible change (perf, refactor, internal)

## Resume Flow

When resuming work on a feature:

1. Read `implementation.md` — Understand what was done and how it maps to specs
2. Read `tech-debt.md` — See what's incomplete, what TODOs remain
3. Read latest `summary.md` — Get high-level context
4. Continue from the clearest next step

## Integration with `/dev-review`

After a successful `/dev-review` passes, the system should suggest running `/dev-changelog` to capture the completed work.

## Tools Used

- **Bash**: `git log`, `git diff`, `grep`, `awk` for extracting patterns
- **Read**: Load SPEC.md, USE-CASES.md, review comments
- **Write**: Create the five output files

## Example Walk-through

**Scenario**: Feature branch `feature/billing` with 12 commits since v1.0.0.

1. Run: `/dev-changelog billing --since=v1.0.0`
2. Skill collects 12 commits, reads `specs/billing.md` (3 use-cases), `USE-CASES.md` (5 use-cases)
3. Maps each commit to spec items:
   - `a1b2c3d` Add Stripe webhook handler → UC-1 (Payment processing) ✓
   - `e4f5g6h` Validate webhook signatures → UC-1 ✓
   - `i7j8k9l` Create subscription model → UC-2 (Subscriptions) ○
4. Extracts 3 TODOs from code, 2 review comments
5. Identifies 4 doc updates needed (new webhook endpoint, subscription API, error codes, migration guide)
6. Produces five files under `plans/features/billing/` with concrete content
7. Updates main CHANGELOG.md with unreleased entries for the feature