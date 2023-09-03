{config, pkgs, lib, ...}:{
  
  systemd.user.services.duns.Unit.PartOf = lib.mkForce ["hyprland-session.target"];
  systemd.user.services.duns.Unit.After = lib.mkForce ["hyprland-session.target"];

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
