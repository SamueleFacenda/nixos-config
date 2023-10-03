{ config, pkgs, ...}:{
  services.flameshot.enable = false;
  services.flameshot.settings = with config.lib.stylix.colors.withHashtag; {
    General = {
      uiColor = "${brown}";
      contrastUiColor = "${base07}";
    };
  };
}
