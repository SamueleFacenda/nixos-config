{ hyprgrass, ... }:

(self: super: {
  hyprgrass = hyprgrass.packages."${self.system}".default.override {
    # override to use hyprland from nixpkgs instead of the flake one
    inherit (self) hyprland;
  };
})
