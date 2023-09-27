{ config, pkgs, lib, ... }: {

  programs.hyprland.enable = true;

  # LidSwitch and PowerButton actions
  services.logind = {
    powerKey = "suspend";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitch = "suspend";
  };

  # enable all the keyboard for system resume
  powerManagement.powerDownCommands = ''
    for usb in $(ls /sys/bus/usb/devices/*/power/wakeup)
    do
      echo enabled > $usb
    done
  '';

  environment.systemPackages = with pkgs; [
    inotify-tools
    killall
    greetd.tuigreet
    polkit_gnome
  ];

  # enable file choser on gtk apps
  #xdg.portal.gtkUsePortal = true;

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-shana
    xdg-desktop-portal-gtk
  ];

  # enable dconf for desktop config
  programs.dconf.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.swaylock.unixAuth = true;
  security.pam.services.swaylock.enableGnomeKeyring = true;
  security.pam.services.swaylock.gnupg.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.greetd.gnupg.enable = true;


  services.xserver.displayManager.gdm.enable = lib.mkForce false;
  services.greetd = {
    enable = true;
    vt = 2; # clean login screen, no startup logs
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd Hyprland \
            --width 50
        '';
        # XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
        user = "greeter";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
