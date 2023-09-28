{ config, pkgs, ... }:{
  systemd.user.services.kanshi.Service.ExecReload = "${pkgs.kanshi}/bin/kanshictl reload";
  services.kanshi = {
    enable = false;
    systemdTarget = "hyprland-session.target";
    profiles = {
      undocked.exec = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      undocked.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0,0";
          scale = 2.0;
          status = "enable";
        }
      ];
      docked.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824";
          position = "0,900";
          scale = 2.0;
          status = "disable";
        }
        {
          criteria = "Fujitsu Siemens Computers GmbH E22W-5 YV2C027320";
          mode = "1680x1050";
          position = "1440,0";
          status = "enable";
        }
        {
          criteria = "Ancor Communications Inc ASUS VW199 DCLMTF153087";
          mode = "1440x900";
          position = "0,0";
          status = "enable";
        }
      ];
      fallback.outputs = [
        {
          criteria = "eDP-1";
          mode = "2736x1824@60";
          position = "0,0";
          scale = 2.0;
          status = "enable";
        }
        {
          criteria = "*";
          status = "enable";
        }
      ];
    };
  };
}
