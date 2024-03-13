self: super: {
  flameshot = super.flameshot.overrideAttrs {
    cmakeFlags = [
      (super.lib.cmakeBool "USE_WAYLAND_GRIM" true)
      (super.lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
    ];
  };
}
