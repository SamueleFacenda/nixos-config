{ config, pkgs, ... }:{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    profiles = {
      undocked.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0x0";
          scale = 2.0;
        }
      ];
      docked.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824";
          position = "0x900";
          scale = 2.0;
          status = "disable";
        }
        {
          criteria = "Fujitsu Siemens Computers GmbH E22W-5 YV2C027320";
          mode = "1680x1050";
          position = "1440x0";
        }
        {
          criteria = "Ancor Communications Inc ASUS VW199 DCLMTF153087";
          mode = "1440x900";
          position = "0x0";
        }
      ];
      fallback.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0x0";
          scale = 2.0;
        }
        {
          criteria = "*";
          status = "enable";
        }
      ];
    };
  };
}
