# Delete all historical versions older than 7 days
# sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# Run garbage collection after wiping history
# sudo nix store gc --debug

{ lib, pkgs, ... }:

{
  # ...

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 8;
  # boot.loader.grub.configurationLimit = 10;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
 };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;
}
