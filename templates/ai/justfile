# Justfile - Command runner for AI-assisted development project
# Run inside the dev shell: nix develop -c just <recipe>
# Recipes detect enabled languages by tool availability.

default: help

help:
	@just --list

dev-shell:
	nix develop

# Formatting via pre-commit hooks (managed by git-hooks.nix)
fmt:
	pre-commit-run

# Tests
test:
	@echo "Running tests..."
	@if command -v cargo >/dev/null; then cargo nextest run; fi
	@if command -v pytest >/dev/null; then pytest -v; fi
	@if command -v npm >/dev/null; then npm ci --silent && npm test; fi

# Type checking
type-check:
	@if command -v mypy >/dev/null; then mypy src/python; fi
	@if command -v npm >/dev/null; then npm run typecheck; fi

# Security scans (semgrep/trivy use network databases)
security:
	@echo "Running security scans..."
	@if command -v semgrep >/dev/null; then semgrep scan --config auto .; fi
	@if command -v trivy >/dev/null; then trivy fs .; fi
	@if command -v bandit >/dev/null; then bandit -r src/python; fi
	@if command -v cargo-audit >/dev/null; then cargo audit; fi
	@if command -v git-secrets >/dev/null; then git secrets --scan; fi

# Build
build:
	@echo "Building project..."
	@if command -v cargo >/dev/null; then cargo build --release; fi
	@if command -v uv >/dev/null; then uv build; fi
	@if command -v npm >/dev/null; then npm run build; fi

build-docker:
	nix build .#dockerImage

# Dependency updates
deps-update:
	@echo "Updating dependencies..."
	@if command -v cargo >/dev/null; then cargo update; fi
	@if command -v uv >/dev/null; then uv lock --upgrade; fi
	@if command -v npm >/dev/null; then npm update; fi

# Clean build artifacts
clean:
	@if command -v cargo >/dev/null; then cargo clean; fi
	rm -rf dist build target .cache node_modules .pytest_cache .mypy_cache .ruff_cache .coverage htmlcov coverage
