{ config, pkgs, ... }: {
  programs.waybar.settings = [{
    layer = "top";
    position = "top";

    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "hyprland/window"
      "hyprland/language"
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
      "tray"
      "custom/powermenu"
    ];

    output = [ "DP-3" "eDP-1" ];

    "hyprland/window" = { };

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
        format-en = "🇺🇸🦅";
        format-it = "🤌🇮🇹";
        keyboard-name = "microsoft-surface-type-cover-keyboard";
    };
  }];
}
