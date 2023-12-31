{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # "eDP-1,2736x1824,1440x1050,2" # builtin
      "eDP-1,highres,0x900,2" # builtin
      "desc:Fujitsu Siemens Computers GmbH E22W-5 YV2C027320,highres,1440x0,1" # big fujitsu
      "desc:Ancor Communications Inc ASUS VW199 DCLMTF153087,highres,0x0,1" # small asus

      ",preferred,auto,1" # fallback
    ];

    windowrule = [
      "float,^(file_chooser)$"
      "size 800 500,^(file_chooser)$"
      "center,^(file_chooser)$"
    ];

    input = {
      touchpad.natural_scroll = true;

      kb_layout = "us,it";
      kb_options = "grp:win_space_toggle,caps:escape_shifted_capslock";

      repeat_rate = 25;
      repeat_delay = 500;

      follow_mouse = 2; # keyboard focus don't change until click on window
    };

    "device:ipts-stylus" = {
      transform = 0;
      output = "eDP-1";
    };


    "device:ipts-touch" = {
      transform = 0;
      output = "eDP-1";
    };

    general = {
      layout = "dwindle";
      "col.active_border" = lib.mkForce "0x00000000";
    };

    animations = {
      enabled = true;
    };

    dwindle = {
      preserve_split = true;
      pseudotile = true;
    };

    master = {
      new_is_master = true;
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_cancel_ratio = 0.15;
    };

    plugin = {
      touch_gestures = {
        sensitivity = 6.0;
        workspace_swipe_fingers = 3;
      };
    };

    misc = {
      force_hypr_chan = false;
      disable_splash_rendering = false;
      disable_hyprland_logo = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      # suppress_portal_warnings = true; # documented but does not exists
    };

    decoration = {
      rounding = 19;
      blur = {
        enabled = true;
        size = 7;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
      };
      drop_shadow = true;
      shadow_range = 15;
      "col.shadow" = lib.mkDefault "0xffa7caff";
      "col.shadow_inactive" = "0x50000000";

      active_opacity = 1.0;
      inactive_opacity = 0.75;
      blurls = [
        # "waybar"
        "lockscreen"
        #"wlroots"
        "launcher"
        # "swayosd"
      ];

    };

  };
}
