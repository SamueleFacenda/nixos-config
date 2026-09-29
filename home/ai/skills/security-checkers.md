---
name: security-checkers
description: "Security scanning and vulnerability detection: semgrep, bandit, trivy, git-secrets, and custom rules. Multi-tool trust checking with stepwise scan/detail/score/commit/report process."
category: "security"
tags: ["security", "vulnerability", "semgrep", "bandit", "trivy", "secrets", "audit", "trust-check", "mcp", "multi-tool"]
provides:
  commands: ["sec-scan", "sec-audit", "sec-fix", "sec-rules", "sec-report", "sec-trust-check"]
  hooks: ["pre-commit", "pre-push", "post-merge", "session-start"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Security Checkers Skill

This skill provides comprehensive security scanning using multiple tools to catch vulnerabilities, secrets, and misconfigurations.

## When to Use
- Pre-commit/pre-push security scans
- CI/CD security gates
- Dependency vulnerability audits
- Secret detection
- Custom security rule enforcement
- Security reporting

## Tools Overview

| Tool | Purpose | Languages | Speed |
|------|---------|-----------|-------|
| **semgrep** | SAST, custom rules | All | Fast |
| **bandit** | Python security | Python | Fast |
| **trivy** | Container/FS vulns | All | Medium |
| **git-secrets** | Secret detection | All | Fast |
| **cargo-audit** | Rust deps | Rust | Fast |
| **pip-audit** | Python deps | Python | Fast |
| **npm audit** | JS deps | JS/TS | Fast |
| **gosec** | Go security | Go | Fast |

## Commands

### `/sec-scan [--type=TYPE] [--fix] [--format=FORMAT]`
Run security scan.
- `--type`: sast|secrets|deps|container|all (default: all)
- `--fix` - Auto-fix where possible
- `--format`: text|json|sarif|html

Examples:
```
/sec-scan --type=sast
/sec-scan --type=secrets --fix
/sec-scan --type=deps --format=sarif
```

### `/sec-audit [--output=FILE]`
Full security audit with report.
- `--output` - Save report to file

### `/sec-fix <issue-id>`
Apply fix for specific issue (where supported).

### `/sec-rules [list|add|update|test]`
Manage custom security rules.

### `/sec-report [--since=DATE] [--format=FORMAT]`
Generate security report.
- `--since` - Only issues since date
- `--format` - markdown|json|html

## Configuration

### Semgrep Rules (`.semgrep.yml`)
```yaml
rules:
  # Built-in rulesets
  - id: p/secrets
  - id: p/owasp-top-ten
  - id: p/ci
  
  # Custom rules
  - pattern: |
      $X = os.getenv("SECRET_KEY")
    message: "Hardcoded secret key access"
    languages: [python]
    severity: ERROR
    metadata:
      category: secrets
      confidence: HIGH

  - pattern: |
      eval($X)
    message: "Dangerous eval usage"
    languages: [python, javascript, typescript]
    severity: WARNING
    metadata:
      category: injection

  - pattern: |
      subprocess.run(..., shell=True)
    message: "Shell injection risk"
    languages: [python]
    severity: ERROR
    metadata:
      category: injection

  - pattern: |
      $X.innerHTML = $Y
    message: "Potential XSS via innerHTML"
    languages: [javascript, typescript]
    severity: WARNING
    metadata:
      category: xss

  # Nix-specific
  - pattern: |
      builtins.exec
    message: "Arbitrary command execution in Nix"
    languages: [nix]
    severity: ERROR
```

### Bandit Config (`.bandit`)
```ini
[bandit]
exclude_dirs = tests,venv,.venv,__pycache__
skips = B101,B601
targets = src

[bandit:profiles]
default = B101,B601
```

### Trivy Config (`.trivyignore`)
```yaml
# Ignore specific vulnerabilities
- CVE-2023-1234: "Acceptable risk, mitigated by..."
- CVE-2024-5678: "Fixed in next version, backport pending"
```

### Git-secrets Patterns (`.git-secrets`)
```
# AWS
(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}
# GitHub
ghp_[a-zA-Z0-9]{36}
# Generic API keys
sk-[a-zA-Z0-9]{32,}
# Private keys
-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/security.yml
name: Security Scan
on: [push, pull_request, schedule]
jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install tools
        run: |
          pip install semgrep bandit trivy
          cargo install cargo-audit
          
      - name: SAST Scan
        run: semgrep --config=auto --sarif=results.sarif .
        
      - name: Python Security
        run: bandit -r src -f json -o bandit.json
        
      - name: Dependency Audit
        run: |
          cargo audit --json > cargo-audit.json || true
          pip-audit --format=json > pip-audit.json || true
          npm audit --json > npm-audit.json || true
          
      - name: Secret Detection
        run: git-secrets --scan
        
      - name: Container Scan
        if: hashFiles('Dockerfile') != ''
        run: trivy fs --format=sarif --output=trivy.sarif .
        
      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: results.sarif
```

### Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/returntocorp/semgrep
    rev: v1.95.0
    hooks:
      - id: semgrep
        args: [--config=auto, --error]
        
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: [-r, src, -f, json]
        
  - repo: https://github.com/awslabs/git-secrets
    rev: 1.3.0
    hooks:
      - id: git-secrets
        
  - repo: local
    hooks:
      - id: trivy-fs
        name: Trivy Filesystem Scan
        entry: trivy fs --exit-code 1 --severity HIGH,CRITICAL
        language: system
        files: Dockerfile$
```

## Custom Rules Development

### Semgrep Rule Template
```yaml
# rules/no-hardcoded-secrets.yaml
rules:
  - id: no-hardcoded-secrets
    patterns:
      - pattern-either:
          - pattern: $X = "sk_live_..."
          - pattern: $X = "sk_test_..."
          - pattern: $X = "ghp_..."
          - pattern: $X = "gho_..."
          - pattern: $X = "xoxb-..."
    message: "Hardcoded secret detected"
    languages: [python, javascript, typescript, go, rust, nix]
    severity: ERROR
    metadata:
      category: secrets
      owasp: "A07:2021 - Identification and Authentication Failures"
      cwe: "CWE-798: Use of Hard-coded Credentials"
      references:
        - https://owasp.org/Top10/A07_2021-Identification_and_Authentication_Failures
```

### Testing Rules
```bash
# Test rule against test cases
semgrep --test --config=rules/no-hardcoded-secrets.yaml

# Test file structure
test/
  no-hardcoded-secrets/
    test_ok.py      # Should NOT match
    test_bad.py     # Should match
```

## Language-Specific Checks

### Python
```bash
# Bandit - common issues
bandit -r src/ -ll  # Only high severity

# Pip-audit - dependencies
pip-audit --desc --format=json

# Semgrep - custom rules
semgrep --config=p/python --config=rules/ src/
```

### Rust
```bash
# Cargo audit - dependencies
cargo audit --json

# Cargo deny - licenses, bans
cargo deny check

# Semgrep - Rust rules
semgrep --config=p/rust src/
```

### JavaScript/TypeScript
```bash
# npm audit
npm audit --json --audit-level=high

# Semgrep - JS/TS rules
semgrep --config=p/javascript --config=p/typescript src/
```

### Go
```bash
# gosec
gosec ./...

# govulncheck
govulncheck ./...

# Semgrep
semgrep --config=p/go src/
```

### Nix
```bash
# Check for unsafe patterns
semgrep --config=rules/nix-security.yaml .

# nix flake check for eval errors
nix flake check
```

## Severity Levels

| Level | Action | Examples |
|-------|--------|----------|
| **CRITICAL** | Block commit/push | RCE, SQLi, hardcoded secrets |
| **HIGH** | Block commit/push | XSS, path traversal, weak crypto |
| **MEDIUM** | Warn, allow with review | Info disclosure, weak defaults |
| **LOW** | Info only | Best practice violations |
| **INFO** | Info only | Style, documentation |

## Auto-fix Capabilities

### Semgrep Auto-fix
```bash
# Dry run
semgrep --config=auto --autofix --dryrun .

# Apply fixes
semgrep --config=auto --autofix .
```

### Bandit
```bash
# Bandit doesn't auto-fix, but shows exact locations
bandit -r src/ -f json | jq '.results[] | {file, line, issue}'
```

## Reporting

### Security Dashboard (Markdown)
```markdown
# Security Report - 2024-09-15

## Summary
- Critical: 0
- High: 2
- Medium: 5
- Low: 12

## Critical Issues
None

## High Issues
1. **SQL Injection** in `src/db/query.py:42`
   - Rule: `p/sql-injection`
   - Fix: Use parameterized queries

2. **Hardcoded Secret** in `config/api.py:15`
   - Rule: `p/secrets`
   - Fix: Move to environment variable

## Dependency Vulnerabilities
| Package | CVE | Severity | Fixed Version |
|---------|-----|----------|---------------|
| requests | CVE-2023-32681 | HIGH | 2.31.1 |
| urllib3 | CVE-2024-37891 | MEDIUM | 2.2.1 |

## Recommendations
1. Update dependencies immediately
2. Rotate exposed secrets
3. Add parameterized query checks to CI
```

## MCP Trust Checking (`/sec-trust-check`)

This skill also performs **MCP server/tool trust checking** — verifying that declared MCP servers and tools are safe to use. This is a separate capability from code scanning.

### Hard Limit

**This skill only sees declared MCP server/tool configs on disk.** It does not observe runtime behavior, network traffic, or actual tool execution. No behavioral guarantees. Not legal advice.

### Multi-Tool Auto-Detection

Auto-detects config for:
- **Claude Code** (`.claude/settings.json`, `.mcp.json`)
- **OpenCode** (`.opencode/opencode.json`, `opencode.json`)
- **Codex** (`.codex/config.toml`)
- **Gemini** (`.gemini/settings.json`)
- **Cursor** (`.cursor/mcp.json`)

Reports which tool each finding belongs to.

### Stepwise Process

1. **Scan** — Run fingerprint/diff script → get `{new, changed, unchanged, removed}` connections
2. **Detail** — For each new/changed, fetch full tool schemas (via `ToolSearch` MCP or config + web lookup)
3. **Score** — Apply external `RISK-RUBRIC.md` (factors A–D; D can override to Critical)
4. **Commit** — Write JSON baseline for assessed entries only
5. **Report** — Summary line per connection: `🟢/🟡/🔴 <name> — <what it does> [— <biggest reason>]`

### Automatic Checking (Per Tool)

| Tool | Session-Start Hook | Notes |
|------|-------------------|-------|
| **Claude Code** | `.claude/settings.json` → `hooks.sessionStart` | Can trigger scan + nudge |
| **OpenCode** | `opencode.json` → `hooks.sessionStart` | Can trigger scan + nudge |
| **Codex** | `.codex/config.toml` → `hooks` | Limited support |
| **Gemini** | `.gemini/settings.json` | No native hooks |
| **Cursor** | `.cursor/mcp.json` | No native hooks |

### Out of Scope

**Scanning skill-file content** (the `.md`/`.yaml` files that define skills) is a different job. Use sibling skill `audit-skill-file` for that.

### Report Format

**Summary (default):**
```
🟢 lemma — Local semantic memory (SQLite + vector) — no network, read-only FS
🟡 harness-memory — Key-value + search (SQLite) — writes to ~/.local/share/
🔴 unknown-mcp — No schema, no provenance — D factor triggered
```

**Full breakdown** (on request): Includes raw 0–100 score, factor breakdown, schema excerpts, provenance chain.

---

## Best Practices

1. **Scan early, scan often** - Pre-commit + CI
2. **Custom rules for your codebase** - Generic rules miss context
3. **Ignore false positives deliberately** - Document why in `.trivyignore`
4. **Rotate secrets immediately** - If detected, assume compromised
5. **Pin dependency versions** - In flake.lock, Cargo.lock, package-lock.json
6. **Use allowlists sparingly** - Only for known false positives
7. **Monitor advisories** - Subscribe to security mailing lists
8. **Run trust-check on new MCP servers** - Before enabling in config
9. **Keep baseline updated** - Commit baseline after each assessment
10. **Separate code scanning from trust checking** - Different tools, different concerns