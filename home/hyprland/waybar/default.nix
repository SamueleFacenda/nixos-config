{config, pkgs, ...}:{

  imports = [
    ./settings.nix
    ./style.nix
  ];
  
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
}
