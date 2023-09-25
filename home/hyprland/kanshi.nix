{ config, pkgs, ... }:{
  services.kanshi = {
    enable = false;
    systemdTarget = "hyprland-session.target";
    profiles = {
      undocked.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0x0";
          scale = "2";
          adaptiveSync  true;
        }
      ];
      docked.outpus = [
        {
          criteria = "eDP-1";
          mode = "2736x1824";
          position = "0x900";
          scale = "2";
          status = "disable";
        }
        {
          criteria = "DP-3";
          mode = "1680x1050";
          position = "1440x0";
        }
        {
          criteria = "DP-4";
          mode = "1440x900";
          position = "0x0";
        }
      ];
      fallback.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0x0";
          scale = "2";
          adaptiveSync  true;
        }
        {
          criteria = "*";
          status = "enable";
        }
      ];
    };
  };
}
