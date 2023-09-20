{ config, pgks, ... }: {
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    extraArgs = [
      "-w"
    ];
    events = [
      { event = "after-resume"; command = "hyprctl dispatch dpms on";}
      { event = "before-sleep"; command = "swaylock -f --screenshot --effect-blur 10x7 --fade-in 5";}
    ];
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f --screenshot --effect-blur 10x7 --fade-in 5";
      }
      {
        timeout = 600;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 900;
        command = "systemctl suspend";
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
  };
}
