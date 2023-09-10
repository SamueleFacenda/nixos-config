# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/gnome.nix
      ../../modules/remote-build.nix
      ../../modules/hyprland.nix
      ../../timers/empty-trash.nix
      ../../secrets

      ./hardware-configuration.nix
    ];

  # https://github.com/linux-surface/linux-surface/issues/652 shoud remove the IPTSD shutdown block (not always work)
  boot.kernelParams = [
    "intel_iommu=off"
  ];

  networking.hostName = "surface"; # Define your hostname.

  # enable surface stylus and touch, and surface control tool
  microsoft-surface = {
    ipts.enable = true;# lib.mkForce false; # problem at shutdown
    surface-control.enable = true;
  };

  # system.activationScripts.repairButtons = ''
  #  ${pkgs.kmod}/bin/modprobe -r soc_button_array
  #  ${pkgs.kmod}/bin/modprobe soc_button_array
  # ''; # bad fix

  # or
  boot.kernelPatches = [ {
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
    libcamera
  ];
}
