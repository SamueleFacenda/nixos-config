# Delete all historical versions older than 7 days
# sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# Run garbage collection after wiping history
# sudo nix store gc --debug

{ lib, pkgs, self, ... }:
let
  inherit (builtins) toString;
in {
  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
    ];
    
    # nix community`s cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 8;
  # boot.loader.grub.configurationLimit = 10;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # only for a flake system
  system.autoUpgrade = {
    enable = true;
    flake = "/nixos-config" ;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L" # print build logs
    ];
    
    dates = "weekly";
    randomizedDelaySec = "20min";
    persistent = true; # so I don't miss the update if the system is down
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}
