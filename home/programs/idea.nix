{ config, pkgs, nix-jetbrains-plugins,  ... }: 
let 
  withPlugins = nix-jetbrains-plugins.lib."${pkgs.stdenv.hostPlatform.system}".buildIdeWithPlugins pkgs.jetbrains;
in
{
  home.packages = [
    ((withPlugins "idea" [
      "com.github.copilot"
      "PythonCore"
      "training"
      "IdeaVIM"
      "eu.theblob42.idea.whichkey"
      "com.fapiko.jetbrains.plugins.better_direnv"
      "nix-idea"
      "com.wakatime.intellij.plugin"
    ]))
    ((withPlugins "clion" [
      "com.github.copilot"
      "nix-idea"
      "idea.plugin.protoeditor"
      "com.fapiko.jetbrains.plugins.better_direnv"
      "com.wakatime.intellij.plugin"
    ]).overrideAttrs { preferLocalBuild = true; })
    ((withPlugins "rust-rover" [
      "com.github.copilot"
      "nix-idea"
      "training"
      "com.wakatime.intellij.plugin"
      "com.fapiko.jetbrains.plugins.better_direnv"
    ]).overrideAttrs { preferLocalBuild = true; })
  ];
  
  xdg.configFile."gdb/gdbinit".text = ''
    set auto-load local-gdbinit on
    add-auto-load-safe-path /
  '';
}
