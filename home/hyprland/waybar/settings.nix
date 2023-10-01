{ config, pkgs, ... }:
let
base_config = {
  layer = "top";
  position = "top";

  modules-left = [
    "custom/launcher"
    "hyprland/workspaces"
  ];
  modules-center = [
    "clock"
  ];
  modules-right = [
    "temperature"
    "memory"
    "cpu"
    "network"
    "pulseaudio"
    "battery"
    "hyprland/language"
    "custom/powermenu"
  ];

  "custom/launcher" = {
    format = " ";
    on-click = "pkill .wofi-wrapper || wofi_menu";
    tooltip = false;
  };

  pulseaudio = {
    scroll-step = 1;
    format = "{icon} {volume}%";
    format-muted = "󰖁 Muted";
    format-icons = {
      default = [ "" "" "" ];
    };
    on-click = "pamixer -t";
    tooltip = false;
  };

  clock = {
    interval = 1;
    format = "{:%R  %A %b %d}";
    tooltip = true;
    tooltip-format = "{:%A; %d %B %Y}\n<tt>{calendar}</tt>";
  };

  memory = {
    interval = 1;
    format = "󰻠 {percentage}%";
    states = {
      warning = 85;
    };
  };

  cpu = {
    interval = 1;
    format = "󰍛 {usage}%";
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

  "custom/powermenu" = {
    format = "";
    on-click = "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
    tooltip = false;
  };

  tray = {
    icon-size = 15;
    spacing = 5;
  };

  battery = {
    states = {
      "good" = 90;
      "warning" = 30;
      "critical" = 15;
    };
    format = "{icon}   {capacity}%";
    format-charging = "{capacity}% 󱐋";
    format-plugged = "{capacity}% ";
    format-alt = "{icon} {time}";
    # format-good = ""; // An empty format will hide the module
    # format-full = "";
    format-icons = [ "" "" "" "" "" ];
  };

  "hyprland/workspaces" = {
    active-only = false;
    all-outputs = true;
    disable-scroll = false;
    on-scroll-up = "hyprctl dispatch workspace -1";
    on-scroll-down = "hyprctl dispatch workspace +1";
    format = "{icon}";
    on-click = "activate";
    format-icons = {
      urgent = "";
      active = "";
      default = "󰧞";
    };
    sort-by-number = true;
  };

  "hyprland/language" = {
    format = "{}";
    format-en = "us🇺🇸";
    format-it = "it🇮🇹";
    keyboard-name = "microsoft-surface-type-cover-keyboard";
  };
};
in
{
  programs.waybar.settings = builtins.map (x: base_config // x) [
    ## OUTPUT SPECIFIC CONFIG
    {
      output = "eDP-1";
      "hyprland/language" = {
        format = "{}";
        format-en = "us🇺🇸";
        format-it = "it🇮🇹";
        keyboard-name = "microsoft-surface-type-cover-keyboard";
      };
    }
    {
      output = [ "DP-3" "DP-5" ];
      "hyprland/language" = {
        format = "{}";
        format-en = "us🇺🇸";
        format-it = "it🇮🇹";
        keyboard-name = "keychron-keychron-k3-pro";
      };
    }
  ];
}
