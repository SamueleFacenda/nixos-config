---
name: git-workflow
description: "Git workflow with feature branches, conventional commits, PRs, and automated checks. Philosophy: Git Flow is a branching protocol, not a tool. Pure git commands are portable. Includes decision tree, side-by-side workflows, and quick reference."
category: "workflow"
tags: ["git", "branch", "commit", "pr", "workflow", "conventional-commits", "git-flow", "pure-git"]
provides:
  commands: ["git-feature-start", "git-feature-finish", "git-commit", "git-pr-create", "git-sync", "git-flow-init", "git-status"]
  hooks: ["pre-commit", "commit-msg", "pre-push", "post-merge"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Git Workflow Skill

This skill enforces a consistent Git workflow with feature branches, conventional commits, and automated quality checks.

## When to Use
- Starting new features or fixes
- Making commits with proper messages
- Creating pull requests
- Syncing with upstream
- Enforcing code quality on commit/push

## Workflow Overview

```
main ←── release branches (optional)
  ↑
  └── feature/* ←── feature branches (one per feature/fix)
        ↑
        └── commits (atomic, conventional)
```

## Branch Strategy

### Branch Types
- `main` - Production-ready code
- `release/*` - Release preparation (optional)
- `feature/*` - New features
- `fix/*` - Bug fixes
- `chore/*` - Maintenance tasks
- `docs/*` - Documentation only
- `refactor/*` - Code refactoring
- `test/*` - Test additions/changes
- `security/*` - Security fixes

### Naming Convention
```
<type>/<short-description>
feature/user-authentication
fix/memory-leak-parser
chore/update-dependencies
```

## Commands

### `/git-feature-start <type> <description>`
Start a new feature branch.
- `type`: feature|fix|chore|docs|refactor|test|security
- `description`: Brief description (kebab-case)

Example:
```
/git-feature-start feature "add user dashboard"
# Creates: feature/add-user-dashboard
```

### `/git-commit [--type=TYPE] [--scope=SCOPE] [--breaking] <message>`
Create a conventional commit.
- `--type`: feat|fix|chore|docs|refactor|test|style|perf|ci|build|revert
- `--scope`: Optional scope
- `--breaking`: Mark as breaking change

Examples:
```
/git-commit "add user login endpoint" --type=feat --scope=auth
/git-commit "fix null pointer in parser" --type=fix --scope=parser
/git-commit "remove deprecated API" --type=refactor --scope=api --breaking
```

### `/git-feature-finish [--squash] [--no-verify]`
Finish current feature branch:
1. Run all checks (lint, test, format, security)
2. Push branch
3. Create PR
4. Optionally squash commits

Options:
- `--squash` - Squash all commits into one
- `--no-verify` - Skip pre-push hooks (not recommended)

### `/git-pr-create [--draft] [--reviewers=USER1,USER2]`
Create a pull request for current branch.
- `--draft` - Create as draft PR
- `--reviewers` - Request specific reviewers

### `/git-sync [--rebase]`
Sync with upstream main:
- Fetch latest
- Rebase or merge main into feature branch
- Push updated branch

Options:
- `--rebase` - Rebase instead of merge (default: true)

## Conventional Commits Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat` - New feature
- `fix` - Bug fix
- `chore` - Maintenance
- `docs` - Documentation
- `refactor` - Code restructuring
- `test` - Tests
- `style` - Formatting
- `perf` - Performance
- `ci` - CI/CD
- `build` - Build system
- `revert` - Revert commit

### Examples
```
feat(auth): add OAuth2 login support

fix(parser): handle empty input gracefully

refactor(api): simplify response handling

BREAKING CHANGE: remove v1 API endpoints
```

## Quality Gates (Pre-commit / Pre-push)

### Pre-commit (run on every commit)
```bash
# .git/hooks/pre-commit
#!/usr/bin/env bash
# 1. Format check
nix fmt --check $(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$')

# 2. Lint (language-specific)
ruff check $(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')
eslint $(git diff --cached --name-only --diff-filter=ACM | grep '\.ts$')

# 3. Security scan
semgrep --config=auto $(git diff --cached --name-only --diff-filter=ACM)

# 4. Secret detection
git-secrets --scan $(git diff --cached --name-only --diff-filter=ACM)
```

### Commit-msg (validate commit message)
```bash
# .git/hooks/commit-msg
#!/usr/bin/env bash
# Validate conventional commit format
commit_regex='^(feat|fix|chore|docs|refactor|test|style|perf|ci|build|revert)(\(.+\))?: .+'
if ! grep -qE "$commit_regex" "$1"; then
  echo "❌ Invalid commit message format"
  echo "Use: <type>(<scope>): <description>"
  exit 1
fi
```

### Pre-push (run on push)
```bash
# .git/hooks/pre-push
#!/usr/bin/env bash
# 1. Run tests
cargo test  # or pytest, npm test, etc.

# 2. Build check
nix build .#checks.x86_64-linux.pre-commit-check

# 3. Security audit
cargo audit  # or pip-audit, npm audit
```

## PR Requirements

### PR Template
```markdown
## Description
Brief description of changes

## Type
- [ ] Feature
- [ ] Fix
- [ ] Chore
- [ ] Docs
- [ ] Refactor
- [ ] Test
- [ ] Security

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing done

## Checklist
- [ ] Code formatted
- [ ] Lint passes
- [ ] Tests added/updated
- [ ] Docs updated
- [ ] Changelog entry added
- [ ] No breaking changes (or documented)
```

### Required Checks (Branch Protection)
- All CI checks pass
- Code review approved (1+ reviewers)
- No merge conflicts
- Changelog entry present
- Tests pass
- Security scan clean

## Integration with Other Skills

### Changelog
Auto-add entry on PR merge:
```bash
# Post-merge hook
git log -1 --pretty=format:"%s" | /changelog-add ...
```

### Testing
Run tests on every commit:
```bash
# Pre-push runs full test suite
```

### Security
Security scan on every push:
```bash
# Pre-push runs semgrep, trivy, etc.
```

## Configuration

### `.gitconfig` (global or project)
```ini
[commit]
  template = ~/.gitmessage.txt

[init]
  defaultBranch = main

[pull]
  rebase = true

[push]
  autoSetupRemote = true

[rebase]
  autoStash = true
```

### `.gitmessage.txt`
```
# <type>(<scope>): <subject>
# 
# <body>
# 
# <footer>
# 
# Types: feat, fix, chore, docs, refactor, test, style, perf, ci, build, revert
# Scope: optional module/component name
# Subject: imperative, lowercase, no period
# Body: explain what and why
# Footer: breaking changes, issue refs
```

## Best Practices

1. **One feature per branch** - Keep branches focused
2. **Atomic commits** - Each commit = one logical change
3. **Conventional messages** - Enable automation
4. **Small PRs** - Easier to review, less conflict
5. **Rebase often** - Avoid merge conflicts
6. **Delete merged branches** - Keep repo clean
7. **Sign commits** - Use GPG signing for verification

## Philosophy

**Git Workflow is a branching protocol, not a tool.** Pure git commands are portable, require no external dependencies, give you full control, and are easier to debug. Optional tools (like `git-flow` CLI) are just helpers — understanding the underlying git commands is essential.

## Core Branch Structure

| Branch | Purpose | Lifetime |
|--------|---------|----------|
| `main` | Production-ready code | Permanent |
| `develop` | Integration branch for next release | Permanent (optional, Git Flow) |
| `feature/*` | New features | Until merged to develop/main |
| `release/*` | Release preparation | Until merged to main + tagged |
| `hotfix/*` | Urgent production fixes | Until merged to main + develop |
| `chore/*`, `docs/*`, `refactor/*`, `test/*`, `security/*` | Specialized work | Until merged |

## Why Pure Git

- **No external dependencies** — Works anywhere git is installed
- **Full control** — Every flag, every option, no hidden behavior
- **Easier debugging** — When something breaks, you know exactly what ran
- **Portability** — Same commands work on Linux, macOS, Windows, CI, containers

## Quick Start

### Pure Git Method (Recommended)
```bash
# Initialize repo
git init
git commit --allow-empty -m "chore: initial commit"

# Create develop branch (Git Flow)
git checkout -b develop

# Start first feature
git checkout -b feature/my-feature develop
```

### Helper Script Method
```bash
# If you have the git-workflow helper scripts installed
git-workflow setup  # Creates branches, hooks, config
git-workflow feature start my-feature
```

### Optional Tool (git-flow CLI)
```bash
git flow init -d  # Defaults: main, develop, feature/, release/, hotfix/
```

## Workflow Decision Tree

```
                    ┌─────────────────┐
                    │ What do you need? │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
         ┌─────────┐   ┌───────────┐  ┌──────────┐
         │ New     │   │ Production│  │ Urgent   │
         │ feature?│   │ release?  │  │ hotfix?  │
         └────┬────┘   └─────┬─────┘  └────┬─────┘
              │              │             │
         ┌────▼────┐    ┌────▼────┐   ┌────▼────┐
         │ feature/│    │ release/│   │ hotfix/ │
         │ branch  │    │ branch  │   │ branch  │
         └────┬────┘    └────┬────┘   └────┬────┘
              │              │             │
              ▼              ▼             ▼
         ┌─────────┐   ┌───────────┐  ┌──────────┐
         │ Develop │   │  Merge to │  │ Merge to │
         │ (or main)│   │ main + tag│  │main+develop│
         └─────────┘   └───────────┘  └──────────┘
```

## Feature / Release / Hotfix Workflows (Side-by-Side)

### Feature Branch

| Step | Pure Git | Optional Tool (git-flow) |
|------|----------|--------------------------|
| **Start** | `git checkout -b feature/x develop` | `git flow feature start x` |
| **Work** | `git commit -m "feat: ..."` | Same |
| **Sync** | `git fetch && git rebase develop` | `git flow feature publish x` |
| **Finish** | `git checkout develop && git merge --no-ff feature/x` | `git flow feature finish x` |
| **Cleanup** | `git branch -d feature/x` | Auto |

### Release Branch

| Step | Pure Git | Optional Tool |
|------|----------|---------------|
| **Start** | `git checkout -b release/v1.2.0 develop` | `git flow release start v1.2.0` |
| **Prep** | Bump version, update changelog | Same |
| **Finish** | `git checkout main && git merge --no-ff release/v1.2.0 && git tag v1.2.0`<br>`git checkout develop && git merge --no-ff release/v1.2.0` | `git flow release finish v1.2.0` |

### Hotfix Branch

| Step | Pure Git | Optional Tool |
|------|----------|---------------|
| **Start** | `git checkout -b hotfix/x main` | `git flow hotfix start x` |
| **Fix** | `git commit -m "fix: ..."` | Same |
| **Finish** | `git checkout main && git merge --no-ff hotfix/x && git tag v1.2.1`<br>`git checkout develop && git merge --no-ff hotfix/x` | `git flow hotfix finish x` |

## Helper Scripts

If installed via the git-workflow skill package:

| Script | Usage | Description |
|--------|-------|-------------|
| `git-workflow setup` | `git-workflow setup` | Initialize repo with branches, hooks, config |
| `git-workflow feature` | `git-workflow feature start|finish|list <name>` | Feature branch management |
| `git-workflow release` | `git-workflow release start|finish <version>` | Release branch management |
| `git-workflow hotfix` | `git-workflow hotfix start|finish <name>` | Hotfix branch management |
| `git-workflow status` | `git-workflow status` | Show current branch, sync status, open PRs |
| `git-workflow sync` | `git-workflow sync [--rebase]` | Sync current branch with upstream |

## Branch Summary Table

| Branch Type | Source Branch | Merge Target | Naming Convention | Lifetime |
|-------------|---------------|--------------|-------------------|----------|
| `feature` | `develop` (or `main`) | `develop` (or `main`) | `feature/<short-desc>` | Days–weeks |
| `release` | `develop` | `main` + `develop` | `release/v<semver>` | Days |
| `hotfix` | `main` | `main` + `develop` | `hotfix/<short-desc>` | Hours–days |
| `chore` | `develop` (or `main`) | `develop` (or `main`) | `chore/<short-desc>` | Hours–days |
| `docs` | `develop` (or `main`) | `develop` (or `main`) | `docs/<short-desc>` | Hours–days |
| `refactor` | `develop` (or `main`) | `develop` (or `main`) | `refactor/<short-desc>` | Days |
| `test` | `develop` (or `main`) | `develop` (or `main`) | `test/<short-desc>` | Days |
| `security` | `develop` (or `main`) | `develop` (or `main`) | `security/<short-desc>` | Hours–days |

## Expanded Best Practices

- **Require `--no-ff` merges** — Preserves branch topology, makes history readable
- **One feature per branch** — Never mix unrelated changes
- **Descriptive commits** — Explain *what* and *why*, not *how*
- **Tag releases** — `git tag -a v1.2.0 -m "Release v1.2.0"`
- **Pull before starting** — `git fetch && git rebase origin/develop`
- **Know the underlying git** — Tools hide complexity; understand what they do

## Quick Reference Cheat Sheet (Pure Git)

```
# Initialize Git Flow structure
git init && git commit --allow-empty -m "chore: init"
git checkout -b develop

# Feature
git checkout -b feature/x develop
# ... work, commit ...
git checkout develop && git merge --no-ff feature/x && git branch -d feature/x

# Release
git checkout -b release/v1.2.0 develop
# ... version bump, changelog ...
git checkout main && git merge --no-ff release/v1.2.0 && git tag -a v1.2.0 -m "v1.2.0"
git checkout develop && git merge --no-ff release/v1.2.0 && git branch -d release/v1.2.0

# Hotfix
git checkout -b hotfix/x main
# ... fix, commit ...
git checkout main && git merge --no-ff hotfix/x && git tag -a v1.2.1 -m "v1.2.1"
git checkout develop && git merge --no-ff hotfix/x && git branch -d hotfix/x

# Sync
git fetch origin && git rebase origin/develop
```

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| `git flow` not found | Tool not installed | `brew install git-flow` / `apt install git-flow` / use pure git |
| Invalid branch name | Spaces, uppercase, special chars | Use kebab-case: `feature/my-feature` |
| Missing `develop` branch | Git Flow not initialized | `git checkout -b develop` or `git flow init` |
| Merge conflicts on rebase | Diverged history | `git rebase --abort`, then `git merge` instead |
| Pre-push hook fails | Tests/lint failing | Fix code, or `--no-verify` (emergency only) |

## When NOT to Use Git Flow

- **Continuous delivery** — Deploy `main` directly on every merge
- **Solo projects** — Overhead not worth it; simple `main` + feature branches
- **Frequent-deploy web services** — Trunk-based development preferred
- **Single-version mobile apps** — Simplified flow: `main` + `feature` only

## When Git Flow IS Ideal

- **Versioned releases** — Multiple supported versions (v1.x, v2.x)
- **Scheduled release cycles** — Monthly/quarterly releases
- **Multiple supported versions** — Backporting fixes to older releases
- **Mobile/desktop apps** — App store review cycles require stable release branches

## References

- [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/) — Original Git Flow article
- [Git Flow cheatsheet](https://danielkummer.github.io/git-flow-cheatsheet/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)