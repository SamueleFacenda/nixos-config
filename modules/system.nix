{ config, pkgs, nixpkgs, ... }:

{

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.udisks2.enable = true;

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # enable zsh system-wide
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.samu = {
    isNormalUser = true;
    description = "Samuele Facenda";
    hashedPassword = "$y$j9T$uT/2s7MBr3VdlbSg9VOly.$01sbSx0zeTs2axvuJZOdpEs3Xreti2XMaPm.RSuaj/7";
    extraGroups = [ "networkmanager" "wheel" "surface-control"];

    # change default shell
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
		micro
		git
		curl
		neofetch
		ranger
		trashy
		networkmanager
		wakatime
		linux-firmware
		gnumake

		# Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
	    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
	      pkgs.buildFHSUserEnv (base // {
	      name = "fhs";
	      targetPkgs = pkgs: (
	        (base.targetPkgs pkgs) ++ (with pkgs; [
	          pkg-config
	          ncurses
	          libseccomp
	          glibc
	          glib
	        ])
	      );
	      profile = "export FHS=1";
	      runScript = "zsh";
	      extraOutputsToInstall = ["dev"];
	    }))
  ];

  environment.variables = {
  	EDITOR = "micro";
  	VISUAL = "micro";
  };

  # for vscode in wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  fonts = {
   fonts = with pkgs; [
     # icon fonts
     material-design-icons

     # normal fonts
     noto-fonts
     noto-fonts-cjk
     noto-fonts-emoji

     # nerdfonts
     (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Monofur"]; })
  ];

   # use fonts specified by user rather than default ones
   enableDefaultFonts = false;

   # user defined fonts
   # the reason there's Noto Color Emoji everywhere is to override DejaVu's
   # B&W emojis that would sometimes show instead of some Color emojis
   fontconfig.defaultFonts = {
     serif = [ "Noto Serif" "Noto Color Emoji" ];
     sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
     monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
     emoji = [ "Noto Color Emoji" ];
   };
 };

  # Make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  nix.nixPath = ["/etc/nix/inputs"];

  # burp suite certificate
  security.pki.certificateFiles = [
  	../assets/burpsuiteca.pem
  ];
  
  # enable plymouth
  boot.plymouth.enable = true;
}
