{ config, pkgs, lib, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.users.default.name} = {
    isNormalUser = true;
    description = config.users.default.longName;
    hashedPassword = "$y$j9T$uT/2s7MBr3VdlbSg9VOly.$01sbSx0zeTs2axvuJZOdpEs3Xreti2XMaPm.RSuaj/7";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  users.groups.input = { };

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,it";
    options = "grp:win_space_toggle,caps:escape";
    #options = "grp:win_space_toggle,caps:swapcaps";
    # xkbOptions = "grp:win_space_toggle,caps:escape_shifted_capslock";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false; # bug that causes high cpu for cupsd-browsed
  # services.printing.cups-pdf.enable = true;
  # auto-discover
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.udisks2.enable = true;

  services.power-profiles-daemon.enable = true;

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # enable plymouth
  boot.plymouth = {
    enable = false;
    #theme = "breeze";
  };

  # Important! It will persist overwise (and some build will persist in the store)
  boot.tmp.cleanOnBoot = true;

  # enable zsh system-wide and set it as default
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    wget
    micro
    git
    curl
    neofetch
    ranger
    trashy
    wakatime
    linux-firmware
    gnumake
    wireguard-tools
    networkmanager
    usbutils
    glxinfo

    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (
      let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
        name = "fhs";
        targetPkgs = pkgs: (
          (base.targetPkgs pkgs) ++ (with pkgs; [
            pkg-config
            ncurses
            glibc
            glib
          ])
        );
        profile = "export FHS=1";
        runScript = "zsh";
        extraOutputsToInstall = [ "dev" ];
      })
    )
  ];
  
  # Tinyproxy reverse proxy for wakatime
  # https://github.com/muety/wakapi/wiki/Advanced-Setup:-Client-side-proxy
  services.tinyproxy = {
    enable = true;
    settings = {
      Port = 58888;
      LogLevel = "Notice";
    };
  };

  environment.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
  environment.localBinInPath = true;

  # for electron (e.g. vscode) in wayland, currenty broken (sometimes)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.kmscon = {
    enable = false; # buggy and not very good looking in multi monitor
    extraConfig = with config.services.xserver.xkb; ''
      xkb-layout=${layout}
      xkb-options=${options}
    '';
    fonts = [{
      package = pkgs.nerd-fonts.monofur;
      name = "Monofur Nerd Font Mono";
    }];
  };
  console = {
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v32n.psf.gz";
    useXkbConfig = true;
  };

  # Geolocalization over Dbus
  location.provider = "geoclue2";
  services.geoclue2.enable = true;
}
