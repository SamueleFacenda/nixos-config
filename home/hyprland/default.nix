{config, pkgs, ...}:{

  imports = [
    ./dunst.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
  	gtk3
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      
    ];
    settings =
      import ./bindings.nix //
      import ./settings.nix // {

      exec-once = [
        "waybar"
        "brave"
        "kitty"
        #"dunst"
      ];
    };
    
  };
}
