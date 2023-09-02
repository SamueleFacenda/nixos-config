{config, pkgs, ...}:{

  home.packages = [
  	pkgs.dunst
  ];

  services.dunst = {
    enable = false;
    iconTheme = { 
      name = "Adwaita";
      size = "32x32";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    settings = {
      
    };
  };
}
