{
  "$mod" = "SUPER";


  bind = [
    "$mod, Q, exec, kitty"
    "$mod, C, killactive,"
    "$mod, M, exit,"
    "$mod, right, movetoworkspace, +1"
    "$mod, left, movetoworkspace, -1"
    ",mouse_left, workspace, r-1"
    ",mouse_right, workspace, r+1"
  ];

  bindr = [
    ",$mod, exec, rofi -show drun"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  bindl = [
    # Lid switch settings
    #",switch:Lid Switch,exec,swaylock"

    ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,2736x1824,1440x1050,2\""
    #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3,1680x1050,1440x0,1\""
    #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4,1440x900,0x0,1\""

    ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
    #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-3, disable\""
    #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-4, disable\""
  ];

  bindle = [
    # volume keys
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  ];
}
