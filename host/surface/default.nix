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
    surface-control.enable = lib.mkForce false;
  };

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
  ];
}
