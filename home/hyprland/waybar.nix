{config, pkgs, ...}:{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      output = ["DP-3"];
    };
    systemd.enable = false;
  };
}
