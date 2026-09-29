# {{project_name}}

{{project_description}}

AI-assisted development project template with OpenRouter integration, multi-language support (Rust, Python, Node.js), and comprehensive tooling.

## Features

- 🤖 **OpenRouter Integration** - Single provider for all models (fast, smart, reasoning)
- 🔧 **Multi-language Support** - Rust, Python, Node.js in one project
- ⚡ **Token Optimization** - Headroom proxy for cost reduction
- 🧠 **Shared Memory** - Global and project-level memory for AI agents
- 🔍 **Language Servers** - Full LSP support for all languages
- 🛡️ **Security First** - Semgrep, Bandit, Trivy, cargo-audit, pip-audit, npm-audit
- 🪝 **Pre-commit Hooks** - Via git-hooks.nix (nix-managed, reproducible)
- 📦 **Docker Support** - Reproducible container builds
- 🚀 **CI/CD** - GitHub Actions and GitLab CI pipelines
- 📝 **Changelog** - Keep a Changelog format with git-cliff
- 🌿 **Git Workflow** - Feature branches, conventional commits, PRs

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [Direnv](https://direnv.net/) for automatic environment loading
- OpenRouter API key (get from [openrouter.ai/keys](https://openrouter.ai/keys))

### Create a New Project

```bash
# Using the template directly
/nixos-config/templates/ai/create-project.sh my-project "My AI project" "John Doe" "john@example.com" "johndoe"

# Or manually
git clone https://github.com/your-org/ai-template my-project
cd my-project
# Replace placeholders in all files
```

### Setup

```bash
# Enter project directory
cd my-project

# Copy local env template and add your API key
cp .envrc.local.example .envrc.local
# Edit .envrc.local and add your OPENROUTER_API_KEY

# Allow direnv
direnv allow

# Enter development shell
nix develop
```

### Development Commands

Once in the dev shell (`nix develop`), you have access to:

```bash
# Run all checks (format, lint, test, security, pre-commit)
/nix-flake-check

# Run tests
/test-run

# Security scan
/sec-scan

# Add changelog entry
/changelog-add

# Start new feature branch
/git-feature-start my-feature

# Run AI agents
opencode
claude
```

## Project Structure

```
my-project/
├── .github/workflows/     # GitHub Actions CI/CD
├── .gitlab-ci.yml         # GitLab CI/CD
├── src/
│   ├── rust/              # Rust source code
│   ├── python/            # Python source code
│   └── nodejs/            # Node.js/TypeScript source code
├── tests/
│   ├── unit/              # Unit tests
│   └── integration/       # Integration tests
├── docs/                  # Documentation
├── .ai-memory/            # Project AI memory (gitignored)
├── flake.nix              # Nix flake configuration
├── .envrc                 # Direnv configuration
├── .cliff.toml            # git-cliff changelog config
├── config.toml            # Application configuration
├── Cargo.toml             # Rust workspace
├── pyproject.toml         # Python project
├── package.json           # Node.js project
├── tsconfig.json          # TypeScript config
├── justfile               # Command runner
├── CHANGELOG.md           # Keep a Changelog
└── README.md              # This file
```

## AI Agent Configuration

This template uses **OpenRouter exclusively** for all AI models:

| Model Type | Model | Use Case |
|------------|-------|----------|
| Fast | `deepseek/deepseek-chat-v3-0324:free` | Simple tasks, quick responses |
| Smart | `google/gemini-2.5-flash` | General development, coding |
| Reasoning | `openai/gpt-5` | Complex problems, architecture |

Token optimization via **Headroom** proxy reduces costs by 30-70%.

### Memory System

- **Global Memory** (`~/.config/ai-memory`) - Shared across all projects
- **Project Memory** (`.ai-memory/`) - Project-specific context
- **Harness Memory** (`.ai-memory/harness-memory.db`) - Test/execution history
- **Lemma DB** (`.ai-memory/lemma.db`) - Learned patterns and facts

## Language-Specific Commands

### Rust
```bash
cargo build          # Build
cargo test           # Test
cargo fmt            # Format
cargo clippy         # Lint
cargo nextest run    # Fast tests
```

### Python
```bash
uv run pytest        # Test
uv run ruff check .  # Lint
uv run ruff format . # Format
uv run mypy .        # Type check
```

### Node.js
```bash
pnpm test            # Test
pnpm lint            # Lint
pnpm format          # Format
pnpm typecheck       # Type check
pnpm build           # Build
```

## Git Workflow

### Branch Naming
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation
- `refactor/description` - Refactoring
- `chore/description` - Maintenance

### Commit Messages (Conventional Commits)
```
type(scope): description

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `perf`, `refactor`, `docs`, `style`, `test`, `chore`, `build`, `ci`, `revert`

### Pull Requests
1. Create feature branch from `develop`
2. Make changes with conventional commits
3. Run `/nix-flake-check` locally
4. Open PR to `develop`
5. CI must pass
6. Code review required
7. Squash merge to `develop`
8. Release from `main` via tags

## CI/CD

### GitHub Actions
- **Checks** - Flake check, pre-commit, formatting
- **Tests** - Unit and integration tests
- **Security** - Semgrep, Bandit, Trivy, dependency audits
- **Docker** - Build and push on main branch
- **Release** - Auto-generate changelog on tags

### GitLab CI
Same stages with GitLab-specific features (environments, manual deployments)

## Security

All security tools run in CI and locally via pre-commit:

- **SAST**: Semgrep (multi-language)
- **Secrets**: Git-secrets, Gitleaks
- **Dependencies**: cargo-audit, pip-audit, npm-audit
- **Container**: Trivy filesystem scan
- **Python**: Bandit

## Docker

```bash
# Build image
IMAGE_TAG=latest nix build .#dockerImage

# Run container
docker run --rm ai-projects:latest
```

## License

EUPL-1.2 (European Union Public License 1.2) - See [LICENSE](LICENSE) for details.

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Run checks: `/nix-flake-check`
5. Submit PR

## Support

- Issues: [GitHub Issues](https://github.com/{{github_user}}/{{project_name}}/issues)
- Discussions: [GitHub Discussions](https://github.com/{{github_user}}/{{project_name}}/discussions)