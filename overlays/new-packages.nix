{ hyprgrass, hyprfocus, self, ... }:

(final: prev:
let
  sys = prev.system;
  pk = self.packages.${sys};
in
{
  inherit (pk)
    monofurx
    libcamera-surface
    hyprland-virtual-desktops
    hyprswitch
    hypr-shellevents
    Hyprspace
    xdg-desktop-portal-termfilechooser;

  # Flake packages
  hyprgrass = hyprgrass.packages.${sys}.default;
  hyprfocus = hyprfocus.packages.${sys}.default;
})
