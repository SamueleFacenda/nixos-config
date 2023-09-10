{hyprgrass, ...}:

(self: super: {
  hyprgrass = hyprgrass.packages."${self.system}".default.override {
    inherit (self) hyprland;
  };
})
