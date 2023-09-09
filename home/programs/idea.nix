{config, pkgs, ...}:{
  home.packages = with pkgs; [
    
    jetbrains-toolbox
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      "github-copilot"
      "python"
      "ide-features-trainer"
      "ideavim"
    ])
  ]  ;
}
