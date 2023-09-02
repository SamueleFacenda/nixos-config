{config, pkgs, ...}:{
  programs.waybar = {
    enable = true;
    settings = {
      
    };
    systemd.enable = false;
  };
}
