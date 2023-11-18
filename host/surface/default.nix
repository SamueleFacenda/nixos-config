{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
let
  toml = pkgs.formats.toml { };
in
{
  imports = with specialArgs;
    [
      ../../modules/system.nix
      ../../modules/nixos.nix
      # ../../modules/gnome.nix
      ../../modules/remote-build.nix
      ../../modules/hyprland.nix
      ../../modules/network.nix
      ../../modules/stylix.nix
      ../../modules/utils.nix
      ../../timers/empty-trash.nix
      ../../secrets

      ./hardware-configuration.nix
      nixos-hardware.nixosModules.microsoft-surface-pro-intel

      agenix.nixosModules.default

      (args: { nixpkgs.overlays = import ../../overlays args; })

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs // {
            inherit (config.lib) utils;
            inherit (config.age) secrets;
            disabledFiles = [ ];
          };
          users.samu = import ../../home;
        };
      }
    ];

  networking.hostName = "surface";

  # enable surface stylus and touch, disable surface control tool
  microsoft-surface = {
    ipts.enable = true; # lib.mkForce false;
    surface-control.enable = lib.mkForce false; # useless, I use power-profiles-daemon
  };

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

  environment.etc."iptsd.conf".source = toml.generate "iptsd.conf" {
    Touch = {
      DisableOnPalm = true;
      DisableOnStylus = true;
    };
  };

  environment.systemPackages = with pkgs; [
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
}
