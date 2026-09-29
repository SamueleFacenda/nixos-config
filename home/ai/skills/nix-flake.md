---
name: nix-flake
description: "Nix flake development, templates, and best practices for reproducible environments. Covers architecture lifecycle, module options, agent model routing, and non-obvious facts from community flakes."
category: "language"
tags: ["nix", "flake", "devshell", "reproducible", "template", "flake-parts", "home-manager", "agent-routing"]
provides:
  commands: ["nix-flake-init", "nix-flake-check", "nix-flake-update", "nix-flake-template", "nix-flake-arch", "nix-flake-options"]
  hooks: ["pre-commit", "post-checkout"]
compatibleWith: ["opencode", "claude-code"]
license: MIT
metadata:
  version: "2.0.0"
---

# Nix Flake Skill

This skill provides expertise in Nix flake development, including creating templates, managing dependencies, and ensuring reproducible builds.

## When to Use
- Creating new Nix flake projects
- Setting up development environments with `devShells`
- Managing flake inputs and outputs
- Creating and using flake templates
- Debugging flake evaluation errors
- Updating flake.lock files
- Integrating with direnv

## Core Concepts

### Flake Structure
```
flake.nix          # Main flake definition
flake.lock         # Locked dependencies (auto-generated)
templates/         # Project templates
devShells/         # Development shells
packages/          # Package definitions
checks/            # CI checks
```

### Standard Flake Template
```nix
{
  description = "Project description";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Add more inputs as needed
  };
  
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ /* dev tools */ ];
          shellHook = ''
            # Shell initialization
          '';
        };
        
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "my-project";
          src = pkgs.lib.cleanSource ./.;
          # Build configuration
        };
        
        checks = {
          # CI checks
        };
      });
}
```

## Commands

### `/nix-flake-init [template]`
Initialize a new flake project.
- `template`: Optional template name (rust, python, go, node, generic, ai)

### `/nix-flake-check`
Run all flake checks (format, build, tests).

### `/nix-flake-update [input]`
Update flake inputs and regenerate lock file.

### `/nix-flake-template list|show|create`
Manage flake templates.

## Direnv Integration

Add to `.envrc`:
```bash
use flake
# or for specific output
use flake .#devShells.default
```

Then run `direnv allow`.

## Best Practices

1. **Pin nixpkgs** - Use specific commits or channels
2. **Use flake-utils** - For cross-platform compatibility
3. **Clean sources** - Use `pkgs.lib.cleanSource` or `pkgs.lib.cleanSourceWith`
4. **Separate devShells** - Different shells for different purposes
5. **Lock file in git** - Commit flake.lock for reproducibility
6. **Use overlays** - For custom package modifications
7. **Document inputs** - Comment why each input is needed

## Common Patterns

### Python Project
```nix
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.poetry
    python3Packages.pytest
    python3Packages.ruff
    python3Packages.mypy
  ];
  shellHook = ''
    export PYTHONPATH="${PWD}:${PYTHONPATH}"
  '';
};
```

### Rust Project
```nix
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    bacon  # auto-rebuild
  ];
  RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
};
```

### AI Development Environment
```nix
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    python3
    python3Packages.pytorch
    python3Packages.tensorflow
    nodejs
    opencode
    direnv
    git
    rust-analyzer
    pyright
    nix
  ];
  shellHook = ''
    eval "$(direnv hook $SHELL)"
    echo "🚀 AI dev shell ready"
  '';
};
```

## Troubleshooting

### Flake Evaluation Error
```bash
nix flake check --show-trace
```

### Update Specific Input
```bash
nix flake lock --update-input nixpkgs
```

### Show Inputs
```bash
nix flake metadata --json
```

### Build Specific Output
```bash
nix build .#devShells.default
nix build .#packages.default
```

## Templates Available

Run `/nix-flake-template list` to see available templates:
- `generic` - Minimal flake
- `rust` - Rust project with cargo
- `python` - Python with poetry/pip
- `go` - Go modules
- `node` - Node.js with npm/yarn/pnpm
- `cpp` - CMake project
- `ai` - AI/ML development environment
- `nixos` - NixOS configuration
- `home-manager` - Home Manager config

## Architecture: Lifecycle Phases

Understanding the three evaluation phases is critical for debugging and designing flakes:

