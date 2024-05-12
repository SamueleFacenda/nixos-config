{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
let 
  stateVersion = "23.11";
in {
  imports = with specialArgs;
    [
      # mandatory
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/utils.nix

       ./hardware-configuration.nix
       nixos-hardware.nixosModules.common-cpu-intel 

      # speed up kernel builds (slow down easy build unless overwritten)
      # ../../modules/remote-build.nix

      # choose one or both
      # ../../modules/gnome.nix
      ../../modules/hyprland.nix

      # optionals wifi settings (networkmanager is already enable by default)
      ../../modules/network.nix

      # optionals
      ../../timers/empty-trash.nix
      ../../modules/stylix.nix # needed for home-manager, not very optional

      # secrets (settings are below)
      agenix.nixosModules.default
      ../../secrets

      # nix user repository
      nur.nixosModules.nur

      # { nixpkgs.overlays = [ nixpkgs-wayland.overlay ]; }
      ../../overlays

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";

          extraSpecialArgs = specialArgs // {
            inherit (config.lib) utils;
            inherit (config.age) secrets;
            disabledFiles = [
              "hyprgrass.nix"
            ];
            device.keyboard = "at-translated-set-2-keyboard";
          };

          users.${config.users.default.name} = _: {
            imports = [ ../../home ];
            home = {
              username = config.users.default.name;
              homeDirectory = "/home/" + config.users.default.name;
              inherit stateVersion;
            };
          };
        };
      }
      
      # Device specific config
      ./power.nix
      ./gpu.nix
      
      # Secure boot
      lanzaboote.nixosModules.lanzaboote
    ];

  # override for custom name (this is also the default value)
  users.default.name = "samu";
  users.default.longName = "Samuele Facenda";
  users.users.samu.hashedPassword = lib.mkForce null;

  networking.hostName = "zenbook";

  secrets = {
    spotify.enable = true;
    network-keys.enable = true;
    wakatime-key.enable = true;
    github-token.enable = true;
    nix-access-tokens.enable = true;
  };

  system.stateVersion = stateVersion;
  
  # Weylus: use the surface as input device
  programs.weylus = {
    enable = true;
    users = [ "samu" ];
  };
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Thunderbolt
  services.hardware.bolt.enable = true;
  
  home-manager.users.samu.wayland.windowManager.hyprland.settings = {
    workspace = [
      "m[eDP-1] w[t1], gapsin:0, rounding:false, decorate:false, gapsout:0"
    ];
    # windowrulev2 = [
    #   # "fullscreen:1, onworkspace:m[eDP-1] w[1]"
    #   "minsize 1440 900, onworkspace:m[eDP-1] w[t1]"
    # ];
  };
  
  # Automatic ssd trim
  services.fstrim.enable = true; 
  
  # Swap and hibernate
  swapDevices = [ { device = "/var/swapfile"; size = (48 + 8)*1024; } ]; # ram + buffer
  boot.resumeDevice = "/dev/dm-0";
  boot.kernelParams = [
    "resume_offset=2291712"
  ];
  services.logind.lidSwitch = lib.mkForce "suspend-then-hibernate"; # hibernate only when not connected to power or monitors
  
  # Secure boot
  
  environment.systemPackages = with pkgs; [
    sbctl
  ];
  
  boot.loader.systemd-boot.enable = lib.mkForce false;
  
  boot.lanzaboote = {
    enable = true;
    configurationLimit = 5;
    pkiBundle = "/etc/secureboot";
  };
}
