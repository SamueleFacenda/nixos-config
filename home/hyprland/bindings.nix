{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings =
    let
      keyboard = "wvkbd-mobintl";
      flags = "--landscape-layers simple,special,emoji -L 200 ";
    in
    {

      "$mod" = "SUPER";

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, C, killactive,"
        "$mod, F, togglefloating,"
        "$mod, M, exit,"
        "$mod, B, exec, hyprctl dispatch dpms off"
        "$mod, right, movetoprevdesk"
        "$mod, left, movetonextdesk"
        "$mod, space, exec, echo keyboard_change" # keyboard change, configured in settings (keep to prevent menu spawn)
        "$mod, S, fullscreen"

        # hycov (overview)
        "ALT, tab, hycov:toggleoverview, forceallinone"

        # Windows bindings (they are recorded on the mouse)
        "CTRL_SUPER, left, prevdesk"
        "CTRL_SUPER, right, nextdesk"

        ", edge:r:l, nextdesk"
        ", edge:l:r, prevdesk"
        ", edge:d:u, exec, toggle ${keyboard} ${flags}"

        #### windows navigation and arrangement ####
        # move to window around of monitors
        "CTRL_SHIFT, L, movewindow, mon:r"
        "CTRL_SHIFT, H, movewindow, mon:l"
        "CTRL_SHIFT, J, movewindow, mon:d"
        "CTRL_SHIFT, K, movewindow, mon:u"
        # focus a window in direction
        "CTRL, L, movefocus, r"
        "CTRL, H, movefocus, l"
        "CTRL, J, movefocus, d"
        "CTRL, K, movefocus, u"

      ];

      bindr = [
        "$mod,super_l, exec, toggle wofi --show drun"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        # Lid switch settings
        #",switch:Lid Switch,exec,swaylock"

        # ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,2736x1824,1440x1050,2\""
        ",switch:off:Lid Switch,exec, wake"
        #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3,1680x1050,1440x0,1\""
        #",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4,1440x900,0x0,1\""

        ",switch:on:Lid Switch,exec, suspend"
        #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-3, disable\""
        #",switch:off:Lid Switch,exec,hyprctl keyword monitor \"DP-4, disable\""
      ];

      bindle = [
        # volume keys
        ", XF86AudioRaiseVolume, exec, swayosd-client --max-volume 150 --output-volume +5"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume -5"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise 200"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower 200"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioStop, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", print, exec, grim -g \"$(slurp)\" "
      ];
    };
}
