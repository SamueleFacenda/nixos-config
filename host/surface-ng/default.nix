{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
let
  format = pkgs.formats.ini { };
in
{
  imports = with specialArgs;
    [
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/gnome.nix
      ../../modules/remote-build.nix
      # ../../modules/hyprland.nix
      ../../modules/network.nix
      ../../modules/stylix.nix
      ../../modules/utils.nix
      ../../modules/options.nix
      ../../modules/home.nix
      ../../timers/empty-trash.nix
      
      ./power.nix

      ./hardware-configuration.nix
      nixos-hardware.nixosModules.microsoft-surface-pro-intel

      lanzaboote.nixosModules.lanzaboote

      agenix.nixosModules.default
      ../../secrets

      nur.modules.nixos.default

      # { nixpkgs.overlays = [ nixpkgs-wayland.overlay ]; }
      # { nixpkgs.overlays = [ hyprland.overlays.default ]; }
      ../../overlays
    ];

  # override for custom name
  # users.default.name = "samu";

  # custom options for secrets
  secrets = {
    spotify.enable = true;
    network-keys.enable = true;
    wakatime-key.enable = true;
    github-token.enable = true;
    nix-access-tokens.enable = true;
  };
  
  home-manager.disabledFiles = [ "hyprland" ];
  home-manager.users.samu.home.keyboard.model = "microsoft-surface-type-cover-keyboard";
  home-manager.users.samu.programs.kitty.settings.background_opacity = lib.mkForce "0.9";
  
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  
  boot.initrd.systemd.enable = true; # Auto luks unlock
  
  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkForce "suspend-then-hibernate"; # hibernate only when not connected to power or monitors
    HandleLidSwitchExternalPower = lib.mkForce "suspend-then-hibernate";
    HandlePowerKey = lib.mkForce "suspend-then-hibernate";
    HandleSuspendKey = lib.mkForce "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';

  # fix iptsd shutdown idle problem
  systemd.services.iptsd.serviceConfig = {
    ExecStop = "${pkgs.util-linux}/bin/kill -TERM -$MAINPID";
    Restart = "always";
  };

  # system.activationScripts.repairButtons = ''
  #  ${pkgs.kmod}/bin/modprobe -r soc_button_array
  #  ${pkgs.kmod}/bin/modprobe soc_button_array
  # ''; # bad fix

  # or
  boot.kernelPatches = [{
    name = "fix-surface-buttons";
    patch = null;
    extraConfig = ''
      PINCTRL_INTEL y
      PINCTRL_SUNRISEPOINT y
    '';
  }];

  services.udev.packages = with pkgs; [ libwacom-surface ];

  services.iptsd.config = {
    Touch = {
      DisableOnPalm = true;
      DisableOnStylus = true;
    };
  };

  environment.systemPackages = with pkgs; [
    rnote
    write_stylus
    
    sbctl
  
    microcodeIntel
    libwacom-surface
    libcamera-surface # custom
    iptsd
    power-profiles-daemon

    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
  ];

  # add camera support to application not supporting libcamera
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback devices=2 video_nr=40,41,42 exclusive_caps=1,1,1 card_label="Camera,Screen,Network"
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
