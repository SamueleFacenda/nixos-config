{ self, ... }:

(final: prev: {
  xdg-desktop-portal-shana = self.packages."${prev.system}".xdg-desktop-portal-shana;
})
