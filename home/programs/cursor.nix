{ config, pkgs, ...}:{

  dconf.settings."org/gnome/desktop/interface".cursor-theme = "Adwaita";
  dconf.settings."org/gnome/desktop/interface".cursor-size = 24;

  gtk.cursorTheme = {
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
  };

  home.pointerCursor = {
    package =  pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
}
