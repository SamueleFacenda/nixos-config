{ config, pkgs, self, ... }: {

  home.packages = with pkgs; [
    ((jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      "github-copilot"
      "python"
      "ide-features-trainer"
      "ideavim"
      "nixidea"
    ]).overrideAttrs {
      # copying intellij back and forth from the build server is useless and slow
      preferLocalBuild = true;
    })
    ((jetbrains.plugins.addPlugins jetbrains.clion [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      "github-copilot"
      "nixidea"
    ]).overrideAttrs {
      # copying intellij back and forth from the build server is useless and slow
      preferLocalBuild = true;
    })
  ];
}
