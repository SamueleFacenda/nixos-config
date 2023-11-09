{ trashy, hyprgrass, ... }:

(self: super:{

  trashy = trashy.defaultPackage."${super.system}";

  inherit (self.packages."${super.system}")
    monofurx
    libcamera-surface
    xdg-desktop-portal-termfilechooser
    xdg-desktop-portal-shana;

  # override to use hyprland from my nixpkgs instead of the flake one
  hyprgrass = hyprgrass.packages."${self.system}".default.override { inherit (self) hyprland; };

})
