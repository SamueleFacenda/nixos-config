{config, pkgs, ...}:{

  imports = [
    ./dunst.nix
    ./waybar
    ./rofi
  ];

  home.packages = with pkgs; [
  	gtk3
  	swayidle
  	swaylock-effects
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      
    ];
    settings =
      import ./bindings.nix //
      import ./settings.nix // {

      exec-once = [
        "/home/samu/.scripts/waybar.sh" # waybar auto-reload
        "brave"
        "kitty"
        "/home/samu/.scripts/sleep.sh" # auto suspend
        #"dunst"
      ];
    };
    
  };
}
