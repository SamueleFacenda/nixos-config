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
        "$mod, space, exec, echo keyboard_change" # keyboard change, configured in settings (keep to prevent menu spawn)
        "$mod, S, fullscreen"
        "$mod, W, exec, pkill -SIGUSR1 waybar"

        # Windows bindings (they are recorded on the mouse)
        "CTRL_SUPER, left, workspace, r-1"
        "CTRL_SUPER, right, workspace, r+1"

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
        # Move window on virtual desktop
        "$mod, right, movetoworkspace, r+1"
        "$mod, left, movetoworkspace, r-1"

      ];

      bindr = [
        "$mod,super_l, exec, toggle wofi --show drun"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, Control_L, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, ALT_L, resizewindow"
      ];

      bindl = [
        # Lid switch settings
        ",switch:off:Lid Switch,exec, clamshell-wake"
        ",switch:on:Lid Switch,exec, clamshell-suspend"
        
        # Tmp fix for swaylock
        "$mod, BackSpace, exec, pkill -SIGUSR1 swaylock && WAYLAND_DISPLAY=wayland-1 ${pkgs.swaylock-effects}/bin/swaylock -f"
      ];

      bindle = [
        # volume keys
        ", XF86AudioRaiseVolume, exec, swayosd-client --max-volume 150 --output-volume +5"
        ", XF86AudioLowerVolume, exec, swayosd-client --max-volume 150 --output-volume -5"
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
