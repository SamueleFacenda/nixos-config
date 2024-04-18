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
    ];

  # override for custom name (this is also the default value)
  users.default.name = "samu";
  users.default.longName = "Samuele Facenda";
  users.users.samu.hashedPassword = lib.mkForce null;

  networking.hostName = "zenbook";

  # custom options for secrets, fallback placeholder is used
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
    

  specialisation.multi-monitor.configuration = {
    home-manager.users.samu.wayland.windowManager.hyprland.settings.env = [
      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "WLR_NO_HARDWARE_CURSORS,1"
    ];
    hardware.nvidia = {
      prime.offload = {
			  enable = lib.mkForce false;
			  enableOffloadCmd = lib.mkForce false;
		  };
		  prime.sync.enable = lib.mkForce true;
    };
  };
  
  # Automatic ssd trim
  services.fstrim.enable = true;
  
  # Hardware tweaks (from https://nixos.wiki/wiki/Laptop)
  
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 30;
      
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 75; # 80 and above it stops charging

    };
  };
  
  powerManagement.powertop.enable = true;
  environment.systemPackages = with pkgs; [
    powertop
    nvtop-nvidia
  ];
  
  
  # Use these or the standard nvidia settings (not working now)
  services.supergfxd.enable = false;
  services.asusd = {
    enable = false;
    enableUserService = false;
  };
  
  
  # Nvidia (https://wiki.nixos.org/wiki/Nvidia)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    
    prime = {
      # pci@0000:00:02.0 nvidia
      # pci@0000:01:00.0 intel
      nvidiaBusId = "PCI:1:0:0";
		  intelBusId = "PCI:0:2:0";
		  
		  offload = {
			  enable = true;
			  enableOffloadCmd = true;
		  };
    };
  }; 
}
