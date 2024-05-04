{ config, pkgs, lib, device, ... }:
let
  monitors = [
    "eDP-1"
  ] ++ map (id: "DP-" + builtins.toString id) (lib.lists.range 1 9);
in {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      # "eDP-1,2736x1824,1440x1050,2" # builtin
      "eDP-1,highres,0x900,${lib.strings.floatToString device.screenScale}" # builtin
      "desc:Fujitsu Siemens Computers GmbH E22W-5 YV2C027320,highres,1440x0,1" # big fujitsu
      "desc:Ancor Communications Inc ASUS VW199 DCLMTF153087,highres,0x0,1" # small asus
      # "desc:HSI HiTV 0x00000001,highres,0x1812,1" # projector
      "desc:Ancor Communications Inc VX279 D5LMRS021367,highres,1441x900,1"
      "desc:Dell Inc. DELL U2412M Y1H5T17S0N3L,highres,1536x900,1"

      # Monitor DP-2 (ID 1):
      # 	1920x1080@59.94000 at 1441x900
      # 	description: Ancor Communications Inc VX279 D5LMRS021367 (DP-2 via HDMI)

      ",preferred,auto,1" # fallback
    ];

    windowrule = [
      # xdg-desktop-portal-termfilechooser
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

    device = [  
      {
        name = "ipts-stylus";
        transform = 0;
        output = "eDP-1";
      }
    ];


    general = {
      layout = "dwindle";
      border_size = 0;
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

#     plugin = {
#       hyprfocus = {
#         enabled = "yes";
#         keyboard_focus_animation = "flash";
#         mouse_focus_animation = "nothing";
#         bezier = [ "bezIn, 0.5,0.0,1.0,0.5" "bezOut, 0.0,0.5,0.5,1.0" ];
# 
#         flash = {
#           flash_opacity = 0.7;
#           in_bezier = "bezIn";
#           in_speed = 0.5;
#           out_bezier = "bezOut";
#           out_speed = 3;
#         };
#         shrink = {
#           shrink_percentage = 0.95;
#           in_bezier = "bezIn";
#           in_speed = 0.5;
#           out_bezier = "bezOut";
#           out_speed = 3;
#         };
#       };
#     };

    debug = {
      disable_logs = true;
      enable_stdout_logs = false;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = false;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      # suppress_portal_warnings = true; # documented but does not exists
      allow_session_lock_restore = true;
    };

    decoration = {
      rounding = 19;
      blur = {
        enabled = true;
        size = 4;
        passes = 4;
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
        # "wlroots"
        "launcher"
        # "swayosd"
      ];

    };
    
    # Monitor bindings and workspace persistance. 10 workspaces per monitor (But the [n]0 and [n]9 cannot be accessed)
    workspace = lib.lists.flatten 
      (lib.lists.imap0 
        (mId: name:
          builtins.genList
            (wId: builtins.toString (mId*10 + wId) + ", monitor:${name}" + # optional: persistent:true, change only the waybar widget
              lib.strings.optionalString (wId == 1) ", default:true") # The [n]1 workspace is the default  
            10)
        monitors);
  };
}
