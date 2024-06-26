{ lib, config, pkgs, nixpkgs, nix-gc-env, self, ... }:

{
  imports = [
    nix-gc-env.nixosModules.default
  ];

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
    # pure-eval = true;
    max-jobs = "auto";
    log-lines = 20;
    # keep-going = true;
    user-agent-suffix = "NixOS unstable";

    trusted-substituters = [
      "https://cache.nixos.org/"
      "https://nixpkgs-wayland.cachix.org"
      "https://ros.cachix.org"
    ];

    trusted-public-keys = [
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
    ];

    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
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

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    delete_generations = "+" + builtins.toString config.boot.loader.systemd-boot.configurationLimit;
    randomizedDelaySec = "15min";
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
}
