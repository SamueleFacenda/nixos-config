{ pkgs, lib, ... }: {
  ai.plugins = {
    # Core productivity & safety
    ponytail = pkgs.fetchFromGitHub {
      repo = "ponytail";
      owner = "DietrichGebert";
      rev = "v4.8.4";
      hash = "sha256-1A9GkjCuiqwd6Wxl18CZUGYekxrbeTLVDapNUua8ihg=";
    };

    # Token optimization & context compression (verified hashes)
    token-optimizer = pkgs.fetchFromGitHub {
      repo = "token-optimizer";
      owner = "alexgreensh";
      rev = "v5.13.21";
      hash = "sha256-cbagJLiT9mwlZL2KWWc1mykK2hwCEbHwOFVUa463ILg=";
      postFetch = ''
        substituteInPlace "$out/hooks/python-launcher.sh" \
          --replace /opt/homebrew/opt /nix/store
      '';
    };

    headroom = pkgs.fetchFromGitHub {
      repo = "headroom";
      owner = "headroomlabs-ai";
      rev = "v0.38.0";
      hash = "sha256-k4xxC+tAiX+pjSj5nK1SBcpbIPQQLKbkQVn5wgzpywY=";
    };

    "opencode-dynamic-context-pruning" = pkgs.fetchFromGitHub {
      repo = "opencode-dynamic-context-pruning";
      owner = "Tarquinen";
      rev = "v3.2.0";
      hash = "sha256-5ewFGpWhvc5m4NVYBwG0s20m49u80Z7jBl0AGeg9uk0=";
    };

    "opencode-tokenscope" = pkgs.fetchFromGitHub {
      repo = "opencode-tokenscope";
      owner = "ramtinJ95";
      rev = "v1.8.1";
      hash = "sha256-+FIFp82UerRLyiyTOejaiwwRZSrSmOGb/WXkd3hPULo=";
    };

    "opencode-token-tracker" = pkgs.fetchFromGitHub {
      repo = "opencode-token-tracker";
      owner = "eserete";
      rev = "6a634805a65ae2b86f2dec9ec4d9905f113f0c03";
      hash = "sha256-NHKAmtJbriKxlpmNVGmYbmzCAejPaVTmeadIRQ5OFHs=";
    };

    "opencode-token-monitor" = pkgs.fetchFromGitHub {
      repo = "opencode-token-monitor";
      owner = "Ainsley0917";
      rev = "v0.5.0";
      hash = "sha256-gcg8yCu0ZfVHPzXq9t/lfAn7vO4QtzBxCDHIpx6xxGU=";
    };

    "opencode-context-analysis" = pkgs.fetchFromGitHub {
      repo = "Opencode-Context-Analysis-Plugin";
      owner = "IgorWarzocha";
      rev = "3676b9f213298780cfbc0b8c5dbbb33980308885";
      hash = "sha256-cbagJLiT9mwlZL2KWWc1mykK2hwCEbHwOFVUa463ILg=";
    };

    # Web research & navigation
    "opencode-crawlberg" = pkgs.fetchFromGitHub {
      repo = "opencode-crawlberg";
      owner = "nguyenthdat";
      rev = "907cb546fb5f83339c87ffb43b2be5e8d85c8f45";
      hash = "sha256-ZFR2dP0hahsuRrbPXCDBUHpDkpL+UfLH6yvDXK9axxk=";
    };

    "opencode-chromium" = pkgs.fetchFromGitHub {
      repo = "opencode-chromium";
      owner = "Quindart-com";
      rev = "v1.7.2";
      hash = "sha256-MluDtToGoxA+79iP+XqA8sLW8QgXFMfjfLaiv632hKI=";
    };

    # Web search with citations (antigravity-based)
    "opencode-websearch-cited" = pkgs.fetchFromGitHub {
      repo = "opencode-websearch-cited";
      owner = "ghoulr";
      rev = "v1.2.0";
      hash = "sha256-E83yoMRQjEdzTwrUQCl4GrN1Jw2k5FyMgKjoiDvBILc=";
    };

    # Skill retrieval & management
    "opencode-agent-skills" = pkgs.fetchFromGitHub {
      repo = "opencode-agent-skills";
      owner = "joshuadavidthomas";
      rev = "v0.7.0";
      hash = "sha256-TqkwWdTvD7HLYDKxJkTC39HjcZTi17ZPFO1OOVaqNuI=";
    };

    # Orchestration & workflow
    "oh-my-opencode-slim" = pkgs.fetchFromGitHub {
      repo = "oh-my-opencode-slim";
      owner = "alvinunreal";
      rev = "v2.2.22";
      hash = "sha256-YC1NdbSsxQmyV6zfstflVjrrQ8xz9UiWmQuUXPwnTjI=";
    };

    # Memory (also in mcp.nix as local derivation)
    # harness-memory = pkgs.fetchFromGitHub { ... };  // defined in mcp.nix with buildNpmPackage

    # Time tracking
    "opencode-wakatime" = pkgs.fetchFromGitHub {
      repo = "opencode-wakatime";
      owner = "angristan";
      rev = "v1.3.9";
      hash = "sha256-EZDLpq8Q2L6SE8Y7QgwlzCLnt0dS3e1B9ArBTWA5+Y8=";
    };

    # Toast history persistence
    "opencode-toast-history" = pkgs.fetchFromGitHub {
      repo = "opencode-toast-history";
      owner = "LouisLau-art";
      rev = "974e2347bb450bae957f5da3534883b70d2e5428";
      hash = "sha256-Ku/2cnNr5h9yIaCKnNvEubQVOFYsJbeuIItabYRbxtY=";
    };

    # Additional plugins (hashes pending - add when available):
    # "opencode-bytesbrains-cruise" = pkgs.fetchFromGitHub { ... }; // PR #741 - web search with citations
    # "opencode-mesh" = pkgs.fetchFromGitHub { ... }; // PR #740 - agent-to-agent messaging
    # "opencode-browser-output" = pkgs.fetchFromGitHub { ... }; // PR #738 - open response in browser
    # "opencode-dictate" = pkgs.fetchFromGitHub { ... }; // PR #735 - voice input/output
    # "opencode-material-theme" = pkgs.fetchFromGitHub { ... }; // PR #734 - Material Design 3 themes
    # "opencode-mlflow-plugin" = pkgs.fetchFromGitHub { ... }; // PR #729 - MLflow metrics logging
    # "opencode-mempalace-persistence" = pkgs.fetchFromGitHub { ... }; // PR #730 - MemPalace vector memory
    # "opencode-agent-memory" = pkgs.fetchFromGitHub { ... }; // persistent agent memory
    # "opencode-agent-registry" = pkgs.fetchFromGitHub { ... }; // community agent/skill discovery
    # "opencode-worktree-memory-sync" = pkgs.fetchFromGitHub { ... }; // sync memory across worktrees
    # "opencode-simple-notify" = pkgs.fetchFromGitHub { ... }; // desktop notifications
    # "opencode-ayu-theme" = pkgs.fetchFromGitHub { ... }; // Ayu Dark theme
    # "opencode-charcoal-theme" = pkgs.fetchFromGitHub { ... }; // Charcoal grayscale theme
  };
}