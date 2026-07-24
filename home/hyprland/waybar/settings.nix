{ config, pkgs, lib, ... }:
let
  base_config = {
    layer = "top";
    position = "top";

    modules-left = [
      "custom/launcher"
      "wlr/taskbar"
      "hyprland/workspaces"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "temperature"
      "memory"
      "cpu"
      "group/traydrawer"
      "network"
      "wireplumber"
      "battery"
      "idle_inhibitor"
      "custom/osk"
      "hyprland/language"
      "custom/powermenu"
    ];
    
    "group/traydrawer" = {
      orientation = "inherit";
      modules = [
        "custom/left-icon"
        "tray"
      ];
      drawer = {
        transition-duration = 500;
        children-class = "traydrawer-child";
        transition-left-to-right = false;
      };
    };
    
    "custom/left-icon" = {
      tooltip = false;
      format = "";
    };

    "custom/launcher" = {
      format = " ";
      # on-click = "toggle wofi --show drun";
      on-click = "swaync-client --toggle-panel"; # TODO put in the proper place and side
      tooltip = false;
    };

    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 14;
      tooltip = false;
      on-click = "activate";
      on-click-middle = "close";
      ignore-list = [
        # "kitty"
      ];
    };

    wireplumber = {
      scroll-step = 1;
      format = "{icon} {volume}%";
      format-muted = "󰖁 0%";
      format-icons = {
        default = [ "" "" "" ];
      };
      on-click = "swayosd-client --output-volume mute-toggle";
      on-scroll-down = "swayosd-client --output-volume +1";
      on-scroll-up = "swayosd-client --output-volume -1";
      tooltip = false;
    };

    clock = {
      interval = 1;
      format = "{:%R  %A %b %d}";
      tooltip = true;
      tooltip-format = "<tt>{calendar}</tt>";
    };
    
    mpris = {
      format = "DEFAULT: {player_icon} {dynamic}";
      format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
      player-icons = {
      	default = "▶";
      	mpv = "🎵";
      };
      status-icons = {
      	paused = "⏸";
      };
    };

    temperature = {
      hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
      input-filename = "temp1_input";
      critical-threshold = 100;
      interval = 5;
      format-icons = [ "" "" "" "" "" "󰸁" ];
      format = "{icon} {temperatureC}󰔄";
    };

    memory = {
      interval = 1;
      format = "󰍛 {percentage:02}%";
      states = {
        warning = 85;
      };
    };

    cpu = {
      interval = 1;
      format = "󰻠 {usage:02}% {avg_frequency:.1f}<span size='small'>GHz</span>";
      states = {
        warning = 95;
      };
    };

    network = {
      format-disconnected = "󰯡 Disconnected";
      format-ethernet = "󰒢 Connected!";
      format-linked = "󰖪 {essid} (No IP)";
      format-wifi = "󰖩  {essid}";
      interval = 1;
      tooltip = false;
    };

    "custom/osk" =
      let
        keyboard = "wvkbd-mobintl";
        flags = "--landscape-layers simple,special,emoji -L 200 ";
      in
      {
        format-alt = "󰌐"; # They are inverted
        format = "󰌌";
        tooltip = false;
        # https://github.com/Alexays/Waybar/issues/1850
        on-click = "sleep 0.1 && toggle ${keyboard} ${flags}";
      };

    "custom/powermenu" = {
      format = "";
      tooltip = false;
      on-click = "toggle nwg-bar";
    };

    tray = {
      icon-size = 14;
      # show-passive-items = true;
      spacing = 5;
    };

    battery = {
      interval = 10;
      full-at = 99;
      on-click = "toggle nwg-bar -t power.json";
      states = {
        "good" = 90;
        "warning" = 30;
        "critical" = 15;
      };
      format = "{icon}   {capacity}%";
      format-charging = "󱐋 {capacity}%";
      format-plugged = " {capacity}%";
      # format-full = ""; // An empty format will hide the module
      format-icons = [ "" "" "" "" "" ];
      tooltip = false;
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "󰒳";
        deactivated = "󰒲";
      };
    };

    "hyprland/workspaces" = {
      active-only = false;
      all-outputs = false;
      disable-scroll = false;
      on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"r+1\" })'";
      on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"r-1\" })'";
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        urgent = "";
        active = "";
        default = "󰧞";
      };
      sort-by-number = true;
      ignore-workspaces = [
        "[0-9]*0" # Not show unreachable workspaces
        "[0-9]*9"
      ];
    };

    "hyprland/language" = {
      format = "{}";
      format-en = "us🇺🇸";
      format-it = "it🇮🇹";
      keyboard-name = config.home.keyboard.model;
    };
  };
in
{
  programs.waybar.settings = 
    let 
      mainMonitors = [ # toggling enabled
        "Samsung Display Corp. 0x4190 "
      ];
      excludedSecondary = [ # output disabled by deafault
        "Fujitsu Siemens Computers GmbH E22W-5 YV2C027320"
        "Ancor Communications Inc ASUS VW199 DCLMTF153087"
      ];
      exclude = map (name: "!${name}");
    in
    builtins.map (lib.recursiveUpdate base_config) [
      ## OUTPUT SPECIFIC CONFIG
      {
        output = mainMonitors;
      }
      {
        output = exclude mainMonitors ++ exclude excludedSecondary ++ [ "*" ];
        on-sigusr1 = "noop";
      }
      {
        output = [ "Fujitsu Siemens Computers GmbH E22W-5 YV2C027320" ];
        "hyprland/language".keyboard-name = "keychron-keychron-k3-pro-keyboard"; # "keychron-keychron-k3-pro"; # Changes betwenn bluetooth and cabled connection
        on-sigusr1 = "noop";
      }
    ];
}
