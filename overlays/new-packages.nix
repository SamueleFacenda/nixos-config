{ self, ... }:

(final: prev: {
  inherit (self.packages.${prev.system})
    monofurx
    libcamera-surface
    hyprland-virtual-desktops
    hyprswitch
    hypr-shellevents
    Hyprspace
    xdg-desktop-portal-termfilechooser;
})
