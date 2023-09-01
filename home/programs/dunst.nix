{config, pkgs, ...}:{

  services.dunst = {
    enable = true;
    iconTheme = { 
      name = "Adwaita";
      size = "32x32";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    settings = {
      
    };
  };
}
