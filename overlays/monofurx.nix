{ self, ... }:

(final: prev: {
  inherit (self.packages."${prev.system}") monofurx;
})
