# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `donsetch` package: prebuilt keyless web fetch/search/crawl MCP server (v4.4.2) in `packages/donsetch.nix`
- `donsetch` local MCP server in `home/ai/mcp.nix`, with nixpkgs chromium as the tier-2 ghost browser
- Web research & verification rules in `home/ai/rules.nix`: verify-before-assert for external facts, `@scout` as designated web researcher, source citations required, unverified labeling on search failure
- `templates/ai`: `uv.lock` with a working uv2nix Python environment, `dockerImage` package behind the `docker` flake option, `vitest.config.ts`, EUPL-1.2 `LICENSE`

### Changed

- `templates/ai`: flake.nix rewritten to the stock git-hooks.nix pre-commit check (custom git-init/test-credentials wrapper removed), real uv2nix API, npm-only Node build, unused inputs dropped (`rust-overlay`, `flake-utils`), devshell trimmed
- `templates/ai`: CI uses real commands only (`nix flake check`, `nix develop -c just test/security`); GitHub docker job is manual (`workflow_dispatch`); GitLab publishes the image tarball as an artifact
- `templates/ai`: manifest package names standardized on `ai-project` so shipped lockfiles stay valid; placeholder replacement and lock regeneration documented in README
- `templates/ai`: Rust/Python/Node skeletons now compile, lint and test clean (config-crate API, zod 4 defaults, async-openai usage, eslint 9 flat config, vitest 5, reqwest rustls)

### Removed

- `opencode-websearch-cited` plugin and its OpenRouter `websearch_cited` model config: per-search grounding cost replaced by keyless donsetch search plus the built-in free `websearch` tool
- Built-in opencode `websearch`/`webfetch` tools: donsetch MCP tools cover all web access
- `templates/ai`: dead `project.toml` (read by nothing, invalid TOML), git-cliff config and changelog/release justfile recipes (manual keep-a-changelog only), fictional recipes (`test-watch`, `deps-check`, `VERSION`-based releases), empty `tests/integration/`
