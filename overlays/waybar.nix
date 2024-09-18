self: super: {
  waybar = super.waybar.overrideAttrs rec {
    version = "0.11.0";
    src = super.fetchFromGitHub {
      owner = "Alexays";
      repo = "Waybar";
      rev = "refs/tags/${version}";
      sha256 = "3lc0voMU5RS+mEtxKuRayq/uJO09X7byq6Rm5NZohq8=";
    };
    patches = [
      # Fix a regression introduced in release 0.11.0
      # TODO: remove this patch when updating to the next release
      # Issue: https://github.com/Alexays/Waybar/issues/3597
      # PR: https://github.com/Alexays/Waybar/pull/3604
      (super.fetchpatch {
        name = "fix-tray";
        url = "https://github.com/Alexays/Waybar/commit/0d02f6877d88551ea2be0cd151c1e6354e208b1c.patch";
        hash = "sha256-wpdK6AY+14jt85dOQy6xkh8tNGDN2F9GA9zOfAuOaIc=";
      })
    ];
  };

}
