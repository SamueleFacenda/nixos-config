{ config, pkgs, lib, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.samu = {
    isNormalUser = true;
    description = "Samuele Facenda";
    hashedPassword = "$y$j9T$uT/2s7MBr3VdlbSg9VOly.$01sbSx0zeTs2axvuJZOdpEs3Xreti2XMaPm.RSuaj/7";
    extraGroups = [ "networkmanager" "wheel" "video" ];

    # change default shell
    shell = pkgs.zsh;
  };

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
  services.printing.enable = true;
  # services.printing.cups-pdf.enable = true;
  # auto-discover
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
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

  # enable zsh system-wide
  programs.zsh.enable = true;

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

    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (
      let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSUserEnv (base // {
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

  environment.sessionVariables = {
    EDITOR = "micro";
    VISUAL = "micro";
  };
  environment.localBinInPath = true;

  # for electron (e.g. vscode) in wayland, currenty broken (sometimes)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # add nixos to user agent string
  nix.settings.user-agent-suffix = "NixOS unstable";

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

  # burp suite certificate
  security.pki.certificateFiles = [
    ../assets/burpsuiteca.pem
  ];


  services.kmscon = {
    enable = false; # buggy and not very good looking in multi monitor
    extraConfig = with config.services.xserver.xkb; ''
      xkb-layout=${layout}
      xkb-options=${options}
    '';
  };
  console = {
    packages = [ pkgs.powerline-fonts ];
    font = "ter-powerline-v32n.psf.gz";
    useXkbConfig = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
