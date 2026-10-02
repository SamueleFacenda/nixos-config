{ lib, ... }:

let
  # Coding rules as Markdown string for both agents
  codingRulesMarkdown = ''
    # AI Coding Rules & Guidelines

    These rules apply to all AI agents (opencode, claude-code) working in this codebase.

    ---

    ## Comments

    **Style:** Minimal - only WHY/ALGORITHM/TODO/FIXME/HACK/NOTE/LEGAL

    **Allowed tags:** `why`, `algorithm`, `todo`, `fixme`, `hack`, `note`, `legal`, `license`

    **Forbidden:** `what`, `how`, `obvious`, `redundant`, `mumbling`, `noise`

    **Rules:**
    - No diff-anchored comments (references to past state/git history)
    - No past tense in comments
    - No git references in comments

    ---

    ## Documentation

    **Style:** Current state only, no diff-anchored writing

    **Structure:**
    1. Purpose
    2. Interface
    3. Behavior
    4. Configuration
    5. Dependencies
    6. Examples

    **Rules:**
    - No diff-anchored writing
    - No past tense
    - No git references

    ---

    ## Clean Code Principles (Uncle Bob)

    **Enabled:** Yes

    **Principles:** SRP, OCP, LSP, ISP, DIP, DRY, KISS, YAGNI, TDD

    **Metrics:**
    - Max function lines: 20
    - Max function arguments: 3
    - Max class lines: 100
    - Max nesting depth: 4
    - Max cognitive complexity: 15

    ---

    ## Naming Conventions

    - Descriptive names required
    - No abbreviations (except domain-standard: id, url, api, db)
    - No encoding (no str_name, i_count, _private)

    **By Language:**

    | Language | Classes/Structs | Functions | Constants | Variables |
    |----------|----------------|-----------|-----------|-----------|
    | Python | PascalCase | snake_case | UPPER_SNAKE_CASE | snake_case |
    | Rust | PascalCase | snake_case | UPPER_SNAKE_CASE | snake_case |
    | TypeScript | PascalCase (interfaces) | camelCase | UPPER_SNAKE_CASE | camelCase |
    | Nix | - | camelCase | - | kebab-case |

    ---

    ## Function Rules

    - Small functions (≤ 20 lines, ideally ≤ 10)
    - Do one thing well
    - One level of abstraction
    - Descriptive names
    - Few arguments (0 ideal, 1-2 ok, 3+ needs justification)
    - No side effects (pure functions preferred)
    - No output arguments (return values instead)

    ---

    ## Error Handling

    - Exceptions over error codes
    - Fail fast
    - Context in errors
    - No empty catch blocks
    - Custom exceptions preferred

    ---

    ## Testing

    **Required:** Yes
    **TDD Preferred:** Yes
    **Coverage Threshold:** 80%
    **Fast Unit Tests:** Yes
    **Deterministic:** Yes
    **Descriptive Names:** Yes

    ---

    ## Formatting (Enforced by Tools)

    | Language | Tool |
    |----------|------|
    | Nix | nix fmt |
    | Python | ruff format |
    | Rust | rustfmt |
    | TypeScript | prettier |
    | Go | gofmt |
    | C++ | clang-format |
    | Lua | stylua |
    | Markdown | prettier |
    | YAML | prettier |
    | JSON | prettier |
    | TOML | taplo format |

    ---

    ## Git Workflow

    **Enabled:** Yes
    - Branch strategy: feature branches
    - Commit message format: conventional commits
    - Atomic commits
    - Signed commits
    - Require tests, lint, format before merge
    - No direct push to main
    - PR required

    ---

    ## Changelog

    **Enabled:** Yes
    **Format:** keepachangelog (https://keepachangelog.com/en/1.1.0/)
    **Path:** CHANGELOG.md
    **Minimal Descriptions:** Yes

    ---

    ## Security

    **Enabled:** Yes
    - No secrets in code
    - Parameterized queries
    - Input validation
    - Dependency scanning
    - Secret scanning
    - Tools: semgrep, bandit, trivy, git-secrets
    - Run on change

    ---

    ## Nix Flake Template Usage

    **Enabled:** Yes
    **Template:** samu#ai
    **Direnv Integration:** Yes
    **Use Flake:** Yes
    **Trim Stack:** Yes
    **Update Lock File:** Yes

    ---

    ## Subagent Delegation Rules

    - ALWAYS launch the `@explore` subagent to perform codebase searching, file locating, or symbol references before planning or editing code.
    - ALWAYS use `@scout` for external research: dependency or library documentation, API behavior, version details, pricing, current events.
    - `@scout` MUST ground every answer in web search results and cite source URLs, never answer from memory.
    - Do not perform codebase-wide `grep` or file reads directly in the main session when `@explore` can do it in a background child session.
    - Run multiple `@explore` subagents in parallel for independent search paths.
    - Use `@general` to parallelize the plan implementation and the execution of different tasks.

    ## Temporary Directory Usage

    - Use `''${tmp}` (resolves to `/tmp/opencode/`) for temporary work outside the workspace — this directory is pre-approved for external directory access and created automatically on startup.
    - Create per-task subdirectories under `''${tmp}` as needed (e.g., `''${tmp}/task-<name>/`).
    - Experiment freely in `''${tmp}` — write test scripts, prototype changes, run quick validations. It's faster than guessing and avoids polluting the workspace.

    ## Agent Behavior Rules

    - Never add what/how comments
    - Never write diff-anchored docs
    - Never reference git history
    - Follow clean code principles
    - Write tests first (TDD)
    - Run formatters and linters
    - Use conventional commits
    - Update changelog on merge
    - Run security scans
    - Prefer stdlib over dependencies
    - Verify external facts online before asserting them

    ## Web Research & Verification

    **Policy:** Verify before assert.

    - Any claim about external systems — library APIs, versions, config syntax, CLI flags, pricing, current events, third-party error causes — must be grounded in a web search or a fetched document before being asserted.
    - Never state version numbers, API signatures, or CLI flags from memory alone.
    - Use the `websearch`/`webfetch` tools, the donsetch MCP tools (`web_search`, `web_fetch`, `web_crawl`), or delegate to `@scout`.
    - Prefer primary sources (official docs, source repos) over blog posts for technical facts.
    - Cite the source URL next to verified claims.
    - If search tools fail or are unavailable, label the claim "unverified" instead of guessing.

    ## Enforcement

    - STRICTLY follow these coding rules. No exceptions. Enforce on every task.
    - Before starting any task, consult <available_skills> and load matching skills via the `skill` tool.
  '';

in {
  config = {
    ai.rules = {
      codingRulesMarkdown = codingRulesMarkdown;
      # Comments: minimal, only WHY/ALGORITHM/TODO/FIXME/HACK/NOTE/LEGAL
      comments = {
        style = "minimal";
        allowed = [ "why" "algorithm" "todo" "fixme" "hack" "note" "legal" "license" ];
        forbidden = [ "what" "how" "obvious" "redundant" "mumbling" "noise" ];
        forbidDiffAnchored = true;
        forbidPastTense = true;
        forbidGitReferences = true;
      };

      # Documentation: current state only, no diff-anchored writing
      documentation = {
        style = "current-state";
        forbidDiffAnchored = true;
        forbidPastTense = true;
        forbidGitReferences = true;
        structure = [
          "Purpose"
          "Interface"
          "Behavior"
          "Configuration"
          "Dependencies"
          "Examples"
        ];
      };

      # Clean Code principles (Uncle Bob)
      cleanCode = {
        enabled = true;
        principles = [ "SRP" "OCP" "LSP" "ISP" "DIP" "DRY" "KISS" "YAGNI" "TDD" ];
        maxFunctionLines = 20;
        maxFunctionArgs = 3;
        maxClassLines = 100;
        maxNestingDepth = 4;
        maxCognitiveComplexity = 15;
      };

      # Naming conventions
      naming = {
        descriptive = true;
        noAbbreviations = true;
        noEncoding = true;
        byLanguage = {
          python = {
            classes = "PascalCase";
            functions = "snake_case";
            constants = "UPPER_SNAKE_CASE";
            variables = "snake_case";
          };
          rust = {
            structs = "PascalCase";
            functions = "snake_case";
            constants = "UPPER_SNAKE_CASE";
            variables = "snake_case";
          };
          typescript = {
            interfaces = "PascalCase";
            functions = "camelCase";
            constants = "UPPER_SNAKE_CASE";
            variables = "camelCase";
          };
          nix = {
            variables = "kebab-case";
            attributes = "kebab-case";
            functions = "camelCase";
          };
        };
      };

      # Function rules
      functions = {
        small = true;
        oneThing = true;
        oneAbstraction = true;
        descriptiveNames = true;
        fewArguments = true;
        noSideEffects = true;
        noOutputArgs = true;
      };

      # Error handling
      errorHandling = {
        exceptionsOverCodes = true;
        failFast = true;
        contextInErrors = true;
        noEmptyCatch = true;
        customExceptions = true;
      };

      # Testing (enforced)
      testing = {
        required = true;
        tddPreferred = true;
        coverageThreshold = 80;
        fastUnitTests = true;
        deterministic = true;
        descriptiveNames = true;
      };

      # Formatting (enforced by tools)
      formatting = {
        enabled = true;
        tools = {
          nix = "nix fmt";
          python = "ruff format";
          rust = "rustfmt";
          typescript = "prettier";
          go = "gofmt";
          cpp = "clang-format";
          lua = "stylua";
          markdown = "prettier";
          yaml = "prettier";
          json = "prettier";
          toml = "taplo format";
        };
      };

      # Git workflow (enforced)
      gitWorkflow = {
        enabled = true;
        branchStrategy = "feature";
        commitMessageFormat = "conventional";
        atomicCommits = true;
        signedCommits = true;
        requireTests = true;
        requireLint = true;
        requireFormat = true;
        noDirectPushToMain = true;
        prRequired = true;
      };

      # Changelog
      changelog = {
        enabled = true;
        format = "keepachangelog";
        path = "CHANGELOG.md";
        minimalDescriptions = true;
      };

      # Security (enforced)
      security = {
        enabled = true;
        noSecretsInCode = true;
        parameterizedQueries = true;
        inputValidation = true;
        dependencyScanning = true;
        secretScanning = true;
        tools = [ "semgrep" "bandit" "trivy" "git-secrets" ];
        runOnChange = true;
      };

      # Nix flake template usage
      nixFlake = {
        enabled = true;
        template = "samu#ai";
        direnvIntegration = true;
        useFlake = true;
        trimStack = true;
        updateLockFile = true;
      };

      # Agent behavior rules (for opencode and claude-code)
      agentBehavior = {
        neverAddWhatHowComments = true;
        neverWriteDiffAnchoredDocs = true;
        neverReferenceGitHistory = true;
        followCleanCode = true;
        writeTestsFirst = true;
        runFormattersLinters = true;
        useConventionalCommits = true;
        updateChangelogOnMerge = true;
        runSecurityScans = true;
        preferStdlibOverDeps = true;
        verifyExternalFactsOnline = true;
      };

      # Web research & verification (anti-hallucination)
      webResearch = {
        verifyBeforeAssert = true;
        noVersionsOrSignaturesFromMemory = true;
        tools = [ "websearch" "webfetch" "mcp:donsetch" ];
        designatedResearcher = "scout";
        citeSourceUrls = true;
        labelUnverifiedOnFailure = true;
      };
    };
  };
}
