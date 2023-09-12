{ config, pkgs, ... }: {
  programs.waybar.settings = [{
    layer = "top";
    position = "top";

    modules-left = [
      "custom/launcher"
      "temperature"
      "hyprland/workspaces"
      "hyprland/window"
    ];
    modules-center = [
      "clock"
    ];
    modules-right = [
      "tray"
      "keyboard-state"
      "pulseaudio"
      #"backlight"
      "memory"
      "cpu"
      "battery"
      "network"
      "custom/powermenu"
    ];

    output = [ "DP-3" "eDP-1" ];

    "hyprland/window" = { };

    keyboard-state = {
      numlock = true;
      capslock = true;
      format = "{name} {icon}";
      format-icons = {
        locked = "";
        unlocked = "";
      };
    };

    "custom/launcher" = {
      format = " ";
      on-click = "pkill rofi || rofi2";
      on-click-middle = "exec default_wall";
      on-click-right = "exec wallpaper_random";
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
    };

    network = {
      format-disconnected = "󰯡 Disconnected";
      format-ethernet = "󰒢 Connected!";
      format-linked = "󰖪 {essid} (No IP)";
      format-wifi = "󰖩 {essid}";
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
  		format = "{icon}{id}";
  		on-click = "activate";
  		format-icons = {
  			urgent = "";
  			active = "";
  			default = "󰧞";
  		};
      sort-by-number = true;
    };
  }];
}
