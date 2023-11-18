{ trashy, hyprgrass, self, ... }:

(final: prev:
let
  sys = prev.system;
  pk = self.packages.${sys};
in
{

  trashy = trashy.defaultPackage."${prev.system}";

  inherit (pk)
    monofurx
    libcamera-surface
    xdg-desktop-portal-shana;

  # use the overwritten ranger
  xdg-desktop-portal-termfilechooser = pk.xdg-desktop-portal-termfilechooser.override { inherit (final) ranger; };

  # override to use hyprland from my nixpkgs instead of the flake one
  hyprgrass = hyprgrass.packages."${prev.system}".default.override { inherit (prev) hyprland; };

})
