{ config, pkgs, lib, device, ... }:
let
  monitors = [ "eDP-1" ] ++
    map (id: "DP-" + builtins.toString id) (lib.lists.range 1 8) ++
    map (id: "HDMI-A-" + builtins.toString id) (lib.lists.range 1 2);
in
{
  services.hyprpaper.settings = {
    ipc = "off";
    splash = false;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      # "eDP-1,2736x1824,0x0,2" # builtin
      "desc:Samsung Display Corp. 0x4190,2880x1800@120,0x0,2" # builtin (120hz possibles)
      "desc:Fujitsu Siemens Computers GmbH E22W-5 YV2C027320,1680x1050@60,1440x-1050,1" # big fujitsu
      "desc:Ancor Communications Inc ASUS VW199 DCLMTF153087,1440x900@60,0x-900,1" # small asus

      "desc:HSI HiTV 0x00000001,highres,0x-1440,1" # projector

      "desc:Ancor Communications Inc VX279 D5LMRS021367,1920x1080,0x-1080,1" # work
      "desc:Dell Inc. DELL U2412M Y1H5T17S0N3L,1680x1050@60,0x-1050,1" # work dell
      "desc:Dell Inc. DELL P2312H YJ3JX2B2H1UL,1920x1080@60,-1080x-1200,1,transform,1" # another work dell (vertical)
      "desc:Dell Inc. DELL U2412M Y1H5T2C704HL,1920x1200@60,0x-1200,1" # another work dell
      ",preferred,auto,1" # fallback      
      # ",preferred,auto,1, mirror, eDP-1"

    ];
    
    env = [
      "GRIM_DEFAULT_DIR,${config.xdg.userDirs.pictures}/screenshots"
    ];

    windowrule = [
      # xdg-desktop-portal-termfilechooser
      "float on,match:initial_class ^(file_chooser)$"
      "size 800 500,match:initial_class ^(file_chooser)$"
      "center on,match:initial_class ^(file_chooser)$"
    ];

    input = {
      touchpad.natural_scroll = true;

      kb_layout = "it,us";
      kb_options = "grp:win_space_toggle,caps:escape"; # caps:escape_shifted_capslock";

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
      gaps_in = 5;
      gaps_out = 10;
    };

    animations = {
      enabled = true;
    };

    dwindle = {
      preserve_split = true;
      pseudotile = true;
    };

    master = {
      new_status = "master";
    };
    
    gestures = {
      workspace_swipe_forever = false;
      workspace_swipe_use_r = true;
      workspace_swipe_distance = 150;
      workspace_swipe_cancel_ratio = 0.1;
    };

    plugin = {
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
      # overview = {
      #   
      # };
    };

    debug = {
      disable_logs = true;
      enable_stdout_logs = false;
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
      # suppress_portal_warnings = true; # documented but does not exists
      allow_session_lock_restore = true;
      middle_click_paste = false;
    };
    
    cursor = {
      enable_hyprcursor = true;
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
      shadow = {
        enabled = true;
        range = 15;
        color = lib.mkDefault "0xffa7caff";
        color_inactive = "0x50000000";
      };
      active_opacity = 1.0;
      inactive_opacity = 0.75;
    };

    # Monitor bindings and workspace persistance. N workspaces per monitor (But the [n]0 and [n]{n-1} cannot be accessed)
    workspace =
      let
        n = config.wayland.windowManager.hyprland.maxNWorkspaces;
      in
      lib.lists.flatten
        (lib.lists.imap0
          (mId: name:
            builtins.genList
              (wId: builtins.toString (mId * n + wId) + ", monitor:${name}" + # optional: persistent:true, change only the waybar widget
                lib.strings.optionalString (wId == 1) ", default:true") # The [n]1 workspace is the default  
              n)
          monitors);
  };
}
