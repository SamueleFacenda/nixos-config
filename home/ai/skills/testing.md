---
name: testing
description: "Comprehensive testing strategies: unit, integration, e2e, property-based, and test automation. Includes prerequisites, trigger phrases, numbered workflow, categorized findings, and structured output."
category: "testing"
tags: ["testing", "unit", "integration", "e2e", "property-based", "coverage", "tdd", "playwright", "mcp", "browser-testing"]
provides:
  commands: ["test-run", "test-gen", "test-coverage", "test-watch", "test-debug", "test-browser", "test-console-scan"]
  hooks: ["pre-commit", "pre-push", "post-edit"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Testing Skill

This skill provides comprehensive testing strategies and automation for multiple languages and test types.

## When to Use
- Writing tests for new code
- Running test suites
- Generating tests from code
- Debugging failing tests
- Measuring coverage
- Setting up CI test pipelines

## Testing Pyramid

```
        /\
       /  \     E2E Tests (few)
      /----\    
     /      \   Integration Tests (some)
    /--------\ 
   /          \ Unit Tests (many)
  /------------\
```

## Test Types

### Unit Tests
- Test single functions/modules in isolation
- Fast, deterministic, no external dependencies
- Mock all external calls
- Target: >80% coverage

### Integration Tests
- Test module interactions
- Real dependencies (db, api, fs)
- Slower, need test environment
- Target: Critical paths

### End-to-End Tests
- Test full user workflows
- Real system, real data
- Slowest, most brittle
- Target: Happy paths only

### Property-Based Tests
- Generate random inputs
- Verify invariants hold
- Find edge cases
- Tools: hypothesis (Python), proptest (Rust), fast-check (TS)

## Commands

### `/test-run [--type=TYPE] [--watch] [--coverage] [--filter=PATTERN]`
Run tests with options.
- `--type`: unit|integration|e2e|all (default: all)
- `--watch` - Re-run on file changes
- `--coverage` - Generate coverage report
- `--filter` - Run tests matching pattern

Examples:
```
/test-run --type=unit --watch
/test-run --coverage --filter="auth"
/test-run --type=e2e --headed
```

### `/test-gen <file> [--framework=FRAMEWORK]`
Generate test file for source file.
- `--framework`: pytest|jest|vitest|cargo|go test|bats

### `/test-coverage [--open] [--threshold=80]`
Show coverage report.
- `--open` - Open HTML report in browser
- `--threshold` - Fail if below percentage

### `/test-watch`
Run tests in watch mode (auto-reload on changes).

### `/test-debug <test-name>`
Debug a specific test with breakpoints.

## Language-Specific Setup

### Python (pytest)
```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_functions = ["test_*"]
addopts = "-v --tb=short --strict-markers"
markers = [
  "unit: Unit tests",
  "integration: Integration tests",
  "e2e: End-to-end tests",
  "slow: Slow tests",
]

[tool.coverage.run]
source = ["src"]
omit = ["tests/*", "*/conftest.py"]

[tool.coverage.report]
exclude_lines = ["pragma: no cover", "def __repr__"]
fail_under = 80
```

```python
# tests/conftest.py
import pytest
from unittest.mock import Mock

@pytest.fixture
def mock_db():
    return Mock()

@pytest.fixture(autouse=True)
def reset_singletons():
    yield
    # Cleanup after each test
```

### Rust (cargo test)
```toml
# Cargo.toml
[dev-dependencies]
tokio = { version = "1", features = ["test-util"] }
mockall = "0.11"
proptest = "1.0"
rstest = "0.18"

[[test]]
name = "integration"
harness = false
```

```rust
// tests/integration.rs
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_property(input in ".*") {
        // Property-based test
    }
}
```

### TypeScript (vitest)
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    include: ['**/*.test.ts', '**/*.spec.ts'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80
      }
    },
    testTimeout: 10000,
    hookTimeout: 10000
  }
})
```

### Nix (nix flake checks)
```nix
# flake.nix
checks = {
  unit-tests = pkgs.runCommand "unit-tests" {
    buildInputs = with pkgs; [ python3 pytest ];
  } ''
    pytest tests/unit -v
  '';
  
  integration-tests = pkgs.runCommand "integration-tests" {
    buildInputs = with pkgs; [ python3 pytest postgresql ];
  } ''
    pytest tests/integration -v
  '';
  
  all-tests = pkgs.runCommand "all-tests" {
    buildInputs = with pkgs; [ python3 pytest ];
  } ''
    pytest --cov=src --cov-fail-under=80
  '';
};
```

## TDD Workflow

### Red-Green-Refactor Cycle
1. **Red** - Write failing test
2. **Green** - Make test pass (minimal code)
3. **Refactor** - Improve code, keep tests green

### TDD Commands
```
/test-gen src/auth.py --framework=pytest
# Edit test file to define expected behavior
/test-run --filter="test_login" --watch
# Implement login function
/test-run --filter="test_login"
# Refactor
/test-run
```

## Test Organization

```
tests/
├── unit/
│   ├── test_auth.py
│   ├── test_parser.py
│   └── conftest.py
├── integration/
│   ├── test_api.py
│   ├── test_database.py
│   └── conftest.py
├── e2e/
│   ├── test_user_flow.py
│   └── conftest.py
├── fixtures/
│   ├── sample_data.json
│   └── test_users.yaml
└── conftest.py
```

## Mocking Strategies

### Python
```python
from unittest.mock import Mock, patch, AsyncMock

