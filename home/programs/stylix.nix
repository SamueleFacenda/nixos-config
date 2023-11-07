{config, pkgs, ...}:

{
  stylix = {
    targets = {
      gnome.enable = false;
      kitty.enable = false;
      waybar.enable = false;
      vscode.enable = false;

    };

    cursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.gnome.adwaita-icon-theme;
    };

    fonts = let
      nf = pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" "JetBrainsMono" "Monofur" "IBMPlexMono" ]; };
    in {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = nf;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 15;
      };
    };
  };
}
