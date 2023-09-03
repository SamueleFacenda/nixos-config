{config, pkgs, lib, ...}:{
  
  # make dunst start only with hyprland
  systemd.user.services.dunst.Unit.PartOf = lib.mkForce ["hyprland-session.target"];
  systemd.user.services.dunst.Unit.After = lib.mkForce ["hyprland-session.target"];

  services.dunst = {
    enable = true;
    iconTheme = { 
      name = "Adwaita";
      size = "32x32";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    settings = {
      global = {
        monitor = 1;
      };
    };
  };
}
