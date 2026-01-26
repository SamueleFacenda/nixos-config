{ config, pkgs, lib, specialArgs, ... }:
# specialArgs are inputs
let
  stateVersion = "23.11";
in
{
  imports = with specialArgs;
    [
      # mandatory
      ../../modules/system.nix
      ../../modules/nixos.nix
      ../../modules/utils.nix
      ../../modules/options.nix
      ../../modules/home.nix

      ./hardware-configuration.nix
      nixos-hardware.nixosModules.common-cpu-intel
      
      # Add `pkgs-cuda` to modules input
      ../../modules/nixpkgs-cuda.nix

      # speed up kernel builds (slows down easy build unless overwritten)
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
      nur.modules.nixos.default

      # { nixpkgs.overlays = [ hyprland.overlays.default ]; }
      ../../overlays

      # Device specific config
      ./power.nix
      ./gpu.nix

      # Secure boot
      lanzaboote.nixosModules.lanzaboote
      
      asus-dialpad-driver.nixosModules.default
    ];

  # override for custom name (this is also the default value)
  users.default.name = "samu";
  users.default.longName = "Samuele Facenda";
  users.users.samu.hashedPassword = lib.mkForce null;
  
  home-manager.users.samu.home.keyboard.model = "at-translated-set-2-keyboard";
  home-manager.disabledFiles = [ "hyprgrass.nix" ];

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
    enable = false; # wait for build fix
    users = [ "samu" ];
  };


  # Latest kernel (important)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Use bbr for more aggressive tcp
  boot.kernelPatches = [{
    name = "bbr";
    patch = null;
    structuredExtraConfig = with pkgs.lib.kernel; {
      TCP_CONG_BBR = yes; # enable BBR
      DEFAULT_BBR = yes; # use it by default
    };
  }];

  # Thunderbolt
  services.hardware.bolt.enable = true;

  home-manager.users.samu.wayland.windowManager.hyprland.settings = {
    workspace = [
      "m[eDP-1] w[t1], gapsin:0, rounding:false, decorate:false, gapsout:0"
    ];
    windowrulev2 = [
      #   # "fullscreen:1, onworkspace:m[eDP-1] w[1]"
      # "maxsize 0 0, class(waybar) onworkspace:m[eDP-1] w[1]"
      #   "minsize 1440 900, onworkspace:m[eDP-1] w[t1]"
    ];
  };

  # Automatic ssd trim
  services.fstrim.enable = true;

  # Swap and hibernate
  swapDevices = [{ device = "/var/swapfile"; size = (48 + 8) * 1024; }]; # ram + buffer
  boot.resumeDevice = "/dev/dm-0";
  boot.kernelParams = [
    "resume_offset=2291712"
    "hibernate.compressor=lz4" # faster
  ];
  boot.initrd.kernelModules = [ "lz4" ];
  # HibernateMode=platform is the default, sometimes it reboots
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=3h
    HibernateMode=shutdown
  '';
  # systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ]; # smaller image size possible
  
  services.logind.settings.Login = {
    HandleLidSwitch = lib.mkForce "suspend-then-hibernate"; # hibernate only when not connected to power or monitors
    HandleLidSwitchExternalPower = lib.mkForce "suspend-then-hibernate";
    # HandlePowerKey = lib.mkForce "suspend-then-hibernate";
  };
  
  # Hibernate routine (before and after sleep commands)
  systemd.services.hibernate_routine = let 
    targets = [
      "hibernate.target"
      "suspend-then-hibernate.target"
      "hybrid-sleep.target"
    ];
    toShell = cmd: "/bin/sh -c '${cmd}'";
    in {
    description = "load/unload modules, reduce image size";
    before = targets;
    unitConfig.StopWhenUnneeded = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = builtins.map toShell [
      "${pkgs.coreutils}/bin/sync"
      "echo 3 > /proc/sys/vm/drop_caches"
      "echo 1 > /proc/sys/vm/compact_memory"
        # "-${pkgs.kmod}/bin/modprobe -a -r ath11k_pci ath11k"
      ];
      ExecStop = builtins.map toShell [ 
        # "-${pkgs.kmod}/bin/modprobe -a ath11k_pci ath11k" 
      ];
    };
    wantedBy = targets;
  };

  # Secure boot

  environment.systemPackages = with pkgs; [
    # Sys tools
    sbctl
    tpm2-tools
    tpm2-tss
    config.boot.kernelPackages.turbostat
    
    # Cli tools
    lsof
    imagemagickBig
    dig
    ncdu
    nmap
    
    # Desktop apps
    bottles
    # cura
    cura-appimage
    cloudcompare
    qgis
    zoom-us
    inkscape
    gimp
    (rawtherapee.overrideAttrs (prevAttrs: {
      postPatch = prevAttrs.postPatch + ''
      
        substituteInPlace rtengine/procparams.cc --replace \
          'outputProfile(options.rtSettings.srgb),' \
          'outputProfile("RTv4_sRGB"),'
      '';
    }))
    darktable
    libreoffice-fresh
  ];
  
  fonts.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Gluten" ]; })
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    configurationLimit = 12;
    pkiBundle = "/etc/secureboot";
    settings.timeout = 2;
  };

  # https://nixos.wiki/wiki/TPM
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
  users.users.samu.extraGroups = [ "tss" "docker" ];

  boot.initrd.systemd.enable = true; # Auto luks unlock
  
  services.fwupd.enable = true;
  
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    autoPrune = {
      enable = true;
      randomizedDelaySec = "1h";
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
  
  virtualisation.waydroid.enable = false;
  
  services.mysql = {
    enable = false;
    # dataDir = "/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "my_pastapizza" ];
    ensureUsers = [ {
      name = "samu";
      ensurePermissions = {
        "my_pastapizza.*" = "ALL PRIVILEGES";
      };
    } ];
  };
  
  # Cable drivers Xilinx FPGAs and Trmnl
  services.udev.extraRules = ''
    ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Xilinx", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
    ATTRS{idVendor}=="1443", MODE:="666" 
    ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="666"
    
    SUBSYSTEM=="usb", ATTR{idVendor}=="303a", ATTR{idProduct}=="1001", MODE="0666"
  '';
  
  # https://discourse.nixos.org/t/warning-not-applying-gid-change-of-group-uinput-989-327-in-etc-group/57652/3
  users.groups.uinput.gid = lib.mkForce 989;
  
  ## To run nvidia jetson sdk and flash the jetson
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # boot.binfmt.preferStaticEmulators = true;
  # boot.binfmt.registrations.aarch64-linux.matchCredentials = true;
  
  # services.nfs.settings.nfsd.debug = "all";
  # services.nfs.server = {
  #   enable = true;
  #   exports = ''
  #     /home/samu/Public/Linux_for_Tegra/tools/kernel_flash/images *(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
  #     /home/samu/Public/Linux_for_Tegra/rootfs *(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
  #   '';
  # };
  
  # Stuff for osx kvm
  
#   virtualisation.libvirtd.enable = true;
#   users.extraUsers.samu.extraGroups = [ "libvirtd" ];
# 
#   boot.extraModprobeConfig = ''
#     options kvm_intel nested=1
#     options kvm_intel emulate_invalid_guest_state=0
#     options kvm ignore_msrs=1
#   '';
  

  services.mongodb.enable = false;
  
  # University vpn (unitn)
  services.globalprotect = {
    enable = false; # Disable as unused and because it has insecure deps
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };
  
  # Touch asus dial config
  services.asus-dialpad-driver = {
    enable = true;
    wayland = true;
    waylandDisplay = "wayland-1";
    layout = "zenbookpro14";
    config.main = {
      enabled = false;
      slices_count = 16;
      disable_due_inactivity_time = 0;
      touchpad_disables_dialpad = true;
      activation_time = 0.5;
      config_supress_app_specifics_shortcuts = 0;
    };
  };
  
  # Printing
  services.printing = {
    enable = lib.mkForce true;
    drivers = with pkgs; [
      brlaser # Open source Brother laser printer driver
      brgenml1lpr # Brother generic LPR driver
      brgenml1cupswrapper # Brother CUPS wrapper
    ];
    openFirewall = true;
    browsing = true;
    cups-pdf.enable = true;
    defaultShared = false;
    startWhenNeeded = true;
    # allowFrom = [ "all" ];
  };
}
