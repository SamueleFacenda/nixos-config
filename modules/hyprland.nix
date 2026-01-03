{ config, pkgs, lib, nixpkgs-wayland, ... }: {

  programs.hyprland.enable = true;

  # LidSwitch and PowerButton actions
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # enable all the keyboard for system resume
  powerManagement.powerDownCommands = ''
    for usb in $(ls /sys/bus/usb/devices/*/power/wakeup)
    do
      echo enabled > $usb
    done
  '';

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };


  environment.systemPackages = with pkgs; [
    inotify-tools
    killall
    tuigreet
    polkit_gnome
    swayosd
    bluetuith
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      #xdg-desktop-portal-shana
      #xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [
        "termfilechooser"
      ];
    };
  };

  # needed by termfilechooser portal
  environment.sessionVariables.TERMCMD = "${pkgs.kitty}/bin/kitty --class=file_chooser --override background_opacity=1";

  # enable dconf for desktop config
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security = {
    polkit.enable = true;

    pam.services = {
      # login.enableGnomeKeyring = true;
      # login.gnupg.enable = true;
      hyprlock.unixAuth = true;
      hyprlock.enableGnomeKeyring = true;
      greetd.enableGnomeKeyring = true;
    };
  };

  # Install swayosd udev rules and service (libinput listener), the main service is in home-manager
  services.udev.packages = [ pkgs.swayosd ];
  systemd.packages = [ pkgs.swayosd ];
  services.dbus.packages = [ pkgs.swayosd ];

  services.displayManager.gdm.enable = lib.mkForce false;
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --user-menu \
            --cmd start-hyprland \
            --width 50
        '';
        # XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
        user = "greeter";
      };
    };
  };

  environment.etc."greetd/environments".text = "Hyprland";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  # Fix captive portal issues
  programs.captive-browser = {
    enable = true;
    interface = "wlo1";
    # Use brave instead
    browser = lib.concatStringsSep " " [
      "env XDG_CONFIG_HOME=\"$PREV_CONFIG_HOME\""
      "${pkgs.brave}/bin/brave"
      "--user-data-dir=\${XDG_DATA_HOME:-$HOME/.local/share}/brave-captive"
      "--proxy-server=\"socks5://$PROXY\""
      "--host-resolver-rules=\"MAP * ~NOTFOUND , EXCLUDE localhost\""
      "--no-first-run"
      "--new-window"
      "--incognito"
      "-no-default-browser-check"
      "http://cache.nixos.org/"
    ];
  };
}
