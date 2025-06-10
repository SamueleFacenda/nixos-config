{ config, pkgs, self, ... }: {

  home.packages = with pkgs; [
    ((jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      # "github-copilot-fixed"
      jetbrains.plugins.github-copilot-fixed
      "python"
      "ide-features-trainer"
      "ideavim"
      "nixidea"
      # "wakatime"
    ]).overrideAttrs {
      # copying intellij back and forth from the build server is useless and slow
      preferLocalBuild = true;
    })
    ((jetbrains.plugins.addPlugins jetbrains.clion [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      # "github-copilot-fixed"
      jetbrains.plugins.github-copilot-fixed
      "nixidea"
      "protocol-buffers"
      # "wakatime"
    ]).overrideAttrs {
      # copying intellij back and forth from the build server is useless and slow
      preferLocalBuild = true;
    })
  ];
}
