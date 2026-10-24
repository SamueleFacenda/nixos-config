{ pkgs, config, lib, ... }:

let
  raw = config.ai.plugins;

  # OpenCode v2 loads a local plugin directory through its root server.*
  # module; published plugins keep their entry deeper in dist/ or
  # .opencode/plugins/, so expose it through a generated server.js.
  reexportPlugin = name: entry:
    pkgs.runCommand "${name}-opencode-plugin" { } ''
      mkdir -p $out
      ln -s ${raw.${name}}/package.json $out/package.json
      printf '%s\n' 'export { default } from "${raw.${name}}/${entry}";' 'export * from "${raw.${name}}/${entry}";' > $out/server.js
    '';

  # v2 resolves runtime imports (peer SDK, zod) from the plugin directory, so
  # npm plugin tarballs need their production dependency tree installed next
  # to the shipped dist/. The vendored manifest+lock keep the offline install
  # deterministic; the tarball provides the compiled code. When serverJs is
  # given, the package entry is exposed through a generated root server.js
  # instead of the tarball's own entrypoint.
  npmPluginWithDeps = name: {
    src,
    vendorDir,
    npmDepsHash,
    serverJs ? (_: null),
  }:
    let
      deps = pkgs.fetchNpmDeps {
        src = vendorDir;
        hash = npmDepsHash;
      };
      withDeps = pkgs.stdenv.mkDerivation {
        name = "${name}-opencode-plugin";
        inherit src;
        dontConfigure = true;
        dontStrip = true;
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        # libstdc++ for prebuilt .node binaries inside npm deps
        buildInputs = [ pkgs.nodejs pkgs.libgcc pkgs.stdenv.cc.cc.lib ];
        buildPhase = ''
          runHook preBuild
          mkdir -p $TEMPDIR/deps
          cp -r ${vendorDir}/. $TEMPDIR/deps/
          export HOME=$TEMPDIR
          (
            cd $TEMPDIR/deps
            npm ci --offline --cache ${deps} --ignore-scripts --no-audit --no-fund
          )
          mv $TEMPDIR/deps/node_modules ./node_modules
          runHook postBuild
        '';
        installPhase = ''
          cp -r . $out
        '';
      };
      entry = serverJs withDeps;
    in
    if entry == null then withDeps
    else pkgs.runCommand "${name}-opencode-plugin" { } ''
      mkdir -p $out
      ln -s ${withDeps}/package.json $out/package.json
      printf '%s\n' '${entry}' > $out/server.js
    '';
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    # Scratch directory for temporary work (like claude-code's scratch);
    # crawlberg is the CLI the crawlberg plugin spawns from PATH
    extraPackages = [
      config.ai.plugins.headroom
      config.ai.plugins.crawlberg
      pkgs.coreutils
    ];

    # Use centralized LSP from ai.lsp (MCP comes from programs.mcp via enableMcpIntegration)
    settings.lsp = config.ai.lsp;

    skills = config.ai.skills;
    agents = config.ai.agents;
    commands = config.ai.commands;

    settings = {
      # v2-native plugins key; every entry is a directory with a root
      # server.* entrypoint that v2's local plugin loader can resolve
      plugins = [
        (reexportPlugin "ponytail" ".opencode/plugins/ponytail.mjs")
        (reexportPlugin "token-optimizer-opencode" "dist/plugin.js")
        (reexportPlugin "opencode-crawlberg" ".opencode/plugins/crawlberg.js")
        (reexportPlugin "opencode-wakatime" "dist/server.js")
        # ships its own root server.js; only the dependency tree was missing
        (npmPluginWithDeps "opencode-dynamic-context-pruning" {
          src = raw."opencode-dynamic-context-pruning";
          vendorDir = ./vendor/dcp-3.2.0;
          npmDepsHash = "sha256-3NTOCCIWo+YX/ZtcTPp5BCwavhFfh2mqzcZcT4Tzbts=";
        })
        # package default export is V1-shaped; expose the V2 plugin object
        (npmPluginWithDeps "opencode-chromium" {
          src = raw."opencode-chromium";
          vendorDir = ./vendor/opencode-chromium-1.9.3;
          npmDepsHash = "sha256-UdRmYrhPirI60bECLNuItiLmeH9KVfbFbiR5gUWUqr4=";
          serverJs = withDeps: ''
            import { opencodeV2Plugin } from "${withDeps}/dist/adapters/opencode/index.js";
            export default { id: opencodeV2Plugin.id, setup: opencodeV2Plugin.setup };
          '';
        })
      ];

      tools = {
        webfetch = false;
        websearch = false;
      };

      # Per-agent model configuration with fallbacks (first available wins)
      agent = {
        # Primary agents - same model chain for build & plan
        build = {
          model = "nvidia/z-ai/glm-5.3"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
          # Allow all subagents; explore/scout are preferred for read-only tasks
          permission = {
            task = {
              "*" = "allow";
            };
          };
        };
        plan = {
          model = "nvidia/z-ai/glm-5.3"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
          # Allow subagents for analysis/planning tasks
          permission = {
            task = {
              "*" = "allow";
            };
          };
        };
        compaction = {
          model = "nvidia/z-ai/glm-5.3";
        };
        title = {
          model = "nvidia/z-ai/glm-5.3";
        };
        summary = {
          model = "nvidia/z-ai/glm-5.3";
        };

        # Subagents - enable them and configure models
        general = {
          model = "nvidia/z-ai/glm-5.3"; # [
          # "openrouter/google/gemini-2.5-flash"
          # "openrouter/openai/gpt-5"
          # "nvidia/nvidia/nemotron-3-ultra-550b-a55b"
          # ];
        };
        explore = {
          model = "nvidia/nvidia/nemotron-3.5-super-vl-120b-a12b"; # [
          # "openrouter/deepseek/deepseek-chat-v3-0324:free"
          # "nvidia/nvidia/nemotron-3-super-120b-a12b"
          # ];
          # Read-only: prevent sub-subagents
          permission = {
            task = {
              "*" = "deny";
            };
          };
        };
        scout = {
          model = "nvidia/nvidia/nemotron-3.5-super-vl-120b-a12b"; # [
          # "openrouter/deepseek/deepseek-chat-v3-0324:free"
          # "nvidia/nvidia/nemotron-3-super-120b-a12b"
          # ];
          # Read-only: prevent sub-subagents
          permission = {
            task = {
              "*" = "deny";
            };
          };
        };
      };

      # Explicitly allow /tmp/opencode/* (pre-approved by default, but explicit for clarity)
      permission.external_directory = {
        "/tmp/opencode/**" = "allow";
        "/tmp/opencode-*/**" = "allow";  # covers per-session variant if TMPDIR customized
      };

      # Coding rules consumed directly from the rules option (store path, rebuilt on change)
      instructions = [
        (pkgs.writeText "coding-rules.md" config.ai.rules.codingRulesMarkdown)
      ];
    };
  };
}
