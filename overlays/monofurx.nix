{ self, ... }:

(final: prev: {
  monofurx = self.packages."${prev.system}".monofurx;
})
