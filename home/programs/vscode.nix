{ config, pkgs, self, ... }: {
  programs.vscode = {

    enable = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps;[
      curl
    ]);
    extensions = with pkgs.vscode-extensions; [
      # github.copilot
      wakatime.vscode-wakatime
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
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.105.354"; # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
        sha256 = "sha256-QuZ2Dhy8K2o/9vH+ejvY6ICG8bpzAIa9uq9xvabav/Q="; # pkgs.lib.fakeSha256;
      }
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
