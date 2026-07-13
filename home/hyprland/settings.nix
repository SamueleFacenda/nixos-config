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
    # review at first login: monitor strings were parsed into output/mode/position/scale tables
    monitor = [
      # "eDP-1,2736x1824,0x0,2" # builtin
      { output = "desc:Samsung Display Corp. 0x4190"; mode = "2880x1800@120"; position = "0x0"; scale = "2"; } # builtin (120hz possibles)
      { output = "desc:Fujitsu Siemens Computers GmbH E22W-5 YV2C027320"; mode = "1680x1050@60"; position = "1440x-1050"; scale = "1"; } # big fujitsu
      { output = "desc:Ancor Communications Inc ASUS VW199 DCLMTF153087"; mode = "1440x900@60"; position = "0x-900"; scale = "1"; } # small asus

      { output = "desc:HSI HiTV 0x00000001"; mode = "highres"; position = "0x-1440"; scale = "1"; } # projector

      { output = "desc:Ancor Communications Inc VX279 D5LMRS021367"; mode = "1920x1080"; position = "0x-1080"; scale = "1"; } # work
      { output = "desc:Dell Inc. DELL U2412M Y1H5T17S0N3L"; mode = "1680x1050@60"; position = "0x-1050"; scale = "1"; } # work dell
      { output = "desc:Dell Inc. DELL P2312H YJ3JX2B2H1UL"; mode = "1920x1080@60"; position = "-1080x-1200"; scale = "1"; transform = 1; } # another work dell (vertical)
      { output = "desc:Dell Inc. DELL U2412M Y1H5T2C704HL"; mode = "1920x1200@60"; position = "0x-1200"; scale = "1"; } # another work dell
      { output = "desc:Lenovo Group Limited LEN P27h-10"; mode = "2560x1440@60"; position = "0x-1440"; scale = "1"; } # internship lenovo
      { output = "desc:Samsung Electric Company S27B350"; mode = "1920x1080@60"; position = "0x-1080"; scale = "1"; } # internship samsung
      { output = ""; mode = "preferred"; position = "auto-up"; scale = "1"; } # fallback
      # { output = ""; mode = "preferred"; position = "auto"; scale = "1"; mirror = "eDP-1"; }
    ];

    env = [
      { _args = [ "GRIM_DEFAULT_DIR" "${config.xdg.userDirs.pictures}/screenshots" ]; }
    ];

    window_rule = [
      # xdg-desktop-portal-termfilechooser
      { match = { initial_class = "^(file_chooser)$"; }; float = true; }
      # review at first login: window-rule size effect shape (list vs "800 500")
      { match = { initial_class = "^(file_chooser)$"; }; size = [ 800 500 ]; }
      # review at first login: window-rule center effect field name
      { match = { initial_class = "^(file_chooser)$"; }; center = true; }
    ];

    # All hyprland.conf groups merge into a single hl.config({...}) call.
    config = {
      input = {
        touchpad.natural_scroll = true;

        kb_layout = "it,us";
        kb_options = "grp:win_space_toggle,caps:escape"; # caps:escape_shifted_capslock";

        repeat_rate = 25;
        repeat_delay = 500;

        follow_mouse = 2; # keyboard focus don't change until click on window
      };

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
      };

      master = {
        new_status = "master";
      };

      # review at first login: the workspace_swipe_* gestures section may be superseded by hl.gesture in 0.55
      gestures = {
        workspace_swipe_forever = false;
        workspace_swipe_use_r = true;
        workspace_swipe_distance = 150;
        workspace_swipe_cancel_ratio = 0.1;
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
          color = lib.mkDefault "0xffa7caff"; # review at first login: Lua color format
          color_inactive = "0x50000000";
        };
        active_opacity = 1.0;
        inactive_opacity = 0.75;
      };
    };

    device = [
      {
        name = "ipts-stylus";
        transform = 0;
        output = "eDP-1";
      }
    ];

    # Monitor bindings and workspace persistance. N workspaces per monitor (But the [n]0 and [n]{n-1} cannot be accessed)
    workspace_rule =
      let
        n = config.wayland.windowManager.hyprland.maxNWorkspaces;
      in
      lib.lists.flatten
        (lib.lists.imap0
          (mId: name:
            builtins.genList
              (wId:
                {
                  workspace = builtins.toString (mId * n + wId);
                  monitor = name; # optional: persistent = true, change only the waybar widget
                }
                # The [n]1 workspace is the default
                // lib.optionalAttrs (wId == 1) { default = true; })
              n)
          monitors);
  };
}
