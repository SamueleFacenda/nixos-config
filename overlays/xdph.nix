self: super: {
  xdg-desktop-portal-hyprland = super.xdg-desktop-portal-hyprland.overrideAttrs {
    patches = [
      (super.fetchpatch {
        url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/c5b30938710d6c599f3f5cd99a3ffac35381fb0f.patch";
        hash = "sha256-f9OgW9tLuGuHXYH6bR1Y+CEuBPHOhRiHfEPebJzlwK8=";
      })
    ];
  };
}
