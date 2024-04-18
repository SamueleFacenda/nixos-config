# Overlays

`default.nix` is a nixos module that imports all the overlays.

`new-packages.nix` is an overlay that needs to be called with the flake
inputs as parameters in a set and adds the packages from this flake
in nixpkgs.

All the other files are simple overlays

> [!NOTE] 
> Hyprland is overlayed globally in the flake, in order to use the right version everywhere
