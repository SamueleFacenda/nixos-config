{ trashy, hyprgrass, hyprfocus, hyprland, self, ... }:

(final: prev:
let
  sys = prev.system;
  pk = self.packages.${sys};
in
{

  trashy = trashy.defaultPackage.${prev.system};

  inherit (pk)
    monofurx
    libcamera-surface
    xdg-desktop-portal-shana
    xdg-desktop-portal-termfilechooser;

  # override to use hyprland from my nixpkgs instead of the flake one (edit. no, I use the hyprland from the flake)
  hyprgrass = hyprgrass.packages.${prev.system}.default; # .override { inherit (final) hyprland; };
  # hyprgrass = hyprgrass.packages.${prev.system}.default;

  hyprfocus = hyprfocus.packages.${prev.system}.default;
  hyprland = hyprland.packages.${prev.system}.hyprland;
})
