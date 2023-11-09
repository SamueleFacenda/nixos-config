{ trashy, hyprgrass, self, ... }:

(final: prev:{

  trashy = trashy.defaultPackage."${prev.system}";

  inherit (self.packages."${prev.system}")
    monofurx
    libcamera-surface
    xdg-desktop-portal-termfilechooser
    xdg-desktop-portal-shana;

  # override to use hyprland from my nixpkgs instead of the flake one
  hyprgrass = hyprgrass.packages."${prev.system}".default.override { inherit (prev) hyprland; };

})
