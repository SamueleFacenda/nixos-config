# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = 
    [
      ../../modules/system.nix
      ../../modules/nix-optim.nix
      ../../modules/gnome.nix
      ../../timers/empty-trash.nix

      ./hardware-configuration.nix
    ];

  # Bootloader. 
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };

  # https://github.com/linux-surface/linux-surface/issues/652 shoud remove the IPTSD shutdown block (not always work)
  boot.kernelParams = [
  	"intel_iommu=off"
  ];

  networking.hostName = "surface"; # Define your hostname.

  # enable surface stylus and touch, and surface control tool
  microsoft-surface = {
  	ipts.enable = true;
  	surface-control.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
