{ trashy, hyprgrass, hyprfocus, hyprland, hycov, self, ... }:

(final: prev:
let
  sys = prev.system;
  pk = self.packages.${sys};
in
{
  inherit (pk)
    monofurx
    libcamera-surface
    xdg-desktop-portal-shana
    xdg-desktop-portal-termfilechooser;

  # Packages with overwritten dependencies
  hyprland-virtual-desktops = pk.hyprland-virtual-desktops.override { inherit (final) hyprland; };

  # Flake packages
  hyprgrass = hyprgrass.packages.${sys}.default;
  hyprfocus = hyprfocus.packages.${sys}.default;
  hyprland = hyprland.packages.${sys}.hyprland;
  hycov = hycov.packages.${sys}.hycov;
  trashy = trashy.defaultPackage.${sys};
})
