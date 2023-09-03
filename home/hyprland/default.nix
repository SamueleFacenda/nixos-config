{config, pkgs, ...}:{

  imports = [
    ./dunst.nix
    ./waybar.nix
    ./rofi.nix
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
        "/home/samu/.script/waybar.sh" # auto-reload
        "brave"
        "kitty"
        #"dunst"
      ];
    };
    
  };
}
