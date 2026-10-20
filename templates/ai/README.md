# {{project_name}}

{{project_description}}

AI-assisted development project template with OpenRouter integration,
multi-language support (Rust, Python, Node.js), and Nix-managed tooling.

## Features

- Multi-language support - Rust, Python, Node.js behind per-language flake options
- Reproducible dev shell and packages via Nix (flake-parts)
- Python environment built by uv2nix from `uv.lock`
- Pre-commit hooks via git-hooks.nix (nix-managed, run with prek)
- Security tooling - semgrep, trivy, git-secrets, bandit, cargo-audit
- CI pipelines for GitHub Actions and GitLab
- Keep a Changelog (maintained manually)
- AI agent skeletons (OpenRouter client) in `src/` for each language

## Quick Start

### Create a new project

```bash
nix flake init -t /nixos-config#ai
```

### Replace placeholders

```bash
grep -rl --exclude-dir=.git '{{' . | xargs sed -i \
  -e "s/{{project_name}}/my-project/g" \
  -e "s/{{project_description}}/My project/g" \
  -e "s/{{author_name}}/John Doe/g" \
  -e "s/{{author_email}}/john@example.com/g" \
  -e "s/{{github_user}}/johndoe/g"
```

Package names in `Cargo.toml`, `pyproject.toml`, and `package.json` stay
`ai-project` so the lockfiles remain valid. Rename them and regenerate the
locks when you want your own package name:

```bash
# after renaming, in the dev shell:
cargo update && uv lock && npm install
```

### Enter the development shell

```bash
direnv allow   # or: nix develop
```

### Enable languages

All languages are off by default. Edit the `config` block in `flake.nix`:

```nix
config = {
  rust = true;
  python = true;
  nodejs = true;
  docker = true;   # adds the dockerImage package
};
```

### OpenRouter API key

Export `OPENROUTER_API_KEY` in your environment. With direnv, add it to a
`.env` file in the project root (gitignored, loaded by `dotenv_if_exists`).

## Commands

Inside the dev shell:

```bash
nix flake check        # all checks incl. pre-commit
pre-commit-run         # format via pre-commit hooks
just test              # tests for enabled languages
just type-check        # mypy / tsc
just build             # build enabled languages
just security          # semgrep, trivy, bandit, cargo-audit, git-secrets
just deps-update       # cargo update, uv lock --upgrade, npm update
just build-docker      # nix build .#dockerImage (needs docker option)
```

Language-specific tools are added to the shell when the language is enabled:

- Rust: cargo, clippy, rustfmt, cargo-nextest, cargo-audit, rust-analyzer
- Python: uv2nix venv (pytest, mypy, ruff, bandit from lockfile), uv
- Node.js: node, npm

## Project Structure

```
├── .github/workflows/     # GitHub Actions CI
├── .gitlab-ci.yml         # GitLab CI
├── .claude/               # Claude project memory
├── .opencode/            # OpenCode project memory
├── src/
│   ├── rust/             # Rust skeleton (OpenRouter client, config)
│   ├── python/           # Python skeleton (typer CLI, env-based config)
│   └── nodejs/           # TypeScript skeleton (commander CLI, TOML config)
├── tests/unit/           # Unit tests per language
├── flake.nix             # Dev shell, packages, checks, language options
├── pyproject.toml        # Python project (uv.lock drives uv2nix)
├── Cargo.toml            # Rust package
├── package.json          # Node.js project (npm, package-lock.json)
├── justfile              # Command runner
├── CHANGELOG.md          # Keep a Changelog (manual)
└── LICENSE               # EUPL-1.2
```

## Changelog

Maintained manually in [CHANGELOG.md](CHANGELOG.md) following
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Add entries to the
`[Unreleased]` section with each change.

## CI

- **GitHub Actions** (`.github/workflows/ci.yml`): flake checks, tests, and a
  security scan on push/PR to `main`/`develop`. The docker job is manual
  (`workflow_dispatch`) and needs the `docker` option enabled.
- **GitLab CI** (`.gitlab-ci.yml`): same stages; the docker job publishes the
  image tarball as an artifact on `main` and tags.

## License

EUPL-1.2 - see [LICENSE](LICENSE).