| Phase | Mechanism | What Happens |
|-------|-----------|--------------|
| **Build time** | `nix build .#output` | Derivations are realized, builds execute, outputs produced |
| **Symlink time** | `nix develop` / activation scripts | Store paths are symlinked into profile/env; shellHooks run |
| **Activation time** | `home-manager switch` / `nixos-rebuild switch` | System/user services start, config files written, daemons reload |

**Key insight**: Code in `let` bindings runs at evaluation time (before build). Code inside derivations (`mkDerivation`, `mkShell`) runs at build time. Activation scripts run on the target machine.

## Lib Functions: Pure vs Derivation Constructors

```
Pure functions (evaluation time):
  - pkgs.lib.strings.*
  - pkgs.lib.lists.*
  - pkgs.lib.attrsets.*
  - Custom functions in lib/ that don't return derivations

Derivation constructors (build time):
  - pkgs.stdenv.mkDerivation
  - pkgs.mkShell
  - pkgs.writeScriptBin
  - pkgs.writeTextFile
  - Any function that ultimately calls stdenv.mkDerivation
```

**Rule**: Never call derivation constructors in pure function context. Pass them as arguments to be invoked at the right time.

## Non-Obvious Facts (from Community Flakes)

1. **`getFlake` + `--impure` ignores uncommitted changes** — `nix flake metadata --json` sees only committed files. Use `--impure` to include working tree, but it breaks reproducibility.

2. **Patch indentation is exact** — When using `pkgs.lib.strings.makePatch` or inline patches, the indentation in the patch must match the target file exactly (including tabs vs spaces).

3. **Quoting `*` in Nix attribute names** — Use `{"*" = value;}` for wildcard/fallback attributes (e.g., in module option definitions).

4. **ES-module observe plugin** — For Node.js projects, the `observe` plugin (`@observablehq/stdlib`) requires ES modules. Ensure `package.json` has `"type": "module"` or use `.mjs`.

5. **Tarball-based pinning** — Some flakes (e.g., ECC) pin via tarball URL with hash instead of GitHub fetchers for faster evaluation: `fetchTarball { url = "..."; sha256 = "..."; }`.

## Module Options Tree (from ecc-opencode-flake)

```
opencode = {
  enable = true;
  package = pkgs.opencode;              # Override package
  extraPackages = [ ];                  # Extra pkgs in PATH
  enableMcpIntegration = false;         # Auto-import from programs.mcp
  settings = { };                       # Main opencode.json
  tui = { };                            # TUI settings (tui.json)
  web = { enable = false; ... };        # Web service
  context = "";                         # AGENTS.md content
  commands = { };                       # Custom commands
  agents = { };                         # Custom agents
  skills = { };                         # Custom skills
  themes = { };                         # Custom themes
  tools = { };                          # Custom tools
};
```

## Agent Model Routing

| Agent Type | Model Config | Fallback |
|------------|--------------|----------|
| **Reviewer** (code-review, security-audit) | `reasoningModel` | `reasoningModel` |
| **Builder** (feature, refactor, fix) | `codeModel` | `reasoningModel` |
| **Unknown/General** | `reasoningModel` | `reasoningModel` |

Configure in `settings`:
```nix
settings = {
  reasoningModel = "openrouter/anthropic/claude-3.5-sonnet";
  codeModel = "openrouter/anthropic/claude-3.5-haiku";
};
```

## Concrete Command Examples

```bash
# Format entire flake
nix fmt

# Full flake check (all systems)
nix flake check --all-systems

# Enter dev shell
nix develop

# Update specific input
nix flake lock --update-input nixpkgs

# Show eval trace for debugging
nix flake check --show-trace

# Build specific output
nix build .#devShells.x86_64-linux.default
nix build .#packages.x86_64-linux.my-app

# Show resolved inputs
nix flake metadata --json | jq '.locks.nodes'

# Check what would change without applying
nix flake update --dry-run
```

## Quick Reference Cheat Sheet

| Task | Command |
|------|---------|
| Initialize new flake | `nix flake init -t github:user/template#name` |
| Check format | `nix fmt` |
| Run all checks | `nix flake check` |
| Update all inputs | `nix flake update` |
| Update one input | `nix flake lock --update-input <name>` |
| Enter dev shell | `nix develop` |
| Enter specific shell | `nix develop .#shell-name` |
| Build package | `nix build .#package-name` |
| Show derivation info | `nix derivation show .#package-name` |
| GC roots cleanup | `nix store gc` |