{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    jetbrains-toolbox
    (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/plugins/plugins.json
      "github-copilot"
      "python"
      "ide-features-trainer"
      "ideavim"
      "nixidea"
    ])
  ];

  xdg.desktopEntries = {
    intellij-nix-shell = {
      name = "Intellij with nix-shell";
      genericName = "IntelliJ IDEA – the Leading Java and Kotlin IDE";
      comment = "The IDE that makes development a more productive and enjoyable experience";
      icon = "${pkgs.jetbrains.idea-ultimate}/share/pixmaps/idea-ultimate.svg";
      exec = "nix develop \"${self.outPath}#java\" --command idea-ultimate";
      terminal = false;
      categories = [ "Development" ];
    };
  };
}
