{ self, ... }:

(final: prev: {
  inherit (self.packages."${prev.system}") xdg-desktop-portal-termfilechooser;
})
