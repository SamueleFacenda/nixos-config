{config, pkgs, stylix, ...}:

{
  imports = [
    stylix.nixosModules.stylix
  ];
  stylix.image = ../assets/bg2.png;
  stylix.polarity = "dark";
}
