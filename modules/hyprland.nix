{ config, pkgs, ... }: {

  programs.hyprland.enable = true;

  # swaylock ask password
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # LidSwitch and PowerButton actions
  services.logind = {
    powerKey = "suspend";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitch = "ignore";
  };

  powerManagement.powerDownCommands = ''
    for usb in $(ls /sys/bus/usb/devices/*/power/wakeup)
    do
      echo enabled > $usb
    done
  '';

  environment.systemPackages = with pkgs; [
    inotify-tools
    killall
  ];

  # enable file choser on gtk apps
  #xdg.portal.gtkUsePortal = true;

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-shana
  ];
}
