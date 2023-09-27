{ config, pkgs, ...}: rec {

  dconf.settings."org/gnome/desktop/interface".cursor-theme = "Adwaita";
  dconf.settings."org/gnome/desktop/interface".cursor-size = 24;

  gtk.cursorTheme = home.pointerCursor;

  home.pointerCursor = {
    package =  pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
}
