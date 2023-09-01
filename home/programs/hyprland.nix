{config, pkgs, ...}:{

  imports = [
    ./dunst.nix
  ];

  home.packages = with pkgs; [
  	gtk3
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      
    ];
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod,Q,exec,kitty"
      ];
    };
  };
}
