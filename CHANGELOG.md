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

- Plugin upgrades for OpenCode v2: ponytail v5.3.2 (dual V1/V2 entrypoint), `@xberg-io/opencode-crawlberg` 1.12.0 (V2 `ctx.tool.transform` API), opencode-chromium 1.9.3; `plugin` config key renamed to the v2-native `plugins`
- `crawlberg` Rust CLI (prebuilt v1.12.0) added to the opencode environment in `home/ai/plugins.nix`: the crawlberg plugin spawns it from PATH and it was never installed
- `templates/ai`: flake.nix rewritten to the stock git-hooks.nix pre-commit check (custom git-init/test-credentials wrapper removed), real uv2nix API, npm-only Node build, unused inputs dropped (`rust-overlay`, `flake-utils`), devshell trimmed
- `templates/ai`: CI uses real commands only (`nix flake check`, `nix develop -c just test/security`); GitHub docker job is manual (`workflow_dispatch`); GitLab publishes the image tarball as an artifact
- `templates/ai`: manifest package names standardized on `ai-project` so shipped lockfiles stay valid; placeholder replacement and lock regeneration documented in README
- `templates/ai`: Rust/Python/Node skeletons now compile, lint and test clean (config-crate API, zod 4 defaults, async-openai usage, eslint 9 flat config, vitest 5, reqwest rustls)

### Removed

- `opencode-websearch-cited` plugin and its OpenRouter `websearch_cited` model config: per-search grounding cost replaced by keyless donsetch search plus the built-in free `websearch` tool
- Built-in opencode `websearch`/`webfetch` tools: donsetch MCP tools cover all web access
- `opencode-toast-history` plugin: V1-only plugin with no V2 port upstream; native notification history is tracked in anomalyco/opencode#50082
- Dead `programs.opencode.tui` block: OpenCode v2 ignores `tui.json` and owns the auto-migrated `cli.json`
- `templates/ai`: dead `project.toml` (read by nothing, invalid TOML), git-cliff config and changelog/release justfile recipes (manual keep-a-changelog only), fictional recipes (`test-watch`, `deps-check`, `VERSION`-based releases), empty `tests/integration/`

### Fixed

- OpenCode v2 plugin loading in `home/ai/opencode.nix`: every local entry is now a directory with a root `server.js` entrypoint, which is v2's local-plugin contract — ponytail, token-optimizer-opencode, crawlberg and wakatime are detected again after the v2 upgrade silently skipped them (v1 read `package.json` entrypoints, v2 does not)
- `@tarquinen/opencode-dcp` and `opencode-chromium` ship with their npm dependency trees installed (vendored manifest+lock, offline `npm ci`): their compiled entries import the peer `@opencode-ai/plugin`/zod at runtime, which cannot resolve from a bare store path
- lemma MCP intermittent failure: OpenCode v2 recycles MCP connections on config reloads and lemma's `gracefulShutdown` called `process.exit(0)` without closing better-sqlite3, segfaulting in native teardown and taking in-flight sessions down; vendored patch closes the database before exit
