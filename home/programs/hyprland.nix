{config, pkgs, ...}:{

  imports = [
    ./dunst.nix
  ];

  home.packages = with pkgs; [
  	xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      
    ];
    settings = {
      
    };
  };
}
