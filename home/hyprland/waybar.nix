{config, pkgs, ...}:{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";

      modules-left = [
        "custom/launcher"
        "temperature"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "pulseaudio"
        "backlight"
        "memory"
        "cpu"
        "network"
        "custom/powermenu"
        "tray"
      ];

      output = ["DP-3"];
      keyboard-state = {
        numlock = true;
        capslock = true;
        format =  "{name} {icon}";
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
        tooltip-format = "{=%A; %d %B %Y}\n<tt>{calendar}</tt>";
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
      
    }];
    systemd.enable = false;
  };
}