# Mock external API
@patch('requests.get')
def test_fetch_user(mock_get):
    mock_get.return_value.json.return_value = {"id": 1, "name": "Test"}
    result = fetch_user(1)
    assert result.name == "Test"

# Mock database
@pytest.fixture
def mock_db():
    with patch('sqlalchemy.create_engine') as mock:
        yield mock
```

### Rust
```rust
#[cfg(test)]
mod tests {
    use mockall::automock;
    
    #[automock]
    trait UserRepository {
        fn find(&self, id: u64) -> Option<User>;
    }
    
    #[test]
    fn test_user_service() {
        let mut mock = MockUserRepository::new();
        mock.expect_find().returning(|_| Some(User::new()));
        // ...
    }
}
```

## Property-Based Testing

### Python (hypothesis)
```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_sort_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)

@given(st.text())
def test_encode_decode_roundtrip(text):
    assert decode(encode(text)) == text
```

### Rust (proptest)
```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_reverse_twice(v in prop::collection::vec(0..100u32, 0..100)) {
        let mut v1 = v.clone();
        v1.reverse();
        v1.reverse();
        prop_assert_eq!(v, v1);
    }
}
```

## CI Integration

### GitHub Actions
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: DeterminateSystems/nix-installer-action@v12
      - run: nix build .#checks.x86_64-linux.all-tests
      - run: nix build .#checks.x86_64-linux.security-audit
```

### Pre-push Hook
```bash
#!/usr/bin/env bash
# .git/hooks/pre-push
nix build .#checks.x86_64-linux.unit-tests
nix build .#checks.x86_64-linux.integration-tests
```

## Coverage Targets

| Metric | Minimum | Target |
|--------|---------|--------|
| Line Coverage | 80% | 90% |
| Branch Coverage | 70% | 85% |
| Function Coverage | 80% | 90% |
| Critical Paths | 100% | 100% |

## Best Practices

1. **Test behavior, not implementation** - Test what, not how
2. **One assertion per test** - Clear failure messages
3. **Descriptive names** - `test_should_return_error_when_input_invalid`
4. **Arrange-Act-Assert** - Clear test structure
5. **Fast unit tests** - <100ms each
6. **Deterministic** - No flaky tests
7. **Independent** - No test ordering dependencies
8. **Test edge cases** - Empty, null, boundary values

## Prerequisites

### Browser/Console Testing
- **Playwright MCP** — Required for `/test-browser` and `/test-console-scan` commands
- Install: `npx @playwright/mcp@latest` or via Nix flake

