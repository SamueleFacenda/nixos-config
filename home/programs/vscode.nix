{ config, pkgs, self, ... }:
let
  mkOpenVSXExt = { publisher, name, version, sha256 }: {
    inherit name publisher version;
    vsix = builtins.fetchurl {
      inherit sha256;
      url = "https://open-vsx.org/api/${publisher}/${name}/${version}/file/${publisher}.${name}-${version}.vsix";
      name = "${publisher}-${name}.zip";
    };
  };
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; # or vscodium
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # github.copilot
      # wakatime.vscode-wakatime
      yzhang.markdown-all-in-one
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode.live-server
      ms-vscode-remote.remote-ssh
      vscode-icons-team.vscode-icons
      formulahendry.auto-rename-tag
      jnoortheen.nix-ide
      editorconfig.editorconfig
      ms-vscode.cpptools
      azdavis.millet
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      # ms-vscode.cmake-tools
      twxs.cmake
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.178.811"; # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
        sha256 = "JkJWFbnUSyGOz6yduq5jxxcwveEXA1gvPNu8bBTBly4=";
      }
      {
        name = "vscode-ros";
        publisher = "ms-iot";
        version = "0.9.6";
        sha256 = "ZsGBzfLzRFzSWx4vttfXPb6gSrFBy+QUDz9hkAdKMCw=";
      }
      {
        name = "vscode-wakatime";
        publisher = "WakaTime";
        version = "24.5.0";
        sha256 = "HRFonjVM3mGulfSL5w7biLx84MuQ9AaLr5dC5DHjC2s=";
      }
      # (mkOpenVSXExt {
      #   name = "open-remote-ssh";
      #   publisher = "jeanp413";
      #   version = "0.0.45";
      #   sha256 = "1qc1qsahfx1nvznq4adplx63w5d94xhafngv76vnqjjbzhv991v2";
      # })
    ];

    userSettings = {
      "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "'JetbrainsMono Nerd Font Mono'";
      "[nix]"."editor.tabSize" = 2;
      "files.autoSave" = "onFocusChange";
      "workbench.iconTheme" = "vscode-icons";
      "vsicons.dontShowNewVersionMessage" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings".nixd = {
        formatting.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        eval.target.installable = "${self.outPath}#nixosConfigurations.surface.config.system.build.toplevel";
        options = {
          enable = true;
          target = {
            installable = "${self.outPath}#nixosConfigurations.surface.options";
            #installable = "${self.outPath}#homeConfigurations.samu.options";
          };
        };
      };
      "C_Cpp.default.compilerPath" = "${pkgs.gnat}/bin/g++";
      "C_Cpp.codeAnalysis.runAutomatically" = true;
      "C_Cpp.codeAnalysis.clangTidy.enabled" = true;
      "C_Cpp.intelliSenseUpdateDelay" = 500;
      "C_Cpp.intelliSenseCacheSize" = 100;
      "python.analysis.typeCheckingMode" = "basic";
      "python.analysis.autoFormatStrings" = true;
      "python.analysis.autoImportCompletions" = true;
      "python.analysis.callArgumentNames" = true;

      "github.copilot.enable" = {
        "*" = true;
        plaintext = false;
        markdown = false;
        scminput = false;
      };
    };
  };
}
