{ lib, config, pkgs, nixpkgs, nix-index-database, self, ... }:

{

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = 1;
  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  nix.settings = {
    use-xdg-base-directories = true;
    warn-dirty = false;
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
    pure-eval = false;
    max-jobs = "auto";
    log-lines = 20;
    keep-going = false;
    user-agent-suffix = "NixOS unstable";

    trusted-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://ros.cachix.org"
    ];

    trusted-public-keys = [
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
    ];
  };

  nix.extraOptions = lib.mkIf (config.age.secrets ? nix-access-tokens) ''
    !include ${config.age.secrets.nix-access-tokens.path}
  '';

  nix.registry = {
    # shortcut to this flake
    samu = {
      from = {
        id = "samu";
        type = "indirect";
      };
      to = {
        path = "/nixos-config";
        type = "path";
      };
    };
    templates = {
      from = {
        id = "templates";
        type = "indirect";
      };
      to = {
        id = "samu";
        type = "indirect";
      };
    };
  };

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 12;
  # boot.loader.grub.configurationLimit = 10;
  
  # Nix alternative cli
  programs.nh = {
    enable = true;
    flake = config.nix.registry.samu.to.path;
    # Perform garbage collection weekly to maintain low disk usage
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep ${builtins.toString config.boot.loader.systemd-boot.configurationLimit}";
    };
  };

  # only for a flake system
  system.autoUpgrade = {
    enable = false; # !!
    flake = "samu";
    flags = [
      "--update-input"
      "nixpkgs"
      #"--commit-lock-file"
      "-L" # print build logs
    ];

    dates = "Sun *-*-* 00:00:00";
    randomizedDelaySec = "20min";
    persistent = true; # so I don't miss the update if the system is down
  };

  # Make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  nix.nixPath = [ "/etc/nix/inputs" ];

  # OOM Settings (help preventing system freezes) (https://discourse.nixos.org/t/nix-build-ate-my-ram/35752)
  systemd.services.nix-daemon.serviceConfig.OOMScoreAdjust = 250;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  nix.daemonIOSchedPriority = 6; # 7 lowest, 0 higher priority
  # systemd.slices."nix-daemon".sliceConfig = {
  #   ManagedOOMMemoryPressure = "kill";
  #   ManagedOOMMemoryPressureLimit = "50%";
  # };
  # systemd.services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";
  
  
  # Nix index db (command not found)
  imports = [
    nix-index-database.nixosModules.nix-index
  ];
  programs.nix-index-database.comma.enable = true;
}
