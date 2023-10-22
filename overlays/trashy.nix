{ trashy, ... }:

(self: super:{
  trashy = trashy.defaultPackage."${super.system}";
})
