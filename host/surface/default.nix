{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
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

          extraSpecialArgs = specialArgs;
          users.samu = import ../../home;
        };
      }
    ];

  # https://github.com/linux-surface/linux-surface/issues/652 shoud remove the IPTSD shutdown block (not always work)
  #boot.kernelParams = [
  #  "intel_iommu=off"
  #];

  networking.hostName = "surface";

  # enable surface stylus and touch, and surface control tool
  microsoft-surface = {
    ipts.enable = true; # lib.mkForce false; # problem at shutdown
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

  environment.systemPackages = with pkgs; [
    microcodeIntel
    libwacom-surface
    libcamera-surface # custom

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
    options v4l2loopback devices=2 video_nr=40,41 exclusive_caps=1,1 card_label="Virtual Camera,Screen Cast"
  '';
}