### Language-Specific Test Runners
- **Python**: pytest, hypothesis
- **Rust**: cargo test, proptest
- **TypeScript**: vitest, playwright
- **Go**: go test, testify
- **Nix**: nix flake checks

## Trigger Phrases

The following user phrases invoke this skill:

- "Run tests" / "Run the test suite"
- "Check for console errors on [URL]"
- "Find JS errors on my site"
- "Any broken requests?"
- "Run browser tests for [feature]"
- "Generate tests for [file]"
- "What's the coverage?"
- "Debug test [name]"

## Workflow (Numbered Steps)

### General Test Run
1. **Identify scope** — Determine test type (unit/integration/e2e) and filter
2. **Collect primary signals** — Run test command, capture output (pass/fail, durations)
3. **Collect secondary signals** — Coverage report, lint results, security findings
4. **Categorize findings** — Group into defined buckets (see Categories below)
5. **Produce structured output** — Summary + sections (see Output Format)

### Browser Console Scan (`/test-console-scan <url>`)
1. **Navigate** — `mcp__playwright__browser_navigate` to target URL
2. **Collect console messages** — `mcp__playwright__browser_console_messages`
3. **Collect network requests** — `mcp__playwright__browser_network_requests`
4. **Click through main links** — Exercise primary navigation paths
5. **Repeat** — Steps 2-4 for each page
6. **Categorize** — JS Errors, Failed Requests, Deprecation Warnings, Mixed Content, CSP Violations
7. **Output** — Structured report (see Output Format)

## Categories of Findings

| Category | Description | Examples |
|----------|-------------|----------|
| **Test Failures** | Assertion failures, panics, exceptions | `assert_eq!` failed, `pytest` assertion error |
| **Lint Warnings** | Style, complexity, best practice | `clippy` warnings, `ruff` violations |
| **Coverage Gaps** | Uncovered lines/branches/functions | Lines 42-58 not covered |
| **Security Findings** | SAST, secrets, dependency vulns | SQLi pattern, hardcoded secret |
| **Performance Regressions** | Benchmark slowdowns | 2x slower than baseline |
| **Flaky Tests** | Non-deterministic passes/fails | Passes 8/10 runs |
| **JS Errors** (browser) | Console.error, unhandled exceptions | `TypeError: Cannot read property...` |
| **Failed Requests** (browser) | 4xx/5xx responses, CORS errors | `GET /api/users 500` |
| **Deprecation Warnings** (browser) | Deprecated API usage | `webkitRequestAnimationFrame` |
| **Mixed Content** (browser) | HTTPS page loading HTTP resources | `http://cdn.example.com/script.js` |
| **CSP Violations** (browser) | Content Security Policy blocks | `script-src` violation |

## Output Format

### General Test Run
```
## Test Summary: [scope]
Files checked: N | Tests: P passed, F failed | Warnings: W | Coverage: L% lines, B% branches

### Test Failures
- `path/to/test.rs:42` — `test_user_login` — Expected `Ok(User)`, got `Err(NotFound)`

### Lint Warnings
- `src/auth.rs:15` — `clippy::unwrap_used` — Consider `expect` or `?`

### Coverage Gaps
- `src/payment.rs` — Lines 120-145 (error handling paths)

### Security Findings
- `src/db/query.py:42` — `p/sql-injection` — Use parameterized queries

### Clean Passes
- `tests/unit/` — All 47 tests passed
- `tests/integration/auth/` — All 12 tests passed
```

### Browser Console Scan
```
## Console Health: https://example.com
Pages checked: 5 | Errors: 2 | Warnings: 7

### Errors
- `https://example.com/dashboard` — `TypeError: Cannot read property 'id' of undefined` at `app.js:234`
- `https://example.com/settings` — `ReferenceError: ga is not defined` at `analytics.js:12`

### Warnings
- `https://example.com/` — `[Deprecation] 'webkitRequestAnimationFrame' is deprecated`
- `https://example.com/api` — `Failed to load resource: 404`

### Clean Pages
- `https://example.com/about`
- `https://example.com/contact`
```