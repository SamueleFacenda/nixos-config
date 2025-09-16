{ config, pkgs, self, ... }: {
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
  home.packages = with pkgs; [
    ((jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
      "github-copilot"
      "python"
      "ide-features-trainer"
      "ideavim"
      "which-key"
      "better-direnv"
      "nixidea"
      # "wakatime"
    ]).overrideAttrs {
      # copying intellij back and forth from the build server is useless and slow
      preferLocalBuild = true;
    })
    ((jetbrains.plugins.addPlugins jetbrains.clion [
      "github-copilot"
      "nixidea"
      "protocol-buffers"
      "better-direnv"
      # "wakatime"
    ]).overrideAttrs { preferLocalBuild = true; })
    ((jetbrains.plugins.addPlugins jetbrains.rust-rover [
      "ide-features-trainer"
      "github-copilot"
      "nixidea"
      # "wakatime"
      "better-direnv"
    ]).overrideAttrs { preferLocalBuild = true; })
  ];
}
