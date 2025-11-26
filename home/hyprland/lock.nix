{ config, pkgs, ... }: {
  services.hypridle = let 
    screen-on = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
    screen-off = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
    lock = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; # --fade-in 5
    trigger_lock = "${pkgs.systemd}/bin/loginctl lock-session && sleep 2";
  in
  {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = screen-on;
        before_sleep_cmd = trigger_lock;
        ignore_dbus_inhibit = false;
        lock_cmd = lock;
      };
      listener = [
        {
          timeout = 300;
          on-timeout = trigger_lock;
          # on-timeout = lock + " --fade-in 5";
        }
        {
          timeout = 600;
          on-timeout = screen-off;
          on-resume = screen-on;
        }
        {
          timeout = 900;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate";
          on-resume = screen-on;
        }
      ];
    };
  };
  
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 5;
          blur_size = 1;
        }
      ];

      input-field = with config.lib.stylix.colors; [
        {
          halign = "center";
          valign = "center";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(${base05})";
          inner_color = "rgb(${brown})";
          fail_color = "rgb(${base08})";
          check_color = "rgb(${base0A})";
          outline_thickness = 0;
          placeholder_text = "";
        }
      ];
    };
  };
}
