{ config, pkgs, lib, ...}: rec {

  dconf.settings."org/gnome/desktop/interface".cursor-theme = "Adwaita";
  dconf.settings."org/gnome/desktop/interface".cursor-size = 24;

  gtk.cursorTheme = home.pointerCursor;

  home.pointerCursor = {
    package = lib.mkDefault  pkgs.gnome.adwaita-icon-theme;
    name = lib.mkDefault "Adwaita";
    size = lib.mkDefault 24;
  };
}
