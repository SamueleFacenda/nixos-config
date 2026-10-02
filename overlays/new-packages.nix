{ self, ... }:

(final: prev: {
  inherit (self.packages.${prev.stdenv.hostPlatform.system})
    monofurx
    libcamera-surface
    hyprland-virtual-desktops
    hyprswitch
    hypr-shellevents
    donsetch
    Hyprspace
    x-typewriter
    xdg-desktop-portal-termfilechooser;
  inherit (self.packages.${prev.stdenv.hostPlatform.system}.python3)
      trmnl-calendar;
})
