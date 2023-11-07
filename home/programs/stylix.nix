{config, pkgs, ...}:

{
  stylix.targets = {
    gnome.enable = false;
    kitty.enable = false;
    waybar.enable = false;
    vscode.enable = false;

  };

  stylix.cursor = {
    name = "Adwaita";
    size = 24;
    package = pkgs.gnome.adwaita-icon-theme;
  };
}
