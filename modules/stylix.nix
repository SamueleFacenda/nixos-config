{ config, pkgs, stylix, ... }: {
  imports = [
    stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;

    # inherit (config.home-manager.users.samu.stylix) fonts;

    autoEnable = true;
    image = ../assets/bg7.png;
    polarity = "dark";

    base16Scheme = {
      # custom color scheme, based on nord, less blue on main colors
      base00 = "323436"; # darker main
      base01 = "404246"; # ligher than main
      base02 = "4C4C52"; # even lighter
      base03 = "515663"; # dark grey, even lighter but dark
      base04 = "D8DEE9"; # light gray
      base05 = "E5E9F0"; # middle gray (title text)
      base06 = "ECEFF4"; # light dirty white
      base07 = "8FBCBB"; # green/blue light (text light micro?)
      base08 = "BF616A"; # red
      base09 = "D08770"; # orange
      base0A = "EBCB8B"; # yellow border & details
      base0B = "A3BE8C"; # green
      base0C = "88C0D0"; # frozen light blue (official cyan)
      base0D = "81A1C1"; # cyan pastello (official blue)
      base0E = "B48EAD"; # purple (dark pink warning) (magenta offiacial)
      base0F = "5E81AC"; # blue (offial brown)
    };

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
  };
}
