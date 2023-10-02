{
  "$mod" = "SUPER";


  bind = [
    "$mod, Q, exec, kitty"
    "$mod, C, killactive,"
    "$mod, F, togglefloating,"
    "$mod, M, exit,"
    "$mod, B, exec, hyprctl dispatch dpms off"
    "$mod, right, movetoworkspace, +1"
    "$mod, left, movetoworkspace, -1"
    ",mouse_left, workspace, r-1"
    ",mouse_right, workspace, r+1"
  ];

  bindr = [
    "$mod,super_l, exec, wofi --show drun"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  bindl = [
    # Lid switch settings
    #",switch:Lid Switch,exec,swaylock"

    ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,2736x1824,1440x1050,2\""
    #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3,1680x1050,1440x0,1\""
    #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4,1440x900,0x0,1\""

    ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
    #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-3, disable\""
    #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-4, disable\""
  ];

  bindle = [
    # volume keys, max is configured in default.nix
    ", XF86AudioRaiseVolume, exec, swayosd --output-volume +5"
    ", XF86AudioLowerVolume, exec, swayosd --output-volume -5"
    ", XF86AudioMute, exec, swayosd --output-volume mute-toggle"
  ];
}
