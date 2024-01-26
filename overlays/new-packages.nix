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

  hyprland-virtual-desktops = pk.hyprland-virtual-desktops.override {inherit (hyprland.packages.${sys}) hyprland;};
  hyprgrass = hyprgrass.packages.${sys}.default; # .override { inherit (final) hyprland; };
  hyprfocus = hyprfocus.packages.${sys}.default;
  hyprland = hyprland.packages.${sys}.hyprland;
  hycov = hycov.packages.${sys}.hycov;
  trashy = trashy.defaultPackage.${sys};
})
