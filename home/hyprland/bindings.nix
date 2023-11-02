{config, pkgs, ...} :
let
  usr_bin_dir = "/home/samu/.local/bin/";
in
{
  wayland.windowManager.hyprland.settings =  let
    keyboard = "wvkbd-mobintl";
    flags = "--landscape-layers simple,special,emoji -L 200 ";
    in {

    "$mod" = "SUPER";

    bind = [
      "$mod, Q, exec, kitty"
      "$mod, C, killactive,"
      "$mod, F, togglefloating,"
      "$mod, M, exit,"
      "$mod, B, exec, hyprctl dispatch dpms off"
      "$mod, right, movetoworkspace, +1"
      "$mod, left, movetoworkspace, -1"
      "$mod, space, exec, echo keyboard_change" # keyboard change, configured in settings

      # Windows bindings (they are recorded on the mouse)
      "CTRL_SUPER, left, workspace, r-1"
      "CTRL_SUPER, right, workspace, r+1"

      ", edge:r:l, workspace, +1"
      ", edge:l:r, workspace, -1"
      ", edge:d:u, exec, if ps -e | grep ${keyboard}; then pkill ${keyboard}; else ${keyboard} ${flags}; fi"
    ];

    bindr = [
      "$mod,super_l, exec, ${usr_bin_dir}wofi-toggle"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bindl = [
      # Lid switch settings
      #",switch:Lid Switch,exec,swaylock"

      # ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,2736x1824,1440x1050,2\""
      ",switch:off:Lid Switch,exec, ${usr_bin_dir}wake"
      #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3,1680x1050,1440x0,1\""
      #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4,1440x900,0x0,1\""

      ",switch:on:Lid Switch,exec, ${usr_bin_dir}suspend"
      #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-3, disable\""
      #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-4, disable\""
    ];

    bindle = [
      # volume keys, max is configured in default.nix
      ", XF86AudioRaiseVolume, exec, swayosd --output-volume +5"
      ", XF86AudioLowerVolume, exec, swayosd --output-volume -5"
      ", XF86AudioMute, exec, swayosd --output-volume mute-toggle"
      ", XF86MonBrightnessUp, exec, swayosd --brightness raise 200"
      ", XF86MonBrightnessDown, exec, swayosd --brightness lower 200"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioStop, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
      ", print, exec, grim -g \"$(slurp)\" "
    ];
  };
}
