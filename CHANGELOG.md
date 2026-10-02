# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `donsetch` package: prebuilt keyless web fetch/search/crawl MCP server (v4.4.2) in `packages/donsetch.nix`
- `donsetch` local MCP server in `home/ai/mcp.nix`, with nixpkgs chromium as the tier-2 ghost browser
- Web research & verification rules in `home/ai/rules.nix`: verify-before-assert for external facts, `@scout` as designated web researcher, source citations required, unverified labeling on search failure

### Removed

- `opencode-websearch-cited` plugin and its OpenRouter `websearch_cited` model config: per-search grounding cost replaced by keyless donsetch search plus the built-in free `websearch` tool
