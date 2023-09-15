{config, pkgs, stylix, ...}:

{
  imports = [
    stylix.nixosModules.stylix
  ];
  stylix = {
    autoEnable = false;
    image = ../assets/bg2.png;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    opacity = {
      desktop = 0.5;
      applications = 0.95;
      terminal = 0.80;
      popups = 0.95;
    };

    targets = {
      feh.enable = false;
      gnome.enable = false;
      grub.enable = false;

    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 14;
      };
    };
  };
}
