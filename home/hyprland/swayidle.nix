{ config, pkgs, ... }: {
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      { event = "after-resume"; command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";}
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshot --effect-blur 10x7 --fade-in 5";}
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshot --effect-blur 10x7 --fade-in 5";
      }
      {
        timeout = 600;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
