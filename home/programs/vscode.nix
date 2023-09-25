{ config, pkgs, ... }: {
  programs.vscode = {

    enable = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps;[
      # extension specific dependencies
    ]);
    extensions = with pkgs.vscode-extensions; [
      # github.copilot
      wakatime.vscode-wakatime
      yzhang.markdown-all-in-one
      # ms-python.python
      ms-vscode.live-server
      ms-vscode-remote.remote-ssh
      vscode-icons-team.vscode-icons
      formulahendry.auto-rename-tag
      jnoortheen.nix-ide
      editorconfig.editorconfig
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.105.354"; # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
        sha256 = "sha256-QuZ2Dhy8K2o/9vH+ejvY6ICG8bpzAIa9uq9xvabav/Q="; # pkgs.lib.fakeSha256;
      }
    ];


    userSettings = {
      "editor.fontFamily" = "'Jetbrains Mono Nerd Fonts'";
      "editor.fontLigatures" = true;
      "[nix]"."editor.tabSize" = 2;
      "files.autoSave" = "onFocusChange";
      "workbench.iconTheme" = "vscode-icons";
      "vsicons.dontShowNewVersionMessage" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings".nixd = {
        formatting.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        options = {
          enable = true;
          target = {
            installable = "<flakeref>#nixosConfigurations.<name>.options";
          };
        };
      };
    };
  };
}
