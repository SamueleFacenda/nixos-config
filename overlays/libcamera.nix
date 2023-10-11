{ self, ... }:

(final: prev: {
  inherit (self.packages."${prev.system}") libcamera-surface;
})
